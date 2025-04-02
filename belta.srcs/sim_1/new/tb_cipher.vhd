----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.03.2025 03:30:25
-- Design Name: 
-- Module Name: tb_cipher - Behavioral
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

entity tb_cipher is
--  Port ( );
end tb_cipher;

architecture Behavioral of tb_cipher is

component cipher is
  GENERIC (
--     N_IN : integer := 384;
     N_IN : integer := 376;
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
--signal s_x : std_logic_vector(383 downto 0) := x"B194BAC80A08F53B366D008E584A5DE48504FA9D1BB6C7AC252E72C202FDCE0D5BE3D61217B96181FE6786AD716B890B";
--signal s_key : std_logic_vector(255 downto 0) := x"E9DEE72C8F0C0FA62DDB49F46F73964706075316ED247A3739CBA38303A98BF6";
--signal s_y : std_logic_vector(383 downto 0);

signal s_x : std_logic_vector(375 downto 0) := x"B194BAC80A08F53B366D008E584A5DE48504FA9D1BB6C7AC252E72C202FDCE0D5BE3D61217B96181FE6786AD716B89";
signal s_key : std_logic_vector(255 downto 0) := x"E9DEE72C8F0C0FA62DDB49F46F73964706075316ED247A3739CBA38303A98BF6";

signal s_y : std_logic_vector(375 downto 0);

begin

test_proc: process
begin
    s_clk <= not s_clk;
    wait for 40ns;
end process;

test: cipher port map (s_clk, s_x, s_key, s_y);

end Behavioral;
