library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DataMemory is
    port ( clk : in std_logic;
           MemWrite : in std_logic;
           inALURes : in std_logic_vector(15 downto 0);
           RD2 : in std_logic_vector(15 downto 0);
           MemData : out std_logic_vector(15 downto 0);
           outALURes : out std_logic_vector(15 downto 0));
end DataMemory;

architecture Behavioral of DataMemory is

component RAM
    port ( clk : in std_logic;
           we : in std_logic;
           en : in std_logic;
           addr : in std_logic_vector(15 downto 0);
           din : in std_logic_vector(15 downto 0);
           dout : out std_logic_vector(15 downto 0));
end component;

begin
    outALURes <= inALURes;
    label_RAM: RAM port map (clk=>clk, we=>MemWrite, en=>'1',addr=> inALURes, din=>RD2,dout=> MemData);    
end Behavioral;