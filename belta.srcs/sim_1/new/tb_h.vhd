----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.03.2025 15:10:32
-- Design Name: 
-- Module Name: tb_h - Behavioral
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

entity tb_h is
--  Port ( );
end tb_h;

architecture Behavioral of tb_h is

component H is
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           Q : out STD_LOGIC_VECTOR (7 downto 0));
end component;

signal a_sig: STD_LOGIC_VECTOR(7 downto 0);
signal q_sig: STD_LOGIC_VECTOR(7 downto 0);

begin


test_proc: process
begin
    a_sig <= x"FF";
    wait for 40ns; --1D
    
    a_sig <= x"AA";
    wait for 40ns; --FB
    
    a_sig <= x"A8";
    wait for 40ns; --54
    
    
    a_sig <= x"B3";
    wait for 40ns; --AA
end process;

test: H port map (a_sig, q_sig);

end Behavioral;
