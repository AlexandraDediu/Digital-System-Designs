library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SSDisplay is
    PORT(CLK: IN std_logic;
         CAT: OUT std_logic_vector(6 downto 0);
         AN: OUT std_logic_vector(3 downto 0);
         
         DIGIT_1: IN std_logic_vector(3 downto 0);
         DIGIT_2: IN std_logic_vector(3 downto 0);
         DIGIT_3: IN std_logic_vector(3 downto 0);
         DIGIT_4: IN std_logic_vector(3 downto 0));
end SSDisplay;

architecture Behavioral of SSDisplay is
    signal valCounter: std_logic_vector(15 downto 0);
    signal selectie: std_logic_vector(1 downto 0);
    
    signal selectie_digit: std_logic_vector(3 downto 0);
begin
    -- COUNTER
    NUMARATOR: process(CLK)
        variable count: std_logic_vector(15 downto 0) := (others => '0');
    begin
        IF(rising_edge(CLK)) THEN
            IF(count = x"FFFF")THEN
                count := (others=>'0');
            ELSE
                count := count + x"0001";
            END IF;
        END IF;
        valCounter <= count;
    end process NUMARATOR;
    
    -- SELECTAM DIGIT
    SELECTIE <= valCounter(15)&valCounter(14);
    MUX_DIGIT: process(SELECTIE, DIGIT_1, DIGIT_2, DIGIT_3, DIGIT_4)
    begin
        case(SELECTIE) is
            when "00" => selectie_digit <= DIGIT_1;
            when "01" => selectie_digit <= DIGIT_2;
            when "10" => selectie_digit <= DIGIT_3;
            when others => selectie_digit <= DIGIT_4;
        end case;
    end process MUX_DIGIT;
    
    -- SELECTAM ANOD
    SELECTIE <= valCounter(15)&valCounter(14);
    MUX_ANOD: process(SELECTIE)
    begin
        case(SELECTIE) is
            when "00" => AN <= "1110";
            when "01" => AN <= "1101";
            when "10" => AN <= "1011";
            when others => AN <= "0111";
        end case;
    end process MUX_ANOD;
    
    -- CODIFICAM NUMERELE
    HexTo7Segments: process(selectie_digit)
    begin
        case selectie_digit is
                 when "0001" => cat <= "1111001";   --1
             when "0010" => cat <= "0100100";   --2
             when "0011" => cat <= "0110000";   --3
             when "0100" => cat <= "0011001";   --4
             when "0101" => cat <= "0010010";   --5
             when "0110" => cat <= "0000010";   --6
             when "0111" => cat <= "1111000";   --7
             when "1000" => cat <= "0000000";   --8
             when "1001" => cat <= "0010000";   --9
             when "1010" => cat <= "0001000";   --A
             when "1011" => cat <= "0000011";   --b
             when "1100" => cat <= "1000110";   --C
             when "1101" => cat <= "0100001";   --d
             when "1110" => cat <= "0000110";   --E
             when "1111" => cat <= "0001110";   --F
when others => cat <= "1000000"; --0
        end case ;
    end process HexTo7Segments;
end Behavioral;
