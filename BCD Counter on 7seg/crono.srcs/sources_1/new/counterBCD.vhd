library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity counterBCD is
 Port ( 
 ck100MHz: in std_logic;
 resCnt: in std_logic;
 enCnt: in std_logic;   
 data: out unsigned(15 downto 0));  --could not be used as counter
end counterBCD;

architecture Behavioral of counterBCD is
constant cstPresc : integer:=1000000;
signal cntPresc: integer range 0 to cstPresc -1;
signal ck100Hz :std_logic;
signal cntBcd:unsigned (15 downto 0);

begin
 prescaller: process(ck100Mhz, resCnt)
 begin
    if resCnt = '1' then cntPresc <=0;
        elsif rising_edge(ck100MHz) then 
            if enCnt ='1' then
                if cntPresc = cstPresc -1 then 
                    cntPresc <=0;
                    ck100Hz <='1';
                 else 
                    cntPresc <= cntPresc +1;
                    ck100Hz <='0';
                end if;
            end if;
    end if;
end process;

 BcdCounter: process(ck100Hz, resCnt)
 begin
 if resCnt = '1' then cntBcd <=(others =>'0');
 elsif rising_edge(ck100Hz) then
    if enCnt = '1' then
        if cntBcd (3 downto 0) ="1001" then --if digit is 9
            cntBcd (3 downto 0) <="0000";
            if cntBcd ( 7 downto 4) ="1001" then
                cntBcd (7 downto 4) <="0000";
                if cntBcd ( 11 downto 8) =x"9" then
                    cntBcd (11 downto 8) <=x"0";
                    if cntBcd ( 15 downto 12) ="1001" then
                        cntBcd (15 downto 12) <="0000";
                    else 
                        cntBcd (15 downto 12) <= cntBcd (15 downto 12) +1;
                    end if;
                else 
                    cntBcd (11 downto 8) <= cntBcd (11 downto 8) +1;
                end if;
            else
                cntBcd (7 downto 4) <= cntBcd (7 downto 4) +1;
            end if;                    
        else
            cntBcd (3 downto 0) <= cntBcd (3 downto 0) +1;
        end if;
    end if;
end if;                                        
end process;

data <= cntBcd;
                                
end Behavioral;
