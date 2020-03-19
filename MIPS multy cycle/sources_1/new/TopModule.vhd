
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity TopModule is
      Port ( clk : in STD_LOGIC;
       btn : in STD_LOGIC_VECTOR (4 downto 0);
       sw : in STD_LOGIC_VECTOR (15 downto 0);
       led : out STD_LOGIC_VECTOR (15 downto 0);
       an : out STD_LOGIC_VECTOR (3 downto 0);
       cat : out STD_LOGIC_VECTOR (6 downto 0)
       );
end TopModule;



architecture Behavioral of TopModule is

component pc IS
PORT (
clk : IN STD_LOGIC;
rst_n : IN STD_LOGIC;
pc_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
PC_en : IN STD_LOGIC;
pc_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );
END component pc; 

component regA is
  Port (dataIn: in std_logic_vector(31 downto 0);
        clk: in std_logic;
        wr: in std_logic;
        dataOut:out std_logic_vector(31 downto 0)
  
   );
end component;

component Memory is
  Port (addr: in std_logic_vector(31 downto 0);
       dataIn:in std_logic_vector(31 downto 0);
       dataOut:out std_logic_vector(31 downto 0);
       we:in std_logic;
       en: in std_logic;
       clk:in std_logic
   );
end component Memory;

component instreg IS
PORT (
clk : IN STD_LOGIC;
rst_n : IN STD_LOGIC;
memdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
IRWrite : IN STD_LOGIC;
instr_31_26 : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
instr_25_21 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
instr_20_16 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
instr_15_0 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) );
END component instreg;

component MDR is
  Port (clk:in std_logic;
  reset:in std_logic;
  writeEn: in std_logic;
  memdata:in std_logic_vector(31 downto 0);
  dataOut:out std_logic_vector(31 downto 0)
  
   );
end component MDR;

component regfile IS
PORT (clk,rst_n : IN std_logic;
wen : IN std_logic; -- write control
writeport : IN std_logic_vector(31 DOWNTO 0); -- register input
adrwport : IN std_logic_vector(4 DOWNTO 0);-- address write
adrport0 : IN std_logic_vector(4 DOWNTO 0);-- address port 0
adrport1 : IN std_logic_vector(4 DOWNTO 0);-- address port 1
readport0 : OUT std_logic_vector(31 DOWNTO 0); -- output port 0
readport1 : OUT std_logic_vector(31 DOWNTO 0) -- output port 1
);
END component regfile;

component alu IS
PORT (
a, b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
opcode : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
zero : OUT STD_LOGIC);
END component alu;

component ControlUnit is
  Port (clk:in std_logic;
        reset:in std_logic;
        ena:in std_logic;
        opcode:in std_logic_vector(5 downto 0);
        IORD, wrMem, irWrite, writeMemReg, RegWrite, MemToReg, RegDst, RegAWr, RegBWr, AluSrcA, AluResWr, PCWr:out std_logic;
        AluSrcB:out std_logic_vector(1 downto 0);
        AluOp:out std_logic_vector(1 downto 0);
        func:in std_logic_vector(5 downto 0)
   );
end component ControlUnit;

component debouncer is
Port(
    clk:in STD_LOGIC;
    btn:in STD_LOGIC;
    Enable:out STD_LOGIC
    
);
end component debouncer;

component SegDisp is
Port ( 
    clk:in std_logic;
   
    CAT: out std_logic_vector(6 downto 0);
    AN:out std_logic_vector(3 downto 0);
    Digit0:in std_logic_vector(3 downto 0);
    Digit1:in std_logic_vector(3 downto 0);
    Digit2:in std_logic_vector(3 downto 0);
    Digit3:in std_logic_vector(3 downto 0)
);
end component SegDisp;


signal AluRes:std_logic_vector(31 downto 0);
signal PCOut:std_logic_vector(31 downto 0);
signal dataBuff:std_logic_vector(31 downto 0);
signal AluResOut:std_logic_vector(31 downto 0);
signal MemData:std_logic_vector(31 downto 0);
signal RegInData:std_logic_vector(31 downto 0);
signal RegOutA:std_logic_vector(31 downto 0);
signal RegOutB:std_logic_vector(31 downto 0);
signal A:std_logic_vector(31 downto 0);
signal B:std_logic_vector(31 downto 0);
signal MemIn:std_logic_vector(31 downto 0);
signal AluInA:std_logic_vector(31 downto 0);
signal AluInB:std_logic_vector(31 downto 0);
signal SignExtImm:std_logic_vector(31 downto 0);
signal SignExtImmShift:std_logic_vector(31 downto 0);

signal imm:std_logic_vector(15 downto 0);
signal RS:std_logic_vector(4 downto 0);
signal RT:std_logic_vector(4 downto 0);
signal RegWriteAddr:std_logic_vector(4 downto 0);
signal oppcode:std_logic_vector(5 downto 0);
signal enable, reset:std_logic:='0';
signal wrMem:std_logic;
signal IRWrite:std_logic;
signal writeMemReg:std_logic;
signal RegWrite:std_logic;
signal MemToReg:std_logic;
signal RegDst:std_logic;
signal RegAWr:std_logic;
signal RegBWr:std_logic;
signal zeroDet:std_logic;
signal AluSrcA:std_logic;
signal IORD:std_logic;
signal AluResWr:std_logic;
signal PCWr:std_logic;
signal AluSrcB:std_logic_vector(1 downto 0);
signal AluOp:std_logic_vector(1 downto 0);
signal showUpper:std_logic;
signal Afis:std_logic_vector(15 downto 0);
signal Afis32:std_logic_vector(31 downto 0);
signal vcc:std_logic:='1';
signal AluResWrEn, RegAWrEn, RegBWrEn, PCWrEn, IRWriteEn, writeMemRegEn, RegWriteEn:std_logic;
signal semnal:std_logic_vector(31 downto 0):=x"0000000F";
begin

RA: regA port map(RegOutA,clk, RegAWrEn, A);
RB: regA port map(RegOutB,clk, RegBWrEn, B);
PC4: pc port map(clk, reset, AluRes, PCWrEn, PCOut);
mem: Memory port map(MemIn, B, dataBuff, wrMem, enable, clk);
IReg: instreg port map(clk, reset, dataBuff, IRWriteEn, oppcode, RS, RT, imm);
MemDataReg: MDR port map(clk, reset, writeMemRegEn, dataBuff, MemData);
Reg: regfile port map(clk, reset, RegWriteEn, RegInData, RegWriteAddr, RS, RT, RegOutA, RegOutB);
AluComp: alu port map(AluInA, AluInB, AluOp, AluRes, zeroDet);
AluResReg: regA port map(AluRes, clk, AluResWrEn, AluResOut);
control: ControlUnit port map(clk, reset, enable, oppcode,  IORD, wrMem, irWrite, writeMemReg, RegWrite, MemToReg, RegDst, RegAWr, RegBWr, AluSrcA, AluResWr, PCWr, AluSrcB, AluOp, imm(5 downto 0));
dbEna: debouncer port map (clk, btn(0), enable);
dbReset: debouncer port map (clk, btn(1), reset);

SSD: SegDisp port map(clk, cat, an, Afis(3 downto 0), Afis(7 downto 4), Afis(11 downto 8), Afis(15 downto 12));




AluResWrEN <= AluResWr and enable;
RegAWrEn<= RegAWr and enable;
RegBWrEn<= RegBWr and enable;
PCWrEn <= PCWr and enable;
IRWriteEn <= IRWrite and enable;
writeMemRegEn <= writeMemReg and enable;
RegWriteEn <= RegWrite and enable;





MemIn<= PCout when IORD = '0'
else AluResOut;


RegInData <= MemData when MemToReg = '1'
else AluResOut;

RegWriteAddr <= imm(15 downto 11) when  RegDst = '1'
else RT;

AluInA <= A when AluSrcA = '1'
else PCOut;

AluInB <= B when AluSrcB = "00"
else x"00000001" when AluSrcB="01"
else SignExtImm ;
SignExtImm <= x"0000" & imm;
Afis<= Afis32(31 downto 16) when sw(15)='1'
else Afis32(15 downto 0);

Afis32<= PCOut when sw(3 downto 0) = "0000"
else A when sw(3 downto 0) = "0001"
else B when sw(3 downto 0) = "0010"
else AluResOut when sw(3 downto 0) = "0011"
else AluRes when sw(3 downto 0) = "0100"
else dataBuff;

led(15 downto 14) <= AluOp;
led(13) <= PCWr;
led(12) <= RegAWr;
led(11) <= RegBWr;
led(10) <= AluResWr;
led(9) <= IORD;
led(8) <= wrMem;
led(7) <=irWrite;
led(6) <= writeMemReg;
--led(5) <= RegWrite;
--led(4) <= MemToReg;
--led(3) <= RegDst;
--led(2) <=AluSrcA;
--led(1 downto 0) <= AluSrcB;
led(5 downto 0) <= oppcode;
end Behavioral;
