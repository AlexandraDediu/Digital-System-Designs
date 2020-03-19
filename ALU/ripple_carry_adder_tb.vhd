----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/26/2019 10:09:57 AM
-- Design Name: 
-- Module Name: ripple_carry_adder_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ripple_carry_adder_tb is
--  Port ( );
end ripple_carry_adder_tb;

architecture Behavioral of ripple_carry_adder_tb is
component ripple_carry_adder_generate is
 
Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
B : in STD_LOGIC_VECTOR (3 downto 0);
Cin : in STD_LOGIC;
S : out STD_LOGIC_VECTOR (3 downto 0);
Cout : out STD_LOGIC);
end component;

--Inputs
   signal A : std_logic_vector(3 downto 0) := (others => '0');
   signal B : std_logic_vector(3 downto 0) := (others => '0');
   signal Cin : std_logic := '0';

 	--Outputs
   signal S : std_logic_vector(3 downto 0);
   signal Cout : std_logic;
   
   constant PERIOD : time := 10 ns;

begin
-- Instantiate the Unit Under Test (UUT)
   uut: ripple_carry_adder_generate PORT MAP (
          A => A,
          B => B,
          Cin => Cin,
          S => S,
          Cout => Cout
        );



   -- Stimulus process
   stim_proc: process
   begin		
     -- insert stimulus here 

      wait for PERIOD*10;	
		A<="1001";
		B<="0010";
        Cin<='0';
      
		wait for PERIOD*10;
		
		A<="0001";
		B<="1101";
		Cin<='1';
		
		wait for PERIOD*10;

      wait;
   end process;

end Behavioral;
