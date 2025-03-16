----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.03.2025 15:01:35
-- Design Name: 
-- Module Name: H - Behavioral
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

entity H is
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           Q : out STD_LOGIC_VECTOR (7 downto 0));
end H;

architecture Behavioral of H is
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

begin

Q <= SBox(to_integer(unsigned(A(7 downto 4))), to_integer(unsigned(A(3 downto 0))));

end Behavioral;
