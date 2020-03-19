
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity ExecutionUnit1 is
    Port ( rd1 : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : in STD_LOGIC_VECTOR (15 downto 0);
           func : in STD_LOGIC_VECTOR (2 downto 0);
           sa : in STD_LOGIC;
           alu_src : in STD_LOGIC;
           alu_op : in STD_LOGIC_VECTOR (2 downto 0);
           pcout : in STD_LOGIC_VECTOR (15 downto 0);
           zero : out STD_LOGIC;
           alu_res : out STD_LOGIC_VECTOR (15 downto 0);
           branch_addr : out STD_LOGIC_VECTOR (15 downto 0));
end ExecutionUnit1;

architecture Behavioral of ExecutionUnit1 is

signal alu_ctrl: std_logic_vector(3 downto 0);
signal alu_res_aux: std_logic_vector(15 downto 0);
signal alu_second: std_logic_vector(15 downto 0);
signal zero_aux: std_logic;

begin

--setting branch address
branch_addr <= pcout + ext_imm;
--seting second alu operand
process(alu_src)
    begin
        if alu_src = '1' then
            alu_second  <= ext_imm;
        else 
            alu_second <= rd2;
       end if;
end process; 

--setting alu controls
process(alu_op,func)
begin
	case (alu_op) is
		when "000"=>
				case (func) is
					when "000"=> alu_ctrl <="0000"; 	
					when "001"=> alu_ctrl <="0001";		
					when "010"=> alu_ctrl <="0010";		
					when "011"=> alu_ctrl <="0011";		
					when "100"=> alu_ctrl <="0100";		
					when "101"=> alu_ctrl <="0101";		
					when "110"=> alu_ctrl <="0110";		
					when "111"=> alu_ctrl <="0111";		
					when others=> alu_ctrl <="0000";	
				end case;
		when "001"=> alu_ctrl <="0000";		--addi
		when "010"=> alu_ctrl <="0000";		--lw
		when "100"=> alu_ctrl <="0001";      --beq
		when "101"=> alu_ctrl <="0110";		--xor1
		when "110"=> alu_ctrl <="0000";		--sw
		when "111"=> alu_ctrl <="1000";		--jump
		when others=> alu_ctrl <="0000";	
	end case;
end process;
-----ALU-----
process(alu_ctrl,rd1,alu_second,sa)
begin
	case(alu_ctrl) is
		when "0000" => alu_res_aux <= rd1 + alu_second;   -----ADD-----					
		when "0001" => alu_res_aux<= rd1 - alu_second;	  -----SUB-----								
		when "0010" => 				                      -----SLL-----
					case (SA) is
						when '1' => alu_res_aux <=RD1(14 downto 0) & "0";
						when others => alu_res_aux <=RD1;	
					end case;
		when "0011" => 				                            -----SRL-----
					case (SA) is
						when '1' => alu_res_aux <="0" & RD1(15 downto 1);
						when others => alu_res_aux <=RD1;
					end case;								
		when "0100" => alu_res_aux <=rd1 and alu_second;		-----AND-----							
		when "0101" => alu_res_aux <=rd1 or alu_second;		    -----OR-----									
		when "0110" => alu_res_aux <=rd1 xor alu_second;		-----XOR-----						
		when "0111" =>   -----SHIFT RIGHT ARITHMETIC-----
					case (SA) is
						when '1' => alu_res_aux <= RD1(15) & RD1(15 downto 1);
						when others => alu_res_aux <=RD1;
					end case;
					
		when "1000" => alu_res_aux <="0000000000000000";		-----JUMP-----				
		when others => alu_res_aux <="0000000000000000";		-----OTHERS-----
	end case;
end process;

process(alu_res_aux)
begin
    case (alu_res_aux) is					-----ZERO SIGNAL-----
		when "0000000000000000" => zero_aux <='1';
		when others => zero_aux <='0';
	end case;
end process;

zero <= zero_aux;
alu_res <= alu_res_aux;

end Behavioral;
