library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SSDisplay is
port(
CLK : in std_logic;
Digit0 : in std_logic_vector(4 downto 0);
Digit1 : in std_logic_vector(4 downto 0);
Digit2 : in std_logic_vector(4 downto 0);
Digit3 : in std_logic_vector(4 downto 0);
AN : out std_logic_vector(3 downto 0);
CAT : out std_logic_vector(6 downto 0)
);

end SSDisplay;

architecture Behavioral of SSDisplay is

signal Count : std_logic_vector(16 downto 0);
signal HEX : std_logic_vector(4 downto 0);

begin
------------------------COUNTER
process (CLK)
begin
if CLK='1' and CLK'event then
Count <= Count + '1';
end if;
end process;
----------------------MUX1
with Count(16 downto 15) SELECT
   AN<= "1110" when "00", 
        "1101" when "01",
        "1011" when "10",
        "0111" when "11",
        "1111" when others; 
        
 -------------------------MUX2
 
 with Count(16 downto 15) SELECT
    HEX<= Digit0 when "00", 
          Digit1 when "01",
          Digit2 when "10",
          Digit3 when "11",
         "1111" when others;        
        
        
---------------------HEX TO 7 SEG
with HEX SELECT
   CAT<= "1111111" when "00000",   --SPACE
         "0001000" when "00001",   --A
         "0000011" when "00010",   --b
         "1000110" when "00011",   --C
         "0100001" when "00100",   --d
         "0000110" when "00101",   --E
         "0001110" when "00110",   --F
         "0000010" when "00111",   --G
         "0001001" when "01000",   --H
         "1111001" when "01001",   --I
         "1100001" when "01010",   --J
         "0001111" when "01011",   --k
         "1000111" when "01100",   --L
         "0101010" when "01101",   --m
         "0101011" when "01110",   --n
         "1000000" when "01111",   --O
         "0001100" when "10000",   --P
         "0101111" when "10001",   --r
         "0010010" when "10010",   --S
         "1001110" when "10011",   --T
         "1000001" when "10100",   --U
         "1100011" when "10101",   --v
         "0110110" when "10110",   --x
         "0011001" when "10111",   --Y
         "0100100" when "11000",   --Z
         "1111111" when "11111", -- NONE
         "1111111" when others;
         
         
end Behavioral;