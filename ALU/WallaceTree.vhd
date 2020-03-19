library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity WallaceTree is
Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           prod : out  STD_LOGIC_VECTOR (7 downto 0));
end multiply_wallace;

architecture Behavioral of multiply_wallace is

component full_adder is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           Cin : in  STD_LOGIC;
           S : out  STD_LOGIC;
           Cout : out  STD_LOGIC);
end component;

component half_adder is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           sum : out  STD_LOGIC;
           carry : out  STD_LOGIC);
end component;

signal s11,s12,s13,s14,s15,s22,s23,s24,s25,s26,s32,s33,s34,s35,s36,s37 : std_logic;
signal c11,c12,c13,c14,c15,c22,c23,c24,c25,c26,c32,c33,c34,c35,c36,c37 : std_logic;
signal p0,p1,p2,p3 : std_logic_vector(6 downto 0);

begin

process(A,B)
begin
    for i in 0 to 3 loop
        p0(i) <= A(i) and B(0);
        p1(i) <= A(i) and B(1);
        p2(i) <= A(i) and B(2);
        p3(i) <= A(i) and B(3);
    end loop;       
end process;
    
prod(0) <= p0(0);
prod(1) <= s11;
prod(2) <= s22;
prod(3) <= s32;
prod(4) <= s34;
prod(5) <= s35;
prod(6) <= s36;
prod(7) <= s37;

--first stage
ha11 : half_adder port map(a=>p0(1),b=>p1(0),sum=>s11,carry=>c11);
fa12 : full_adder port map(A=>p0(2),B=>p1(1),Cin=>p2(0),S=>s12,Cout=>c12);
fa13 : full_adder port map(A=>p0(3),B=>p1(2),Cin=>p2(1),S=>s13,Cout=>c13);
fa14 : full_adder port map(A=>p1(3),B=>p2(2),Cin=>p3(1),S=>s14,Cout=>c14);
ha15 : half_adder port map(a=>p2(3),b=>p3(2),sum=>s15,carry=>c15);

--second stage
ha22 : half_adder port map(a=>c11,b=>s12,sum=>s22,carry=>c22);
fa23 : full_adder port map(A=>p3(0),B=>c12,Cin=>s13,S=>s23,Cout=>c23);
fa24 : full_adder port map(A=>c13,B=>c32,Cin=>s14,S=>s24,Cout=>c24);
fa25 : full_adder port map(A=>c14,B=>c24,Cin=>s15,S=>s25,Cout=>c25);
fa26 : full_adder port map(A=>c15,B=>c25,Cin=>3(3),S=>s26,Cout=>c26);

--third stage
ha32 : half_adder port map(a=>c22,b=>s23,sum=>s32,carry=>c32);
ha34 : half_adder port map(a=>c23,b=>s24,sum=>s34,carry=>c34);
ha35 : half_adder port map(a=>c34,b=>s25,sum=>s35,carry=>c35);
ha36 : half_adder port map(a=>c35,b=>s26,sum=>s36,carry=>c36);
ha37 : half_adder port map(a=>c36,b=>c26,sum=>s37,carry=>c37);



end Behavioral;
