----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.05.2019 08:01:17
-- Design Name: 
-- Module Name: DivideTest - Behavioral
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

entity DivideTest is
--  Port ( );
end DivideTest;

architecture Behavioral of DivideTest is

signal A, B, quotient, remainder: std_logic_vector(15 downto 0) := x"0000";

component division is
Port ( 
 
            ina : in std_logic_vector (15 downto 0);
          inb:  in std_logic_vector (15 downto 0);
         quot:  out std_logic_vector (15 downto 0);
         rest : out std_logic_vector (15 downto 0));
 
end component;

begin

    d: division port map(ina => A, inb => B, quot => quotient, rest => remainder);
    
    process
    begin
        A <= x"0007";
        B <= x"0003";
        wait for 100 ns;
        
        A <= x"0008";
        B <= x"0004";
        wait for 100 ns;
        
        A <= x"0003";
        B <= x"0001";
        wait for 100 ns;
        
        A <= x"0002";
        B <= x"0000";
        wait for 100 ns;
        
        A <= x"ffff";
        B <= x"ffff";
        wait for 100 ns;
        
        A <= x"fffd";
        B <= x"fffe";
        wait for 100 ns;
        
        A<= x"0000";
        B <= x"0001";
        wait for 100 ns;
    
    end process;

end Behavioral;
