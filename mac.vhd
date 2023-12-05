--AND GATE:
--Implementation of And gate
library IEEE;
use IEEE.std_logic_1164.all;
entity andgate is
port (A, B: in std_logic;
prod: out std_logic);
end entity andgate;
architecture trivial of andgate is
begin
prod <= A AND B AFTER 47 ps;
end architecture trivial;
--XOR GATE:
--Implementation of Xor gate
library IEEE;
use IEEE.std_logic_1164.all;
entity xorgate is
port (A, B: in std_logic;
uneq: out std_logic);
end entity xorgate;
architecture trivial of xorgate is
begin
uneq <= A XOR B AFTER 74 ps;
end architecture trivial;
--ABC GATE1:
--Implementation of A+B.C
library IEEE;
use IEEE.std_logic_1164.all;
entity abcgate1 is
port (A, B, C: in std_logic;
abc: out std_logic);
end entity abcgate1;
architecture trivial of abcgate1 is
begin
abc <= A OR (B AND C) AFTER 64 ps;
end architecture trivial;
--ABC GATE:
--Implementation of A.B+C.(A+B)
library IEEE;
use IEEE.std_logic_1164.all;
entity abcgate is
port(A, B, C: in std_logic;
G: out std_logic);
end entity abcgate;
architecture trivial of abcgate is
begin
G <= (A AND B) OR (C AND (A OR B)) AFTER 74 ps;
end architecture trivial;
GATES_PACKAGE:
library ieee;
use ieee.std_logic_1164.all ;
package gates_package is
component andgate is
port (A, B: in std_logic;
prod: out std_logic);
end component andgate;
component xorgate is
port (A, B: in std_logic;
uneq: out std_logic);
end component xorgate;
component abcgate is
port (A, B, C: in std_logic;
abc: out std_logic);
end component abcgate;
component Cin_map_G is
port(A, B, Cin: in std_logic;
Bit0_G: out std_logic);
end component Cin_map_G;
end package ;
HALF ADDER:
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all ;
use work.gates_package.all;
entity HA is
port (A, B: in std_logic;
sum,carry: out std_logic);
end entity HA;
architecture arch of HA is
signal inter : std_logic ;
begin
ha : xorgate port map(A,B,sum);
car : andgate port map(A,B,carry);
end arch ;
FULL ADDER:
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all ;
use work.gates_package.all;
entity FA is
port (A, B,C: in std_logic;
sum,carry: out std_logic);
end entity FA;
architecture arch of FA is
signal inter : std_logic ;
begin
fa1 : xorgate port map(A,B,inter);
fa2 : xorgate port map(inter,C,sum);
car1 : Cin_map_G port map(A,B,C,carry);
end arch ;
FULL ADDER AND HALF ADDER PACKAGE
library ieee;
use ieee.std_logic_1164.all ;
package fahapack is
component FA is
port (A, B,C: in std_logic;
sum,carry: out std_logic);
end component FA;
component HA is
port (A, B: in std_logic;
sum,carry: out std_logic);
end component HA;
component brentkung_adder is
port (A, B: in std_logic_vector(15 downto 0);
cin : in std_logic;
sum : out std_logic_vector(15 downto 0);
Cout: out std_logic);
end component ;
end package ;
MAC CIRCUIT:
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all ;
use work.gates_package.all;
use work.fahapack.all ;
entity MAC is
port (A, B: in std_logic_vector(7 downto 0);
m : in std_logic_vector(15 downto 0);
res: out std_logic_vector(15 downto 0);
cout:out std_logic);
end entity ;
architecture archi of MAC is
signal x0 : std_logic_vector(7 downto 0);
signal x1 : std_logic_vector(8 downto 1);
signal x2 : std_logic_vector(9 downto 2);
signal x3 : std_logic_vector(10 downto 3);
signal x4 : std_logic_vector(11 downto 4);
signal x5 : std_logic_vector(12 downto 5);
signal x6 : std_logic_vector(13 downto 6);
signal x7 : std_logic_vector(14 downto 7);
signal sh,ch : std_logic_vector(8 downto 1);
signal sf,cf : std_logic_vector(49 downto 2);
signal cin: std_logic := '0';
signal x,y : std_logic_vector(15 downto 0);
begin
gp0: for i in 0 to 7 generate
and1 : andgate port map(A(i),B(0),x0(i));
end generate;
gp1: for i in 0 to 7 generate
and1 : andgate port map(A(i),B(1),x1(i+1));
end generate;
gp2: for i in 0 to 7 generate
and1 : andgate port map(A(i),B(2),x2(i+2));
end generate;
gp3: for i in 0 to 7 generate
and1 : andgate port map(A(i),B(3),x3(i+3));
end generate;
gp4: for i in 0 to 7 generate
and1 : andgate port map(A(i),B(4),x4(i+4));
end generate;
gp5: for i in 0 to 7 generate
and1 : andgate port map(A(i),B(5),x5(i+5));
end generate;
gp6: for i in 0 to 7 generate
and1 : andgate port map(A(i),B(6),x6(i+6));
end generate;
gp7: for i in 0 to 7 generate
and1 : andgate port map(A(i),B(7),x7(i+7));
end generate;
hadd1 : HA port map(m(5),x0(5),sh(1),ch(1));
hadd2 : HA port map(x2(6),x3(6),sh(2),ch(2));
hadd3 : HA port map(x6(7),x5(7),sh(3),ch(3));
hadd4 : HA port map(x6(8),x7(8),sh(4),ch(4));
fadd2 : FA port map(m(6),x0(6),x1(6),sf(2),cf(2));
fadd3 : FA port map(m(7),x0(7),x1(7),sf(3),cf(3));
fadd4 : FA port map(x4(7),x3(7),x2(7),sf(4),cf(4));
fadd5 : FA port map(m(8),x1(8),x2(8),sf(5),cf(5));
fadd6 : FA port map(x3(8),x4(8),x5(8),sf(6),cf(6));
fadd7 : FA port map(m(9),x2(9),x3(9),sf(7),cf(7));
fadd8 : FA port map(x4(9),x5(9),x6(9),sf(8),cf(8));
fadd9 : FA port map(m(10),x3(10),x4(10),sf(9),cf(9));
-----------------------------------------------------------
hadd5 : HA port map(m(3),x0(3),sh(5),ch(5));
hadd6 : HA port map(x2(4),x3(4),sh(6),ch(6));
fadd10 : FA port map(m(4),x0(4),x1(4),sf(10),cf(10));
fadd11 : FA port map(sh(1),x1(5),x2(5),sf(11),cf(11));
fadd12 : FA port map(x3(5),x4(5),x5(5),sf(12),cf(12));
fadd13 : FA port map(sf(2),ch(1),sh(2),sf(13),cf(13));
fadd14 : FA port map(x4(6),x5(6),x6(6),sf(14),cf(14));
fadd15 : FA port map(sf(3),cf(2),sf(4),sf(15),cf(15));
fadd16 : FA port map(ch(2),sh(3),x7(7),sf(16),cf(16));
fadd17 : FA port map(sf(5),cf(3),sf(6),sf(17),cf(17));
fadd18 : FA port map(cf(4),sh(4),ch(3),sf(18),cf(18));
fadd19 : FA port map(sf(7),cf(5),sf(8),sf(19),cf(19));
fadd20 : FA port map(cf(6),ch(4),x7(9),sf(20),cf(20));
fadd21 : FA port map(sf(9),cf(7),x5(10),sf(21),cf(21));
fadd22 : FA port map(x6(10),x7(10),cf(8),sf(22),cf(22));
fadd23 : FA port map(m(11),cf(9),x4(11),sf(23),cf(23));
fadd24 : FA port map(x5(11),x6(11),x7(11),sf(24),cf(24));
fadd25 : FA port map(m(12),x5(12),x6(12),sf(25),cf(25));
------------------------------------------------------------
hadd7 : HA port map(m(2),x0(2),sh(7),ch(7));
fadd26 : FA port map(sh(5),x1(3),x2(3),sf(26),cf(26));
fadd27 : FA port map(sf(10),ch(5),sh(6),sf(27),cf(27));
fadd28 : FA port map(sf(11),cf(10),sf(12),sf(28),cf(28));
fadd29 : FA port map(sf(13),cf(11),sf(14),sf(29),cf(29));
fadd30 : FA port map(sf(15),cf(13),sf(16),sf(30),cf(30));
fadd31 : FA port map(sf(17),cf(15),sf(18),sf(31),cf(31));
fadd32 : FA port map(sf(19),cf(17),sf(20),sf(32),cf(32));
fadd33 : FA port map(sf(21),cf(19),sf(22),sf(33),cf(33));
fadd34 : FA port map(sf(23),cf(21),sf(24),sf(34),cf(34));
fadd35 : FA port map(sf(25),cf(23),x7(12),sf(35),cf(35));
fadd36 : FA port map(m(13),cf(25),x6(13),sf(36),cf(36));
------------------------------------------------------------
hadd8 : HA port map(m(1),x0(1),x(1),y(2));
fadd48 : FA port map(sh(7),x1(2),x2(2),x(2),y(3));
fadd37 : FA port map(sf(26),ch(7),x3(3),x(3),y(4));
fadd38 : FA port map(sf(27),cf(26),x4(4),x(4),y(5));
fadd39 : FA port map(sf(28),cf(27),ch(6),x(5),y(6));
fadd40 : FA port map(sf(29),cf(28),cf(12),x(6),y(7));
fadd41 : FA port map(sf(30),cf(29),cf(14),x(7),y(8));
fadd42 : FA port map(sf(31),cf(30),cf(16),x(8),y(9));
fadd43 : FA port map(sf(32),cf(31),cf(18),x(9),y(10));
fadd44 : FA port map(sf(33),cf(32),cf(20),x(10),y(11));
fadd45 : FA port map(sf(34),cf(33),cf(22),x(11),y(12));
fadd46 : FA port map(sf(35),cf(34),cf(24),x(12),y(13));
fadd47 : FA port map(sf(36),cf(35),x7(13),x(13),y(14));
fadd49 : FA port map(m(14),cf(36),x7(14),x(14),y(15));
x(0) <= m(0);
x(15) <= m(15);
y(0) <= x0(0);
y(1) <= x1(1);
brunt : brentkung_adder port map(x,y,cin,res,cout) ;
end archi;
TEST DATA:
# Column description:
# a b x output cout
10010110 10010110 0010000100101101 0111100100010001 0
00000001 00010100 0000000000000001 0000000000010101 0
00000011 01000001 0000000000000100 0000000011000111 0
01000000 00000011 0000000000000110 0000000011000110 0
00000010 00000100 0000000000000111 0000000000001111 0
00000110 00000011 0000000000001001 0000000000011011 0
00001001 01000100 0000000000001101 0000001001110001 0
00010000 00010001 0000000000010011 0000000100100011 0
11111111 11111111 1000000111111110 0111111111111111 1
00000010 10000001 0100000000000011 0100000100000101 0
TEST BENCH:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use work.gates_package.all;
entity testb is
end entity;
architecture tb of testb is
component MAC is
port (A, B: in std_logic_vector(7 downto 0);
m : in std_logic_vector(15 downto 0);
res: out std_logic_vector(15 downto 0);
cout:out std_logic);
end component ;
signal tb_a, tb_b : std_logic_vector(7 downto 0);
signal tb_x : std_logic_vector(15 downto 0);
signal tb_cout : std_logic;
signal tb_s : std_logic_vector(15 downto 0);
begin
f1 : MAC port map(tb_b,tb_a,tb_x,tb_s, tb_cout);
process
file text_file : text open read_mode is
"C:\Users\ankir\OneDrive\Desktop\testdata.txt" ;
variable text_line : line;
variable x, y : std_logic_vector(7 downto 0);
variable k,z : std_logic_vector(15 downto 0);
variable b : std_logic;
variable ok : boolean;
begin
while not endfile(text_file) loop
readline(text_file, text_line);
if text_line.all'length = 0 or text_line.all(1) = '#' then
next;
end if;
read(text_line, x, ok);
tb_a <= x;
read(text_line, y, ok);
tb_b <= y;
read(text_line, k, ok);
tb_x <= k;
read(text_line, z, ok);
read(text_line, b, ok);
wait for 2000ns;
assert(tb_s = z) report "Mismatch" severity failure;
assert(tb_cout = b) report "Mismatch" severity failure;
end loop;
report "Successfully checked all values" severity note;
wait;
end process;
end architecture;
RESULTS:
