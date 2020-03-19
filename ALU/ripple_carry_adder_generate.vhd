
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ripple_carry_adder_generate is
 
Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
B : in STD_LOGIC_VECTOR (3 downto 0);
Cin : in STD_LOGIC;
S : out STD_LOGIC_VECTOR (3 downto 0);
Cout : out STD_LOGIC);
end ripple_carry_adder_generate;
 
architecture Behavioral of ripple_carry_adder_generate is

component full_adder is
     Port ( A : in STD_LOGIC;
    B : in STD_LOGIC;
    Cin : in STD_LOGIC;
    S : out STD_LOGIC;
    Cout : out STD_LOGIC);
end component;


signal carry_out: std_logic_vector(4 downto 0);

begin
carry_out(0)<=Cin;

Adder: FOR k IN 3 downto 0 GENERATE
C1: full_adder PORT MAP (A(k),B(k), carry_out(k), S(k), carry_out(k+1));
END GENERATE Adder;

Cout<=carry_out(4);

end Behavioral;

