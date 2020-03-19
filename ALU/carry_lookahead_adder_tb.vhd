
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity carry_lookahead_adder_tb is
--  Port ( );
end carry_lookahead_adder_tb;

architecture Behavioral of carry_lookahead_adder_tb is
component carry_lookahead_adder IS
    PORT
        (
         x_in      :  IN   STD_LOGIC_VECTOR(3 DOWNTO 0);
         y_in      :  IN   STD_LOGIC_VECTOR(3 DOWNTO 0);
         carry_in  :  IN   STD_LOGIC;
         sum       :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
         carry_out :  OUT  STD_LOGIC
        );
END component;
   --Inputs
   signal x_in : std_logic_vector(3 downto 0) := (others => '0');
   signal y_in : std_logic_vector(3 downto 0) := (others => '0');
   signal carry_in: std_logic := '0';

 	--Outputs
   signal sum : std_logic_vector(3 downto 0);
   signal carry_out : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant PERIOD : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut:  carry_lookahead_adder PORT MAP (
          x_in=> x_in,
          y_in => y_in,
          carry_in => carry_in,
          sum => sum,
          carry_out => carry_out
        );



   -- Stimulus process
   stim_proc: process
   begin		
     -- insert stimulus here 

      wait for PERIOD*10;	
		x_in<="1001";
		y_in<="0010";
       carry_in<='0';
      
		wait for PERIOD*10;
		
		x_in<="0001";
		y_in<="1101";
		carry_in<='1';
		
		wait for PERIOD*10;

      wait;
   end process;




end Behavioral;
