----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/10/2020 07:20:36 PM
-- Design Name: 
-- Module Name: top_module - Behavioral
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

entity top_module is
Port ( 
ck100Mhz: in std_logic;
btnC:in std_logic; --reset
--sw: in std_logic_vector(0 downto 0); --enable
seg: out std_logic_vector( 6 downto 0);
an : out std_logic_vector(3 downto 0);
dp: out std_logic
);
end top_module;

architecture Behavioral of top_module is
signal data : unsigned (15 downto 0);
signal enCnt, resCnt: std_logic;
signal btnCDeb :std_logic;

component ctrl7seg is
    Port ( ck100Mhz : in STD_LOGIC;
           data :in  unsigned( 15 downto 0) ;
           seg : out STD_LOGIC_vector (6 downto 0);
           an : out STD_LOGIC_vector( 3 downto 0);
           dp : out STD_LOGIC);
end component;

component counterBCD is
 Port ( 
 ck100MHz: in std_logic;
 resCnt: in std_logic;
 enCnt: in std_logic;   
 data: out unsigned(15 downto 0));  --could not be used as counter
end component;

component SSM is
Port (ck100MHz: in std_logic;
       btnC: in std_logic;
       enCnt: out std_logic;
       resCnt: out std_logic );
end component;

component debouncer is
 Port (ck100MHz: in std_logic;
 btnIn: in std_logic;
 btnOut: out std_logic );
end component;

begin

instctrl7seg: ctrl7seg
Port map(
    ck100Mhz => ck100Mhz,
    data => data,
    seg => seg,
    an => an,
    dp => dp
);

instBcd: counterBCD
Port map(
ck100Mhz => ck100Mhz,
resCnt=>rescnt,
enCnt =>enCnt,
data=>data
);

inst_SSM: SSM
  Port map(
     ck100MHz =>ck100MHz,
       btnC =>btnCDeb,
       enCnt =>enCnt,
       resCnt=>resCnt
  );

inst_deb: debouncer
Port map(
 ck100MHz => ck100MHz,
 btnIn => btnC,
 btnOut => btnCDeb
);

--resCnt <= btnC;
--enCnt <=sw(0);


end Behavioral;
