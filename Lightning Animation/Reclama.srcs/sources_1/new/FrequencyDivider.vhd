
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity clock_divider is
Port (
      clk_in: in STD_LOGIC;
      reset: in STD_LOGIC;
      clk_out: out STD_LOGIC
      );
end clock_divider;



architecture CD of clock_divider is
signal temporal: STD_LOGIC;
signal COUNTER: integer range 0 to 90_000_000:=0; --numaratorul din divizor
begin
    frequency_divider:process( reset, clk_in)
    begin
    if( reset='1') then
        temporal<='0';
        COUNTER<=0;
    elsif rising_edge (clk_in) then
     if(COUNTER=90_000_000) then
        temporal<=NOT(temporal);
        COUNTER<=0;
    else
        COUNTER<=COUNTER+1;
    end if;
    end if;
   end process;

clk_out<=temporal;
end CD;
