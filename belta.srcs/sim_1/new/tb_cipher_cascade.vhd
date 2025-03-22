----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.03.2025 10:56:07
-- Design Name: 
-- Module Name: tb_cipher_cascade - Behavioral
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

entity tb_cipher_cascade is
--  Port ( );
end tb_cipher_cascade;

architecture Behavioral of tb_cipher_cascade is

component round_cascade is
  GENERIC (N_IN : integer := 128;
     K_IN : integer := 256);
  Port (
    CLK : in std_logic;
    X : in std_logic_vector (N_IN - 1 downto 0);
    KEY : in STD_LOGIC_VECTOR(K_IN - 1 downto 0);
    Y: out std_logic_vector (N_IN - 1 downto 0)
    
  );
end component;

signal s_cipher : std_logic := '0';
signal s_clk : std_logic := '0';
signal s_i : std_logic_vector(3 downto 0) := "0001";
signal s_x : std_logic_vector(127 downto 0) := x"B194BAC80A08F53B366D008E584A5DE4";
signal s_key : std_logic_vector(255 downto 0) := x"E9DEE72C8F0C0FA62DDB49F46F73964706075316ED247A3739CBA38303A98BF6";
signal s_y : std_logic_vector(127 downto 0);

begin

test_proc: process
begin
    s_clk <= not s_clk;
    wait for 40ns;
end process;

test: round_cascade port map (s_clk, s_x, s_key, s_y);

end Behavioral;
