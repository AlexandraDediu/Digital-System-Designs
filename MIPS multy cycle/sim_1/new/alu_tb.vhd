
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity alu_tb is
--  Port ( );
end alu_tb;

architecture Behavioral of alu_tb is
component alu PORT (
a, b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
opcode : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
zero : OUT STD_LOGIC);
END component;

signal a, b: STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal opcode: STD_LOGIC_VECTOR(1 DOWNTO 0);
  signal result: STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal zero: STD_LOGIC;
  
begin
uut: alu port map ( a      => a,
                      b      => b,
                      opcode => opcode,
                      result => result,
                      zero   => zero );

  stimulus: process
  begin
  
    -- Put initialisation code here
    a <= "00000000000000000000000000000011";
    b <= "00000000000000000000000000000010";
    
    opcode <= "00";
    wait for 5 ns;
    
    opcode <= "01";
    wait for 5 ns;
    
    opcode <= "10";
    wait for 5 ns;
    
    opcode <= "11";

    -- Put test bench stimulus code here

    wait;
  end process;



end Behavioral;
