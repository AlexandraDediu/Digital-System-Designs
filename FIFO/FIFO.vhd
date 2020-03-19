----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/29/2019 09:48:32 AM
-- Design Name: 
-- Module Name: FIFO - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FIFO is
  Port (rd, wr, wrinc, rdinc, rst, clk: in std_logic;
        data_in: in std_logic_vector(7 downto 0)
        --data_out: out  std_logic_vector(7 downto 0)
        );
end FIFO;

architecture Behavioral of FIFO is
signal rd_pointer, wr_pointer: std_logic_vector(2 downto 0);
signal fifo0, fifo1, fifo2, fifo3, fifo4, fifo5, fifo6, fifo7: std_logic_vector(7 downto 0);
signal dout, dataout: std_logic_vector(7 downto 0);
signal sseg: std_logic_vector(6 downto 0);
signal an: std_logic_vector(3 downto 0);

component displ_7seg is
	port (  clk, rst : in std_logic;
		    data : in std_logic_vector (7 downto 0);
		    cat : out std_logic_vector (6 downto 0);
		    an : out std_logic_vector (3 downto 0));
end component;
begin
    
    display: displ_7seg port map(clk=>clk, rst=>rst, data=>dout, cat=>sseg, an=>an);
 --read pointer
 process(rdinc)
 begin
    if(falling_edge(clk)) then
     if(rst='1') then
            wr_pointer <= "000";
     else
        if(rdinc='1') then 
           if(rd_pointer = "111") then 
                rd_pointer <= "000";
           rd_pointer <= rd_pointer + 1;
           end if;
        end if;
        end if;
    end if;
 end process;
    
--• Write pointer
 --read pointer
 process(wrinc)
 begin
    if(falling_edge(clk)) then
        if(rst='1') then
            wr_pointer <= "000";
         else
          if(wrinc='1') then 
           if(wr_pointer = "111") then 
                wr_pointer <= "000";
           wr_pointer <= wr_pointer + 1;
           end if;
      end if;
    end if;
    end if;
 end process;
 
--• Decoder
    process(wr)
    begin
        if(falling_edge(clk)) then 
        if(wr='1') then
         case(wr_pointer) is
                 when "000" => fifo0 <= data_in;
                 when "001" => fifo1 <= data_in;
                 when "010" => fifo2 <= data_in;
                 when "011" => fifo3 <= data_in;
                 when "100" => fifo4 <= data_in;
                 when "101" => fifo5 <= data_in;
                 when "110" => fifo6 <= data_in;
                 when "111" => fifo7 <= data_in;
         end case;
        end if;
       end if;
    end process;
    
--• Register set
    process(rst)
    begin
    if(falling_edge(clk)) then 
        if(rst='1') then
         fifo0 <= (OTHERS => '0');
         fifo1 <= (OTHERS => '0');
         fifo2 <= (OTHERS => '0');
         fifo3 <= (OTHERS => '0');
         fifo4 <= (OTHERS => '0');
         fifo5 <= (OTHERS => '0');
         fifo6 <= (OTHERS => '0');
         fifo7 <= (OTHERS => '0');
        end if;
    end if;
    end process;

--• Multiplexer
    process(rdinc)
    begin
        case(rd_pointer) is
             when "000" => dout <= fifo0;
             when "001" => dout <= fifo1;
             when "010" => dout <= fifo2;
             when "011" => dout <= fifo3;
             when "100" => dout <= fifo4;
             when "101" => dout <= fifo5;
             when "110" => dout <= fifo6;
             when "111" => dout <= fifo7;
        end case;
    end process;
    
--• Tri-state buffer
    
    process(rd)
    begin
        if(rd='1') then
          dataout <= dout;
        else
         dataout <= "ZZZZZZZZ";
        end if;
    end process;

end Behavioral;
