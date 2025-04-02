----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.03.2025 10:34:15
-- Design Name: 
-- Module Name: round_cascade - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity round_cascade is
  GENERIC (N_IN : integer := 128;
     K_IN : integer := 256);
  Port (
    CLK : in std_logic;
    X : in std_logic_vector (N_IN - 1 downto 0);
    KEY : in STD_LOGIC_VECTOR(K_IN - 1 downto 0);
    Y: out std_logic_vector (N_IN - 1 downto 0)
    
  );
end round_cascade;

architecture Behavioral of round_cascade is


component round is
    GENERIC (N_IN : integer := 128;
             K_IN : integer := 256);
    Port ( CIPHER  : in STD_LOGIC; -- 0 - cipher, 1 - decipher
           CLK  : in STD_LOGIC; 
           I : in STD_LOGIC_VECTOR(3 downto 0);
           X : in STD_LOGIC_VECTOR(N_IN - 1 downto 0);
           KEY : in STD_LOGIC_VECTOR(K_IN - 1 downto 0);
           Y : out STD_LOGIC_VECTOR(N_IN - 1 downto 0)
           );
end component;

constant ITERATION_QUANTITY : integer := 8;
constant zeros : std_logic_vector(N_IN - 1 downto 0) := (others => '0');

type tp_holder is array (0 to ITERATION_QUANTITY - 1) of std_logic_vector (N_IN - 1 downto 0);

signal y_holder : tp_holder := 
(
    zeros, zeros, zeros, zeros, 
    zeros, zeros, zeros, zeros
);

constant OCTET_LENGTH : integer := 8;
constant part_len : integer := 32;


function to_little_endian(
    x: std_logic_vector(part_len - 1 downto 0)
) return std_logic_vector is
variable a : STD_LOGIC_VECTOR (OCTET_LENGTH - 1 downto 0);
variable b : STD_LOGIC_VECTOR (OCTET_LENGTH - 1 downto 0);
variable c : STD_LOGIC_VECTOR (OCTET_LENGTH - 1 downto 0);
variable d : STD_LOGIC_VECTOR (OCTET_LENGTH - 1 downto 0);
begin
    a := X(part_len - 1 downto part_len - OCTET_LENGTH);
    b := X(part_len - OCTET_LENGTH * 1 - 1 downto part_len - OCTET_LENGTH * 2);
    c := X(part_len - OCTET_LENGTH * 2 - 1 downto part_len - OCTET_LENGTH * 3);
    d := X(part_len - OCTET_LENGTH * 3 - 1 downto part_len - OCTET_LENGTH * 4);
    return d & c & b & a;   
end function;

function x_to_little_endian(
    x: std_logic_vector(N_IN - 1 downto 0)
) return std_logic_vector is
variable a : STD_LOGIC_VECTOR (part_len - 1 downto 0);
variable b : STD_LOGIC_VECTOR (part_len - 1 downto 0);
variable c : STD_LOGIC_VECTOR (part_len - 1 downto 0);
variable d : STD_LOGIC_VECTOR (part_len - 1 downto 0);
begin
    a := to_little_endian(X(N_IN - 1 downto N_IN - part_len));
    b := to_little_endian(X(N_IN - part_len * 1 - 1 downto N_IN - part_len * 2));
    c := to_little_endian(X(N_IN - part_len * 2 - 1 downto N_IN - part_len * 3));
    d := to_little_endian(X(N_IN - part_len * 3 - 1 downto N_IN - part_len * 4));
    return a & b & c & d;   
end function;

function key_to_little_endian(
    key: std_logic_vector(K_IN - 1 downto 0)
) return std_logic_vector is
variable a : STD_LOGIC_VECTOR (part_len - 1 downto 0);
variable b : STD_LOGIC_VECTOR (part_len - 1 downto 0);
variable c : STD_LOGIC_VECTOR (part_len - 1 downto 0);
variable d : STD_LOGIC_VECTOR (part_len - 1 downto 0);
variable e : STD_LOGIC_VECTOR (part_len - 1 downto 0);
variable f : STD_LOGIC_VECTOR (part_len - 1 downto 0);
variable g : STD_LOGIC_VECTOR (part_len - 1 downto 0);
variable h : STD_LOGIC_VECTOR (part_len - 1 downto 0);
begin
    a := to_little_endian(key(K_IN - 1 downto K_IN - part_len));
    b := to_little_endian(key(K_IN - part_len * 1 - 1 downto K_IN - part_len * 2));
    c := to_little_endian(key(K_IN - part_len * 2 - 1 downto K_IN - part_len * 3));
    d := to_little_endian(key(K_IN - part_len * 3 - 1 downto K_IN - part_len * 4));
    e := to_little_endian(key(K_IN - part_len * 4 - 1 downto K_IN - part_len * 5));
    f := to_little_endian(key(K_IN - part_len * 5 - 1 downto K_IN - part_len * 6));
    g := to_little_endian(key(K_IN - part_len * 6 - 1 downto K_IN - part_len * 7));
    h := to_little_endian(key(K_IN - part_len * 7 - 1 downto K_IN - part_len * 8));
    return a & b & c & d & e & f & g & h;   
end function;

function final_permutation(
    X: std_logic_vector(N_IN - 1 downto 0)
) return std_logic_vector is
variable a : STD_LOGIC_VECTOR (part_len - 1 downto 0);
variable b : STD_LOGIC_VECTOR (part_len - 1 downto 0);
variable c : STD_LOGIC_VECTOR (part_len - 1 downto 0);
variable d : STD_LOGIC_VECTOR (part_len - 1 downto 0);
begin
    a := X(N_IN - 1 downto N_IN - part_len);
    b := X(N_IN - part_len * 1 - 1 downto N_IN - part_len * 2);
    c := X(N_IN - part_len * 2 - 1 downto N_IN - part_len * 3);
    d := X(N_IN - part_len * 3 - 1 downto N_IN - part_len * 4);
    return b & d & a & c;   
end function;

begin

p: process (clk)
begin
    if (rising_edge(clk)) then
        report "next round";
    end if;
end process;

do_round: round port map (
        CIPHER => '0',
        CLK => CLK,
        I => "0001",
        X => x_to_little_endian(X),
        KEY => key_to_little_endian(KEY),
        Y => y_holder(0)
    );
    
CASCADE: FOR I IN 2 TO ITERATION_QUANTITY GENERATE
    do_round: round port map (
        CIPHER => '0',
        CLK => CLK,
        I => std_logic_vector(to_unsigned(I, 4)),
        X => y_holder(I - 2),
        KEY => key_to_little_endian(KEY),
        Y => y_holder(I - 1)
    );

END GENERATE;

Y <= final_permutation(y_holder(7));

end Behavioral;
