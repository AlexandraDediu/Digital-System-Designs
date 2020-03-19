library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Main is
port(
clk : in std_logic;
switchWord : in std_logic_vector(1 downto 0);
switchMode : in std_logic_vector(1 downto 0);
output : out std_logic_vector(19 downto 0);
rst : in std_logic
);
end Main;

architecture Behavioral of Main is

component ROM_memory is
port(
     I: in std_logic_vector (1 downto 0);
     cuv: buffer std_logic_vector(19 downto 0)
     );
end component;

component clock_divider is
Port (
      clk_in: in STD_LOGIC;
      reset: in STD_LOGIC;
      clk_out: out STD_LOGIC
      );
end component clock_divider;

signal DividedClock : std_logic;
signal word : std_logic_vector(19 downto 0);
signal count : std_logic_vector(1 downto 0) := "00";
signal appear : std_logic := '0';

begin

divider : clock_divider port map(clk, rst, DividedClock); -- 
ROM  : ROM_memory port map(switchWord , word);  --adresa si cuv scos


process(clk, switchMode, DividedClock)
begin
   if ( clk = '1' and clk'EVENT) then
      if(DividedClock = '1') then
        case switchMode is
        -- FIRST APPEARANCE: shift to the right
            when "00" =>
                if(count = "00") then
                    output(14 downto 10) <= word(19 downto 15);
                    output(9 downto 5) <= word(14 downto 10);
                    output(4 downto 0) <= word(9 downto 5);
                    output(19 downto 15) <= word(4 downto 0);
                elsif(count = "01") then
                    output(14 downto 10) <= word(4 downto 0);
                    output(9 downto 5) <= word(19 downto 15);
                    output(4 downto 0) <= word(14 downto 10);
                    output(19 downto 15) <= word(9 downto 5);
                elsif(count = "10") then
                    output(14 downto 10) <= word(9 downto 5);
                    output(9 downto 5) <= word(4 downto 0);
                    output(4 downto 0) <= word(19 downto 15);
                    output(19 downto 15) <= word(14 downto 10);
                else
                    output(14 downto 10) <= word(14 downto 10);
                    output(9 downto 5) <= word(9 downto 5);
                    output(4 downto 0) <= word(4 downto 0);
                    output(19 downto 15) <= word(19 downto 15);
                end if;
         --SECOND APPEARANCE 
            when "01" =>
                if(count = "00")  then
                    output(19 downto 15) <= word(19 downto 15);
                    output(14 downto 10) <= "11111";
                    output(9 downto 5) <= "11111";
                    output(4 downto 0) <= "11111";
                elsif(count = "01") then
                    output(19 downto 15) <= word(19 downto 15);
                    output(14 downto 10) <= word(14 downto 10);
                    output(9 downto 5) <= "11111";
                    output(4 downto 0) <= "11111";
                elsif(count = "10") then
                    output(19 downto 15) <= word(19 downto 15);
                    output(14 downto 10) <= word(14 downto 10);
                    output(9 downto 5) <= word(9 downto 5);
                    output(4 downto 0) <= "11111";
                else
                    output(19 downto 15) <= word(19 downto 15);
                    output(14 downto 10) <= word(14 downto 10);
                    output(9 downto 5) <= word(9 downto 5);
                    output(4 downto 0) <= word(4 downto 0);
                end if;
                       
         -- THIRD APPEARANCE: appear/disappear
            when "10" =>
                if appear = '0' then
                    output <= X"00000";
                    appear <= '1';
                else
                    output <= word;
                    appear <= '0';
                end if;
         --FOURTH APPEARANCE: 2 and 2 letters
            when "11" =>
                if count = "00" then
                     output(14 downto 10) <= "00000";
                     output(9 downto 5) <= "00000";
                     output(4 downto 0) <= word(4 downto 0);
                     output(19 downto 15) <= word(19 downto 15);
                elsif count = "01" then
                     output(14 downto 10) <= word(14 downto 10);
                     output(9 downto 5) <= word(9 downto 5);
                     output(4 downto 0) <= "00000";
                     output(19 downto 15) <= "00000";
                else
                     output(14 downto 10) <= word(14 downto 10);
                     output(9 downto 5) <= word(9 downto 5);
                     output(4 downto 0) <= word(4 downto 0);
                     output(19 downto 15) <= word(19 downto 15);     
                end if;
            when others =>
                null;
        end case;
        count <= count + 1;
    end if;
    end if;
end process;

end Behavioral;
