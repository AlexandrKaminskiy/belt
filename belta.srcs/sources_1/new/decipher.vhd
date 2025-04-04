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

entity decipher is
  GENERIC (N_IN : integer := 128;
     K_IN : integer := 256);
  Port (
    CLK : in std_logic;
    X : in std_logic_vector (N_IN - 1 downto 0);
    KEY : in STD_LOGIC_VECTOR(K_IN - 1 downto 0);
    Y: out std_logic_vector (N_IN - 1 downto 0)
  );
end decipher;

architecture Behavioral of decipher is

component round_cascade_decipher is
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
constant ITERATIONS : integer := N_IN / INPUT_SIZE + 1;

signal current_offset : integer := N_IN;
signal tact_number : integer := 0;
signal it : integer := 0;
signal current_cipher : std_logic_vector (INPUT_SIZE - 1 downto 0);
signal current_decipher : std_logic_vector (INPUT_SIZE - 1 downto 0);
signal last_part: std_logic_vector(INPUT_SIZE - 1 downto 0);
signal pr_last_part: std_logic_vector(INPUT_SIZE - 1 downto 0);
signal swapper: std_logic_vector(N_IN - 1 downto 0);
signal y_sig: std_logic_vector(N_IN - 1 downto 0);

constant part_len : integer := 32;
constant OCTET_LENGTH : integer := 8;


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

function value128_to_little_endian(
    x: std_logic_vector(INPUT_SIZE - 1 downto 0)
) return std_logic_vector is
variable a : STD_LOGIC_VECTOR (part_len - 1 downto 0);
variable b : STD_LOGIC_VECTOR (part_len - 1 downto 0);
variable c : STD_LOGIC_VECTOR (part_len - 1 downto 0);
variable d : STD_LOGIC_VECTOR (part_len - 1 downto 0);
begin
    a := to_little_endian(X(INPUT_SIZE - 1 downto INPUT_SIZE - part_len));
    b := to_little_endian(X(INPUT_SIZE - part_len * 1 - 1 downto INPUT_SIZE - part_len * 2));
    c := to_little_endian(X(INPUT_SIZE - part_len * 2 - 1 downto INPUT_SIZE - part_len * 3));
    d := to_little_endian(X(INPUT_SIZE - part_len * 3 - 1 downto INPUT_SIZE - part_len * 4));
    return a & b & c & d;   
end function;

begin

P1: process(CLK)

variable pr_last_part_be : STD_LOGIC_VECTOR (INPUT_SIZE - 1 downto 0);
begin

    if rising_edge(CLK) then
        if not(tact_number = 0) and tact_number mod CIPHER_TACTS = 0 then
            if N_IN mod INPUT_SIZE = 0 then
                last_part <= X(INPUT_SIZE - 1 downto 0);
--                swapper(INPUT_SIZE - 1 downto 0) <= pr_last_part;
            else
                pr_last_part_be := value128_to_little_endian(pr_last_part);
                last_part <= X(N_IN mod INPUT_SIZE - 1 downto 0) & pr_last_part_be(INPUT_SIZE - (N_IN mod INPUT_SIZE) - 1 downto 0);
                swapper(N_IN mod INPUT_SIZE - 1 downto 0) <= pr_last_part_be(INPUT_SIZE - 1 downto N_IN - (N_IN mod INPUT_SIZE));
            end if;
        end if;
        tact_number <= tact_number + 1;

    end if;
--    current_cipher <= X(current_offset - 1 downto current_offset - INPUT_SIZE);
--    Y(current_offset - 1 downto current_offset - INPUT_SIZE) <= current_decipher;

end process;

GEN: FOR I IN 0 TO ITERATIONS - 3 GENERATE
    cascade: round_cascade_decipher port map (
        CLK, 
        X(N_IN - INPUT_SIZE * I - 1 downto N_IN - INPUT_SIZE * (I + 1)), 
        KEY, 
        swapper(N_IN - INPUT_SIZE * I - 1 downto N_IN - INPUT_SIZE * (I + 1))
    );
END GENERATE;
    
cascade_n_m1: round_cascade_decipher port map (
            CLK, 
            X(N_IN - INPUT_SIZE * (ITERATIONS - 2) - 1 downto N_IN - INPUT_SIZE * (ITERATIONS - 2 + 1)), 
            KEY, 
            pr_last_part
        );
            
cascade_n: round_cascade_decipher port map (
            CLK, 
            last_part, 
            KEY, 
            -- предпоследний 3 - 2 = 1 -- 324 - 128 = 256
            swapper(N_IN - INPUT_SIZE * (ITERATIONS - 2) - 1 downto N_IN - INPUT_SIZE * ((ITERATIONS - 2) + 1))
        );


--Y <= swapper(N_IN - 1 downto INPUT_SIZE * 2) & swapper(INPUT_SIZE - 1 downto 0) & swapper(INPUT_SIZE * 2 - 1 downto INPUT_SIZE) when N_IN mod INPUT_SIZE = 0
--     else swapper;

gen_regs: for I in 0 to ITERATIONS - 2 generate
    y_sig(N_IN - INPUT_SIZE * I - 1 downto N_IN - INPUT_SIZE * (I + 1)) <= value128_to_little_endian(swapper(N_IN - INPUT_SIZE * I - 1 downto N_IN - INPUT_SIZE * (I + 1)));
end generate;
y_sig(N_IN mod INPUT_SIZE - 1 downto 0) <= swapper(N_IN mod INPUT_SIZE - 1 downto 0);

Y <= y_sig;


end Behavioral;
