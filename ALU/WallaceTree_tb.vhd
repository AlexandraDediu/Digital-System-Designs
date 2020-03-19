library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity WallaceTree_TB is
--  Port ( );
end wallace_TB;

architecture Behavioral of wallace_TB is

component WallaceTree is
Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           prod : out  STD_LOGIC_VECTOR (7 downto 0));
endcomponent;

signal clk: std_logic;
signal x, y: std_logic_vector(3 downto 0);
signal res: std_logic_vector(8 downto 0);

begin

portmap: WallaceTree port map (x, y, res);

process
begin

x<="0001"; --1
y<="1100"; --C
wait for 10 ns;


x<="0010"; --2
y<="10001"; --9
wait for 10 ns;


x<="0000"; --0
y<="1111"; --F
wait;


end process;

end Behavioral;