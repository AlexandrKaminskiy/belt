----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.03.2025 02:32:06
-- Design Name: 
-- Module Name: cipher - Behavioral
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

entity cipher is
  GENERIC (N_IN : integer := 128;
     K_IN : integer := 256);
  Port (
    CLK : in std_logic;
    X : in std_logic_vector (N_IN - 1 downto 0);
    KEY : in STD_LOGIC_VECTOR(K_IN - 1 downto 0);
    Y: out std_logic_vector (N_IN - 1 downto 0)
  );
end cipher;

architecture Behavioral of cipher is

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

constant CIPHER_TACTS : integer := 8;
constant INPUT_SIZE : integer := 128;
constant ITERATIONS : integer := N_IN / INPUT_SIZE;

signal current_offset : integer := N_IN;
signal tact_number : integer := 0;
signal it : integer := 0;
signal current_cipher : std_logic_vector (INPUT_SIZE - 1 downto 0);
signal current_decipher : std_logic_vector (INPUT_SIZE - 1 downto 0);

begin

--P1: process(CLK)
--begin

--    if rising_edge(CLK) then
--        if current_offset > 0 then
--            if not(tact_number = 0) and tact_number mod CIPHER_TACTS = 0 then
--                current_offset <= current_offset - INPUT_SIZE;
--            end if;
--        end if;
--        tact_number <= tact_number + 1;
--    end if;
--    current_cipher <= X(current_offset - 1 downto current_offset - INPUT_SIZE);
--    Y(current_offset - 1 downto current_offset - INPUT_SIZE) <= current_decipher;

--end process;

GEN: FOR I IN 0 TO ITERATIONS - 1 GENERATE
    cascade: round_cascade port map (
        CLK, 
        X(N_IN - INPUT_SIZE * I - 1 downto N_IN - INPUT_SIZE * (I + 1)), 
        KEY, 
        Y(N_IN - INPUT_SIZE * I - 1 downto N_IN - INPUT_SIZE * (I + 1))
    );
END GENERATE;

end Behavioral;
