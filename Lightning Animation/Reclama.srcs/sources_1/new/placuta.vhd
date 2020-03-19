library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity placuta is
port(
clk : in STD_LOGIC;
btn : in STD_LOGIC_VECTOR(4 downto 0);
sw : in STD_LOGIC_VECTOR(15 downto 0);
an : out STD_LOGIC_VECTOR(3 downto 0);
cat : out STD_LOGIC_VECTOR(6 downto 0)
);
end placuta;

architecture Behavioral of placuta is

component SSDisplay is
port(
CLK : in std_logic;
Digit0 : in std_logic_vector(4 downto 0);
Digit1 : in std_logic_vector(4 downto 0);
Digit2 : in std_logic_vector(4 downto 0);
Digit3 : in std_logic_vector(4 downto 0);
AN : out std_logic_vector(3 downto 0);
CAT : out std_logic_vector(6 downto 0)
);

end component SSDisplay;

component Main is
port(
clk : in std_logic;
switchWord : in std_logic_vector(1 downto 0);
switchMode : in std_logic_vector(1 downto 0);
output : out std_logic_vector(19 downto 0);
rst : in std_logic
);
end component Main;

signal word : std_logic_vector(19 downto 0);

begin


LegamMain : Main port map(clk, SW(1 downto 0), SW(15 downto 14), word, BTN(0));
SSD : SSDisplay port map(clk, word(4 downto 0), word(9 downto 5), word(14 downto 10), word(19 downto 15), an , CAT);

end Behavioral;
