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

entity tb_decipher is
--  Port ( );
end tb_decipher;

architecture Behavioral of tb_decipher is

component decipher is
  GENERIC (
--     N_IN : integer := 384;
     N_IN : integer := 288;
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
--signal s_x : std_logic_vector(383 downto 0) := x"E12BDC1AE28257EC703FCCF095EE8DF1C1AB76389FE678CAF7C6F860D5BB9C4FF33C657B637C306ADD4EA7799EB23D31";
--signal s_key : std_logic_vector(255 downto 0) := x"92BD9B1CE5D141015445FBC95E4D0EF2682080AA227D642F2687F93490405511";
--signal s_y : std_logic_vector(383 downto 0);

signal s_x : std_logic_vector(287 downto 0) := x"E12BDC1AE28257EC703FCCF095EE8DF1C1AB76389FE678CAF7C6F860D5BB9C4FF33C657B";
signal s_key : std_logic_vector(255 downto 0) := x"92BD9B1CE5D141015445FBC95E4D0EF2682080AA227D642F2687F93490405511";

signal s_y : std_logic_vector(287 downto 0);

begin

test_proc: process
begin
    s_clk <= not s_clk;
    wait for 40ns;
end process;

test: decipher port map (s_clk, s_x, s_key, s_y);

end Behavioral;
