library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ControlUnit is
    PORT(
    instruction: IN std_logic_vector(15 downto 0);
    
    ALUOp: OUT STD_logic_vector(2 downto 0);
    RegDst, RegWrite, ExtOp, ALUsrc, MemToReg, MemWrite, Branch, Jump: OUT std_logic
    );
end ControlUnit;

architecture Behavioral of ControlUnit is
    
begin
    CU: process(instruction)
    begin
        case instruction(15 downto 13) is
         when "000"=>            ----------R-type
                RegDst<='1';     
                ExtOp<='0';
                ALUSrc<='0';
                Branch<='0';
                Jump<='0';
                ALUOp<="000";
                MemWrite<='0';
                MemtoReg<='0';
                RegWrite<='1';
       
        when "001"=>            ---------addi
                 RegDst<='0';
                 ExtOp<='1';
                 ALUSrc<='1';
                 Branch<='0';
                 Jump<='0';
                 ALUOp<="001";
                 MemWrite<='0';
                 MemtoReg<='0';
                 RegWrite<='1';
                 
         when "010"=>                  --------lw
                    RegDst<='0';
                    ExtOp<='1';
                    ALUSrc<='1';
                    Branch<='0';
                    Jump<='0';
                    ALUOp<="010";
                    MemWrite<='0';
                    MemtoReg<='1';
                    RegWrite<='1'; 
         
           when "100"=>
                       RegDst<='0';   ------------beq
                       ExtOp<='1';
                       ALUSrc<='0';
                       Branch<='1';
                       Jump<='0';
                       ALUOp<="100";
                       MemWrite<='0';
                       MemtoReg<='0';
                       RegWrite<='0'; 
                       
             when "101"=>
                         RegDst<='0';------------xori
                         ExtOp<='1';
                         ALUSrc<='1';
                         Branch<='0';
                         Jump<='0';
                         ALUOp<="101";
                         MemWrite<='0';
                         MemtoReg<='0';
                         RegWrite<='1';
                               
            when "110"=>
                       RegDst<='0';------------sw
                       ExtOp<='1';
                       ALUSrc<='1';
                       Branch<='0';
                       Jump<='0';
                       ALUOp<="110";
                       MemWrite<='1';
                       MemtoReg<='0';
                       RegWrite<='0';
                           
            when "111"=>
                        RegDst<='0';------------jump
                        ExtOp<='1';
                        ALUSrc<='0';
                        Jump<='1';
                        ALUOp<="111";
                        MemWrite<='0';
                        MemtoReg<='0';
                        RegWrite<='0';
                              
            when others=>
                          RegDst<='0';
                          ExtOp<='0';
                          ALUSrc<='0';
                          Branch<='0';
                          Jump<='0';
                          ALUOp<="000";
                          MemWrite<='0';
                          MemtoReg<='0';
                          RegWrite<='0';                 
        end case;
    end process;
end Behavioral;

