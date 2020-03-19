library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity instreg_tb is
end;

architecture bench of instreg_tb is

  component instreg
  PORT (
  clk : IN STD_ULOGIC;
  rst_n : IN STD_ULOGIC;
  memdata : IN STD_ULOGIC_VECTOR(31 DOWNTO 0);
  IRWrite : IN STD_ULOGIC;
  instr_31_26 : OUT STD_ULOGIC_VECTOR(5 DOWNTO 0);
  instr_25_21 : OUT STD_ULOGIC_VECTOR(4 DOWNTO 0);
  instr_20_16 : OUT STD_ULOGIC_VECTOR(4 DOWNTO 0);
  instr_15_0 : OUT STD_ULOGIC_VECTOR(15 DOWNTO 0) );
  end component;

  signal clk: STD_ULOGIC;
  signal rst_n: STD_ULOGIC;
  signal memdata: STD_ULOGIC_VECTOR(31 DOWNTO 0);
  signal IRWrite: STD_ULOGIC;
  signal instr_31_26: STD_ULOGIC_VECTOR(5 DOWNTO 0);
  signal instr_25_21: STD_ULOGIC_VECTOR(4 DOWNTO 0);
  signal instr_20_16: STD_ULOGIC_VECTOR(4 DOWNTO 0);
  signal instr_15_0: STD_ULOGIC_VECTOR(15 DOWNTO 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: instreg port map ( clk         => clk,
                          rst_n       => rst_n,
                          memdata     => memdata,
                          IRWrite     => IRWrite,
                          instr_31_26 => instr_31_26,
                          instr_25_21 => instr_25_21,
                          instr_20_16 => instr_20_16,
                          instr_15_0  => instr_15_0 );

  stimulus: process
  begin
  
    -- Put initialisation code here

    memdata <= "00000100010000110000000000000100";

    rst_n <= '0';
    wait for 5 ns;
    rst_n <= '1';
    wait for 5 ns;
    
    IRWrite <= '1';
    wait for 5 ns;
    
   
    -- Put test bench stimulus code here

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;