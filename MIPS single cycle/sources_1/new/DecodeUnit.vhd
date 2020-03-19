library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DecodeUnit is
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
end DecodeUnit;

architecture Behavioral of DecodeUnit is
    component reg_file is
        port (
        en : in std_logic;
        clk : in std_logic;
        ra1 : in std_logic_vector (2 downto 0);
        ra2 : in std_logic_vector (2 downto 0);
        wa : in std_logic_vector (2 downto 0);
        wd : in std_logic_vector (15 downto 0);
        wen : in std_logic;
        rd1 : out std_logic_vector (15 downto 0);
        rd2 : out std_logic_vector (15 downto 0)
        );
    end component;
    
    -- definire semnale
    signal OPCode: std_logic_vector(2 downto 0);
    signal RS: std_logic_vector(2 downto 0);
    signal RT: std_logic_vector(2 downto 0);
    signal RD: std_logic_vector(2 downto 0);
    signal SA_intern: std_logic;
    signal funct_intern: std_logic_vector(2 downto 0);
    signal immediat_address: std_logic_vector(6 downto 0);
    
    signal MUX_WA_signal: std_logic_vector(2 downto 0);
begin 
    OPCode <= instruction(15 downto 13);
    RS <= instruction(12 downto 10);
    RT <= instruction(9 downto 7);

    -- R-type operatii
    RD <= instruction(6 downto 4);
    SA_intern <= instruction(3);
    funct_intern <= instruction(2 downto 0);
    
    -- I-type operatii
    immediat_address <= instruction (6 downto 0);
    
    MUX: process(RT, RD, RegDst)
    begin
        case RegDst is
            when '0' => MUX_WA_signal <= RT;
            when others => MUX_WA_signal <= RD;
        end case;
    end process MUX;
    
    REGISTER_FILE: reg_file port map(en => en, clk => CLK, ra1 => RS, ra2 => RT, wa => MUX_WA_signal , Wen => RegWrite, WD => WD,
                            rd1 => RD1, rd2 => RD2);
                            
                            
    ExtUnit: process(ExpOp, immediat_address)
    begin 
        if ExpOp = '1' then
            case immediat_address(6) is
                when '1' => Ext_Imm <= "111111111" & immediat_address;
                when '0' => Ext_Imm <= "000000000" & immediat_address;
                when others => Ext_Imm <= x"0000";
            end case;
        else
            Ext_Imm <= x"0000";
        end if;
    end process;
    
    funct <= funct_intern;
    sa <= SA_intern;
end Behavioral;
