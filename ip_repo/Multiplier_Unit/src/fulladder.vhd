library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fulladder is
	port (
		A     : in  std_logic;
		B     : in  std_logic;
		Cin   : in  std_logic;
		-- 
		S     : out std_logic;
		Cout  : out std_logic
	);
end entity;

architecture rtl of fulladder is
begin
	Cout <= (A and B) or ((A xor B) and Cin);
	S <= Cin xor (A xor B);
end architecture;
-- new comment

-- A wild new comment appeared!