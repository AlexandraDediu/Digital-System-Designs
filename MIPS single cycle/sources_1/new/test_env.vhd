library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity test_env is
    port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;
architecture Behavioral of test_env is

component MPG is  PORT(CLK: IN std_logic; -- master clock
         BTN: IN std_logic;
         ENABLE: OUT std_logic);
end component;

component SSDisplay is
    PORT(CLK: IN std_logic;
         CAT: OUT std_logic_vector(6 downto 0);
         AN: OUT std_logic_vector(3 downto 0);
         
         DIGIT_1: IN std_logic_vector(3 downto 0);
         DIGIT_2: IN std_logic_vector(3 downto 0);
         DIGIT_3: IN std_logic_vector(3 downto 0);
         DIGIT_4: IN std_logic_vector(3 downto 0));
end component;

component InstructionFetch is
    Port(clk: in std_logic;
         jump_address: in std_logic_vector(15 downto 0);
         branch_address: in std_logic_vector(15 downto 0);
         jump: in std_logic;
         PCSrc: in std_logic;
         reset: in std_logic;
         en: in std_logic;
         instruction: out std_logic_vector(15 downto 0);
         next_address: out std_logic_vector(15 downto 0));
end component;

component DecodeUnit is
    PORT(
    en : in std_logic;
    INSTRUCTION: IN std_logic_vector(15 downto 0);
    WD: IN std_logic_vector(15 downto 0);
    
    RegWrite: IN std_logic;
    RegDst: IN std_logic;
    ExpOp: IN std_logic;
    CLK: IN std_logic;
    
    RD1: OUT std_logic_vector(15 downto 0);
    RD2: OUT std_logic_vector(15 downto 0);
    
    Ext_Imm: OUT std_logic_vector(15 downto 0);
    funct: OUT std_logic_vector(2 downto 0);
    sa: OUT std_logic
    );
end component;

component ControlUnit is
    PORT(
    instruction: IN std_logic_vector(15 downto 0);
    
    ALUOp: OUT STD_logic_vector(2 downto 0);
    RegDst, RegWrite, ExtOp, ALUsrc, MemToReg, MemWrite, Branch, Jump: OUT std_logic
    );
end component;

component ExecutionUnit1 is
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
end component;

component  DataMemory is
    port ( clk : in std_logic;
           MemWrite : in std_logic;
           inALURes : in std_logic_vector(15 downto 0);
           RD2 : in std_logic_vector(15 downto 0);
           MemData : out std_logic_vector(15 downto 0);
           outALURes : out std_logic_vector(15 downto 0));
end component;

--signals Control Unit
signal RegDst, ExtOp, ALUSrc, Branch, Jump, MemWrite, MemtoReg, RegWrite :std_logic;
signal ALUOp: std_logic_vector(2 downto 0);

--signals Instruction Fetch
signal en1, en2:std_logic;
signal branch_address, jump_address: std_logic_vector(15 downto 0);
signal SSDAfis: std_logic_vector(15 downto 0);
signal instr_out, PCout: std_logic_vector(15 downto 0);
signal PCSrc:std_logic;

--signals Decode Unit
signal WriteDataReg: std_logic_vector(15 downto 0);
signal RD1, RD2, Ext_Imm: std_logic_vector(15 downto 0);
signal funct: std_logic_vector(2 downto 0);
signal sa: std_logic;

--signals Execution Unit
signal ALURes: std_logic_vector(15 downto 0);
signal ZeroSignal: std_logic;

--SIGNALS Data Memory
signal ALUResFinal:std_logic_vector(15 downto 0);
signal MemData: std_logic_vector(15 downto 0);	

begin 

MPG1: MPG port map(CLK=>clk, BTN=>btn(0), ENABLE=>en1);
MPG2: MPG port map( CLK=>clk, BTN=>btn(1), ENABLE=>en2);


Instruction_Fetch: InstructionFetch port map(clk=>clk, jump_address=>jump_address, branch_address=>branch_address,jump=> Jump,PCSrc=> PCSrc, reset=>en2,en=> en1,instruction=>instr_out,next_address=>PCout); 
 
Instruction_Decode: DecodeUnit port map(en =>en1, INSTRUCTION=>instr_out, WD=>WriteDataReg, RegWrite=>RegWrite, RegDst=>RegDst,ExpOp=>ExtOp, CLK=>clk, RD1=>RD1, RD2=>RD2, Ext_Imm=>Ext_Imm, funct=> funct, sa=> sa); 
 
Control_Unit: ControlUnit port map( instruction=> instr_out, ALUOp=>ALUOp, RegDst=> RegDst  , RegWrite=> RegWrite , ExtOp=> ExtOp  , ALUsrc=>ALUSrc  , MemToReg=>MemtoReg, MemWrite=> MemWrite   , Branch=>Branch   , Jump=> Jump   );

Execution_Unit: ExecutionUnit1 port map( rd1=>RD1 , rd2=> RD2, ext_imm=>Ext_Imm , func=>  funct ,sa=>sa,  alu_src=>ALUSrc   ,alu_op=>ALUOp    ,pcout=>PCout    ,zero=>ZeroSignal    , alu_res=>ALURes   , branch_addr=>branch_address    );
   
Data_Memory: DataMemory port map( clk=>clk, MemWrite=> MemWrite, inALURes=>ALURes, RD2=>RD2  , MemData=>MemData    , outALURes=>ALUResFinal    );
 
  
SSD: SSDisplay port map(CLK=>clk, CAT=>cat,AN=> an, DIGIT_1=>SSDafis(3 downto 0),DIGIT_2=>SSDAfis(7 downto 4 ),DIGIT_3=> SSDAfis(11 downto 8), DIGIT_4=>SSDAfis(15 downto 12));

--UTIMUL MUX
MUXMemToReg: process(MemtoReg, MemData, ALUResFinal)
    begin
        case MemtoReg is
            when '1' => WriteDataReg <= MemData;
            when others => WriteDataReg<= ALUResFinal;
            end case;
    end process MUXMemToReg;



PCSrc<= ZeroSignal and Branch;
led(15) <= ZeroSignal;

--JUMP

jump_address<=PCOut(15 downto 13) & instr_out(12 downto 0);

--AFIS FINAL
process(instr_out,PCout,RD1,RD2,Ext_Imm,ALURes,MemData,WriteDataReg,sw)
begin
	case(sw(7 downto 5)) is
		when "000"=>
				SSDAfis<=instr_out;			
		when "001"=>
				SSDAfis<=PCout;				
		when "010"=>
				SSDAfis<=RD1;				
		when "011"=>
				SSDAfis<=RD2;				
		when "100"=>
				SSDAfis<=Ext_Imm;			
		when "101" =>
				SSDAfis<=ALURes;					
		when "110"=>
				SSDAfis<=MemData;			
		when "111"=>
				SSDAfis<=WriteDataReg;	
		when others=>
				SSDAfis<=X"0000";
	end case;
end process;

--MUX pentru afisarea pe leduri a semnalelor de control------------
process(RegDst,ExtOp,ALUSrc,Branch,Jump,MemWrite,MemtoReg,RegWrite,sw,ALUOp)
begin
	if sw(0)='0' then		
		led(7)<=RegDst;
		led(6)<=ExtOp;
		led(5)<=ALUSrc;
		led(4)<=Branch;
		led(3)<=Jump;
		led(2)<=MemWrite;
		led(1)<=MemtoReg;
		led(0)<=RegWrite;
		
	else
		led(2 downto 0)<=ALUOp(2 downto 0);
		led(7 downto 3)<="00000";
	end if;
end process;	


 

end Architecture;




