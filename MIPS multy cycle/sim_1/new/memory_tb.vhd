----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/11/2019 08:19:50 AM
-- Design Name: 
-- Module Name: memory_tb - Behavioral
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

entity memory_tb is
--  Port ( );
end memory_tb;

architecture Behavioral of memory_tb is

component  Memory is
  Port (addr: in std_logic_vector(31 downto 0);
       dataIn:in std_logic_vector(31 downto 0);
       dataOut:out std_logic_vector(31 downto 0);
       we:in std_logic;
       en: in std_logic;
       clk:in std_logic
   );
end component;
signal addr:  std_logic_vector(31 downto 0);
signal    dataIn: std_logic_vector(31 downto 0);
signal       dataOut: std_logic_vector(31 downto 0); 
signal      we: std_logic;
signal      en:  std_logic;
signal       clk: std_logic;

 constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin
uut: Memory port map( addr=>addr,
dataIn => dataIn,
dataOut=> dataOut,
we=>we,
en=>en,
clk=>clk);

stimulus: process
  begin
  
    -- Put initialisation code here
    en <= '1';
    we <= '0';
    
    dataIn<="00000000000000000000000000000011";
    wait for 10 ns;
    
    we <= '1';
    dataOut <= "00000000000000000000000000001111";
    wait for 10 ns;
    
    we <= '0';
    wait for 10 ns;
    
    

 -- Put test bench stimulus code here

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;
    
    

end Behavioral;
