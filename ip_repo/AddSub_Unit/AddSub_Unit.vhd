library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity AddSub_Unit is
	generic (
		WIDTH : positive := 64
	);
	port (
		A     : in  std_logic_vector(WIDTH-1 downto 0);
		B     : in  std_logic_vector(WIDTH-1 downto 0);
		k     : in  std_logic;
		S     : out std_logic_vector(WIDTH-1 downto 0);
		Cout  : out std_logic
	);

end entity;

architecture rtl of AddSub_Unit is

component fulladder is
	port (
		A     : in  std_logic;
		B     : in  std_logic;
		Cin   : in  std_logic;
		-- 
		S     : out std_logic;
		Cout  : out std_logic
	);
end component;
--Use signal instead of port here, because Carries only need to be accessed internally
Signal Carry: std_logic_vector(WIDTH-1 downto 0);
Signal BComp: std_logic_vector(WIDTH-1 downto 0);
begin
    -- Base Case, the first "segment" of the series of adders/subtractors
    BComp(0) <= B(0) xor k;
    adder0: fulladder port map(A(0), BComp(0), k, S(0), Carry(0));
    -- All other fulladder "segments"
    Gen1: For i in 1 to WIDTH-1 generate
        --Feed each i-th carry bit into the i+1th "segment" of the adder/subtractor
        --Replace the standard B in a full adder with B xor k to allow for selecting add or subtract
        BComp(i) <= B(i) xor k;
        adders: fulladder port map(A(i), BComp(i), Carry(i-1), S(i), Carry(i));
    end generate;
    
	Cout <= Carry(WIDTH-1);
end architecture;
