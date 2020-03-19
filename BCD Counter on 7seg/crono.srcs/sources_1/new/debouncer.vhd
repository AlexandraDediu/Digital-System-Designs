----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2020 06:32:55 PM
-- Design Name: 
-- Module Name: debouncer - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debouncer is
 Port (ck100MHz: in std_logic;
 btnIn: in std_logic;
 btnOut: out std_logic );
end debouncer;

architecture Behavioral of debouncer is
constant cstDeb: integer:=10000; --10000 clock periods
signal cntDeb: integer range 0 to cstDeb := 0 ; 
--signal to store the btnIn state at the previous ck edge
signal btnOld: std_logic;
begin

debouncer: process(ck100MHz)
begin
if rising_edge(ck100MHz) then
  btnOld <=btnIn; --store btln for the next cycle
    if btnOld /=btnIn then
      cntDeb <=0;--reset counter when btnIn changes
    elsif cntDeb <cstDeb then
      cntDeb <=cntDeb + 1;
    else
      btnOut <= btnOld; --deliver stable btn info
    end if;
end if;
end process;
      
end Behavioral;
