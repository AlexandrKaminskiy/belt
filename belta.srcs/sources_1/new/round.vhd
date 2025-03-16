----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.03.2025 15:37:04
-- Design Name: 
-- Module Name: round - Behavioral
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

entity round is
    GENERIC (N_IN : integer := 128;
             K_IN : integer := 256);
    Port ( CIPHER  : in STD_LOGIC; -- 0 - cipher, 1 - decipher
           CLK  : in STD_LOGIC; 
           I : in STD_LOGIC_VECTOR(3 downto 0);
           X : in STD_LOGIC_VECTOR(N_IN - 1 downto 0);
           KEY : in STD_LOGIC_VECTOR(K_IN - 1 downto 0);
           Y : out STD_LOGIC_VECTOR(N_IN - 1 downto 0)
           );
end round;

architecture Behavioral of round is

type ByteArray is array (0 to 15, 0 to 15) of std_logic_vector(7 downto 0);
constant SBox : ByteArray := (
    (X"B1", X"94", X"BA", X"C8", X"0A", X"08", X"F5", X"3B", X"36", X"6D", X"00", X"8E", X"58", X"4A", X"5D", X"E4"),
    (X"85", X"04", X"FA", X"9D", X"1B", X"B6", X"C7", X"AC", X"25", X"2E", X"72", X"C2", X"02", X"FD", X"CE", X"0D"),
    (X"5B", X"E3", X"D6", X"12", X"17", X"B9", X"61", X"81", X"FE", X"67", X"86", X"AD", X"71", X"6B", X"89", X"0B"),
    (X"5C", X"B0", X"C0", X"FF", X"33", X"C3", X"56", X"B8", X"35", X"C4", X"05", X"AE", X"D8", X"E0", X"7F", X"99"),
    (X"E1", X"2B", X"DC", X"1A", X"E2", X"82", X"57", X"EC", X"70", X"3F", X"CC", X"F0", X"95", X"EE", X"8D", X"F1"),
    (X"C1", X"AB", X"76", X"38", X"9F", X"E6", X"78", X"CA", X"F7", X"C6", X"F8", X"60", X"D5", X"BB", X"9C", X"4F"),
    (X"F3", X"3C", X"65", X"7B", X"63", X"7C", X"30", X"6A", X"DD", X"4E", X"A7", X"79", X"9E", X"B2", X"3D", X"31"),
    (X"3E", X"98", X"B5", X"6E", X"27", X"D3", X"BC", X"CF", X"59", X"1E", X"18", X"1F", X"4C", X"5A", X"B7", X"93"),
    (X"E9", X"DE", X"E7", X"2C", X"8F", X"0C", X"0F", X"A6", X"2D", X"DB", X"49", X"F4", X"6F", X"73", X"96", X"47"),
    (X"06", X"07", X"53", X"16", X"ED", X"24", X"7A", X"37", X"39", X"CB", X"A3", X"83", X"03", X"A9", X"8B", X"F6"),
    (X"92", X"BD", X"9B", X"1C", X"E5", X"D1", X"41", X"01", X"54", X"45", X"FB", X"C9", X"5E", X"4D", X"0E", X"F2"),
    (X"68", X"20", X"80", X"AA", X"22", X"7D", X"64", X"2F", X"26", X"87", X"F9", X"34", X"90", X"40", X"55", X"11"),
    (X"BE", X"32", X"97", X"13", X"43", X"FC", X"9A", X"48", X"A0", X"2A", X"88", X"5F", X"19", X"4B", X"09", X"A1"),
    (X"7E", X"CD", X"A4", X"D0", X"15", X"44", X"AF", X"8C", X"A5", X"84", X"50", X"BF", X"66", X"D2", X"E8", X"8A"),
    (X"A2", X"D7", X"46", X"52", X"42", X"A8", X"DF", X"B3", X"69", X"74", X"C5", X"51", X"EB", X"23", X"29", X"21"),
    (X"D4", X"EF", X"D9", X"B4", X"3A", X"62", X"28", X"75", X"91", X"14", X"10", X"EA", X"77", X"6C", X"DA", X"1D")
);

constant part_len : integer := 32;
constant KEY_COUNT : integer := 6;
constant OCTET_LENGTH : integer := 8;
constant ITERATION_COMPLEMENT: std_logic_vector (part_len - 1 downto I'length + 1) := (others => '0');
signal y_sig : std_logic_vector(N_IN - 1 downto 0);

function sum_n(
    a: std_logic_vector(part_len - 1 downto 0);
    b: std_logic_vector(part_len - 1 downto 0)
) return std_logic_vector is
begin
    return std_logic_vector(unsigned(a) + unsigned(b));
end function;

function sub_n(
    a: std_logic_vector(part_len - 1 downto 0);
    b: std_logic_vector(part_len - 1 downto 0)
) return std_logic_vector is
begin
    return std_logic_vector(to_unsigned(2**part_len + to_integer(unsigned(A)) - to_integer(unsigned(B)), part_len));
end function;

function get_round_key(
    key: std_logic_vector(K_IN - 1 downto 0);
    it: integer;
    number: integer
) return std_logic_vector is
variable theta_num: integer;
begin
    theta_num := 7 * it - number;
    return key(K_IN - ((theta_num - 1) * part_len) - 1 downto K_IN - ((theta_num - 1) * part_len) - part_len);
end function;

function H(
    X: STD_LOGIC_VECTOR (OCTET_LENGTH - 1 downto 0)
) return std_logic_vector is
begin
    return SBox(to_integer(unsigned(X(OCTET_LENGTH - 1 downto OCTET_LENGTH / 2))), to_integer(unsigned(X(OCTET_LENGTH / 2 - 1 downto 0))));
end function;

function rot_hi(
    A: std_logic_vector(part_len - 1 downto 0);
    shift: integer
) return std_logic_vector is
begin
    report integer'image(part_len - 1 - shift);
    report integer'image(part_len - shift);

    return A(part_len - 1 - shift downto 0) & A(part_len - 1 downto part_len - shift);
end function;

function G(
    x: std_logic_vector(part_len - 1 downto 0);
    shift: integer
) return std_logic_vector is
begin
    return rot_hi(
        H(x(part_len - 1 downto part_len - OCTET_LENGTH)) &
        H(x(part_len - OCTET_LENGTH * 1 - 1 downto part_len - OCTET_LENGTH * 2)) &
        H(x(part_len - OCTET_LENGTH * 2 - 1 downto part_len - OCTET_LENGTH * 3)) &
        H(x(part_len - OCTET_LENGTH * 3 - 1 downto part_len - OCTET_LENGTH * 4)),
        shift);
end function;

function next_key_number(
    cipher: std_logic;
    value: integer
) return integer is
begin
    if (cipher = '0') then
        report "next_key_number cipher " & integer'image(KEY_COUNT - value);
        return KEY_COUNT - value;
    else 
        report "next_key_number decipher " & integer'image(value);
        return value;
    end if;
end function;

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

begin

ROUND: process (CLK)
variable a : STD_LOGIC_VECTOR (part_len - 1 downto 0);
variable b : STD_LOGIC_VECTOR (part_len - 1 downto 0);
variable c : STD_LOGIC_VECTOR (part_len - 1 downto 0);
variable d : STD_LOGIC_VECTOR (part_len - 1 downto 0);
variable e : STD_LOGIC_VECTOR (part_len - 1 downto 0);
begin
    if (rising_edge(CLK)) then
        a := (X(N_IN - 1 downto N_IN - part_len));
        b := (X(N_IN - part_len * 1 - 1 downto N_IN - part_len * 2));
        c := (X(N_IN - part_len * 2 - 1 downto N_IN - part_len * 3));
        d := (X(N_IN - part_len * 3 - 1 downto N_IN - part_len * 4));
        
        -- 1
        b := b xor G(sum_n(a, get_round_key(KEY, to_integer(unsigned(I)), next_key_number(CIPHER, 0))), 5);
        
        -- 2
        c := c xor G(sum_n(d, get_round_key(KEY, to_integer(unsigned(I)), next_key_number(CIPHER, 1))), 21);
    
        -- 3
        a := c xor G(sub_n(b, get_round_key(KEY, to_integer(unsigned(I)), next_key_number(CIPHER, 2))), 13);
    
        -- 4
        e := G(sum_n(
            sum_n(b, c), 
            get_round_key(KEY, to_integer(unsigned(I)), next_key_number(CIPHER, 3))
            ), 21) xor (ITERATION_COMPLEMENT & I);
        
        -- 5
        b := sum_n(b, e);
        
        -- 6
        c := sub_n(c, e);
    
        -- 7
        d := sum_n(d, G(sum_n(c, get_round_key(KEY, to_integer(unsigned(I)), next_key_number(CIPHER, 4))), 13));
    
        -- 8
        b := b xor G(sum_n(a, get_round_key(KEY, to_integer(unsigned(I)), next_key_number(CIPHER, 5))), 21);
    
        -- 9
        c := c xor G(sum_n(d, get_round_key(KEY, to_integer(unsigned(I)), next_key_number(CIPHER, 6))), 5);
    
        -- 10
        a := a xor b;
        b := b xor a;
        a := a xor b;
        
        -- 11
        c := c xor d;
        d := d xor c;
        c := c xor d;
        
        -- 12
        b := c xor b;
        c := b xor c;
        b := c xor b;
        
        if (CIPHER = '0') then
            y_sig <= b & d & a & c;
        else
            y_sig <= c & a & d & b;
        end if;    
    end if;
end process;

Y <= y_sig;
end Behavioral;
