library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity InstructionFetch is
    Port(clk: in std_logic;
         jump_address: in std_logic_vector(15 downto 0);
         branch_address: in std_logic_vector(15 downto 0);
         jump: in std_logic;
         PCSrc: in std_logic;
         reset: in std_logic;
         en: in std_logic;
         instruction: out std_logic_vector(15 downto 0);
         next_address: out std_logic_vector(15 downto 0));
end InstructionFetch;

architecture Behavioral of InstructionFetch is

type MEMORY is array (0 to 255) of std_logic_vector(0 to 15);
signal ROM: MEMORY := (
--"0000000000000000", --NOP
"0000000000000110", -- XOR $0, %0, %0 -- Put value 0 in $0 -- 0  0006
"0010000010000001", -- ADDi $1, $0, 1 -- Put value 1 in %1 -- 1  2081
"0010000100000001", -- ADDi $2, $0, 1 -- Put value 1 in $2 -- 2  2101
"0100001000000000", --lw $4, 0($0)  4200
"0010001010000001",  -- add1 $5. $0, $1 2281
"1001001010000101",  -- beq $5, $4, 5 9285
"0000010100110000", --ADD $3, $1, $2 -- Put in $3 the sum of $2 and $1 -- 3 0530
"0010010100000000", --ADDi $2, $1, 0 -- %2=%1 -- 4  2500
"0010110010000000", --ADDi $1, $3, 0 -- $1=$3 -- 5  2C80
"0011011010000001",  -- add1 $5. $5, 1  3681
"1110000000000101", --J4 -- Jump to line 5. -- 6    E005
"1100000110000001", --sw $3, 1($0) C181
others=>x"0000"
);

signal ROM2:MEMORY:=(
"0100001100000001", --lw $6, 1($0)
"0100001110000010", --lw $7, 2($0)
"0001101110010001", --SUB $6, $7, $1 
"0001101110010100", --AND
"0001101110010101", --OR
"0001101110010110", --XOR
"0001101110010111", --SRA
"0001101110011010", --SLL
"0001101110011011", --SRL
"0000000000000000", --NOP

others=>x"0000"
);
signal M12, M23, pcAux: std_logic_vector(15 downto 0);
signal COUNTERMem: std_logic_vector(15 downto 0) := x"0000";

begin
     MUX_1: process(PCSrc, pcAux, branch_address)
     begin
         case PCSrc is
             when '0' => M12 <= pcAux;
             when '1' => M12 <= branch_address;
         end case;
     end process MUX_1;  
     
     process(jump, M12, jump_address)
     begin
         CASE JUMP IS
             when '0' => M23 <= M12;
             when '1' => M23 <= jump_address;
         end case;
     end process; 

    process(CLK)
    begin
      if(RESET='1') then
          COUNTERMem <= x"0000";
      else
       IF rising_edge(CLK) THEN
           IF(en = '1')THEN 
               COUNTERMem <= M23;
            end if;
        end if;
      end if;
    end process;
    
    pcAux <= COUNTERMem + 1;
    instruction <= ROM(conv_integer(COUNTERMem(7 downto 0)));
    
    next_address <= pcAux;  
    
end Behavioral;



