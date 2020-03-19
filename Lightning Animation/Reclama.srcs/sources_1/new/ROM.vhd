
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ROM_memory is
port(
  I: in std_logic_vector(1 downto 0); --selectia folosita la switchuri pt a selecta cuvantul
  cuv:buffer std_logic_vector(19 downto 0) --4 litere codificate pe 5 biti
  );
end ROM_memory;

architecture R of ROM_memory is

type mem is array(0 to 3) of std_logic_vector(19 downto 0); --4 cuvinte in memorie a cate 4 litere fiecare, codificate pe 5 biti 

signal my_rom : mem := (      
B"00011_01111_01100_00001", --COLA
B"01000_01111_10000_00101", --HOPE
B"00110_10000_00111_00001", --CEAI
B"10100_10011_00011_01110", --UTCN
others => B"00011_00111_01000_00001");

begin

cuv<= my_rom(conv_integer(I)); --efectiv converteste numarul cuvantului aflat in memorie din binar in intreg
 

end R;
