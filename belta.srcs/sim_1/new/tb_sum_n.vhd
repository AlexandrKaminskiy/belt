----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.03.2025 14:40:53
-- Design Name: 
-- Module Name: tb_sum_n - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_sum_n is
--  Port ( );
end tb_sum_n;

architecture Behavioral of tb_sum_n is

component sum_n is
    Generic (N: integer := 16);
    Port ( A : in STD_LOGIC_VECTOR (N - 1 downto 0);
           B : in STD_LOGIC_VECTOR (N - 1 downto 0);
           Q : out STD_LOGIC_VECTOR (N - 1 downto 0));
end component;

constant n: integer := 16;
signal a_sig: STD_LOGIC_VECTOR(n - 1 downto 0) := x"FFFF";
signal b_sig: STD_LOGIC_VECTOR(n - 1 downto 0) := x"FFFF";
signal q_sig: STD_LOGIC_VECTOR(n - 1 downto 0);

begin

test_proc: process
begin
    a_sig <= x"FFFF";
    b_sig <= x"FFFF";
    wait for 40ns; --FFFE
    
    a_sig <= x"EEFF";
    b_sig <= x"FFEE";
    wait for 40ns; --EEED
    
    a_sig <= x"0000";
    b_sig <= x"1111";
    wait for 40ns; --1111
end process;

test: sum_n port map (a_sig, b_sig, q_sig);

end Behavioral;
