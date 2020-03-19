----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2020 05:28:37 PM
-- Design Name: 
-- Module Name: SSM - Behavioral
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

entity SSM is
 Port (ck100MHz: in std_logic;
       btnC: in std_logic;
       enCnt: out std_logic;
       resCnt: out std_logic );
end SSM;

architecture Behavioral of SSM is

type state_type is (stRes0, stRes1, stRun0, stRun1, stStop0, stStop1);
signal state, next_state: state_type:=stRes0;
begin

--description of the state register
sync_proc: process(ck100MHz) --de la code examples pt Moore
begin
  if rising_edge(ck100MHz) then
    state <=next_state;
  end if;
end process;

--description of the next state logic
next_state_decode:process(state, btnC)
begin
    next_state <= state;                --Pastreaza starea, by default
    case(state) is
        when stRes1 =>
            if btnC='1' then
                next_state <= stRun0;
            end if;
        when stRun0 =>
            if btnC='1' then
                next_state <= stRun1;
            end if;
        when stRun1 =>
            if btnC='1' then
                next_state <= stStop0;
            end if;
        when stStop0 =>
            if btnC='1' then
                next_state <= stStop1;
            end if;
        when stStop1 =>
            if btnC='1' then
                next_state <= stRes0;
            end if;
        when stRes0 =>
            if btnC='1' then
                next_state <= stRes1;
            end if;
        when others =>
            next_state <= stRes0;
    end case;
end process;

enCnt <= '1' when state = stRun0 or state = stRun1 else '0';
resCnt <= '1' when state = stRes0  else '0';

end Behavioral;
