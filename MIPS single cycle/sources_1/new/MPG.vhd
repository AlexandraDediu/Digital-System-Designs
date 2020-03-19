library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity MPG is
    PORT(CLK: IN std_logic; -- master clock
         BTN: IN std_logic;
         ENABLE: OUT std_logic);
end MPG;

architecture Behavioral of MPG is
    SIGNAL e_counter: std_logic;
    SIGNAL ce_reg: std_logic;
    
    signal reg_12: std_logic;
    signal reg_23: std_logic;
    signal reg_3: std_logic;
begin
    -- conectarea prin asocierea de nume
    NUMARATOR: process(CLK)
        variable valoare: std_logic_vector(31 downto 0) := (others => '0'); -- facem tot numarul 0
    begin
        IF(RISING_EDGE(CLK)) THEN
            IF(valoare = x"FFFF") THEN
                valoare := (others=>'0');
            ELSE
                valoare := valoare + x"0001";
            END IF;
        END IF;
        
        IF(valoare = x"FFFF") THEN
            e_counter <= '1';
        ELSE
            e_counter <= '0';
        END IF;
    end process NUMARATOR;
        
    -- registrii
    REG1: process(CLK, BTN, e_counter)
    begin
        IF(e_counter = '1') THEN
            IF(RISING_EDGE(CLK)) THEN
                reg_12 <= BTN;
            END IF;
        END IF;
    end process REG1;
    
    REG2: process(CLK, reg_12)
    begin
        IF(RISING_EDGE(CLK)) THEN
            reg_23 <= reg_12;
        END IF;
    end process REG2;
    
    
    REG3: process(CLK, reg_23)
    begin
        IF(RISING_EDGE(CLK)) THEN
            reg_3 <= reg_23;
        END IF;
    end process REG3;
    
    ENABLE <= reg_23 AND  NOT(reg_3);
end Behavioral;
