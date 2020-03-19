library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity reg_a_tb is
end;

architecture Behavioral of reg_a_tb is

  component regA is
  Port (dataIn: in std_logic_vector(31 downto 0);
        clk: in std_logic;
        wr: in std_logic;
        dataOut:out std_logic_vector(31 downto 0)
  
   );
end  component;

  signal clk: std_logic;
  signal dataIn: std_logic_vector (31 downto 0);
  signal wr: std_logic;
  signal dataOut: std_logic_vector(31 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean := false;

begin

  uut: regA port map ( 
                        dataIn => dataIn,
                         clk      => clk,
                         wr=>wr,
                       
                        dataOut  => dataOut );

  stimulus: process
  begin
  
    -- Put initialisation code here
    --wait for 5 ns;
    
    dataIn <= "00000000000000000000000000000010";
   
    
    wr <= '0';
    wait for 10 ns;
    wr <= '1';
    wait for 10 ns;

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

end Behavioral;