----------------------------------------------------------------------------------
-- Created by Morgana Faye Iacocca
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity AddSub_Unit_tb is
end AddSub_Unit_tb;

architecture Behavioral of AddSub_Unit_tb is
    component AddSub_Unit is
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
	end component;

	constant WIDTH : positive := 64;
	signal A       : std_logic_vector(WIDTH-1 downto 0);
	signal B       : std_logic_vector(WIDTH-1 downto 0);
	signal k       : std_logic;
	signal S       : std_logic_vector(WIDTH-1 downto 0);
	signal Cout    : std_logic;
begin

    DUT: AddSub_Unit
		generic map (
			WIDTH => WIDTH
		)
		port map (
			A     => A,
			B     => B,
			k     => k,
			S     => S,
			Cout  => Cout
		);
    
    process
    begin
		  -- Use width of 32, but don't simulate all **31
		for i in 0 to 2**4-1 loop
			for j in 0 to 2**4-1 loop
				k <= '0';
				A <= std_logic_vector(to_unsigned(i, WIDTH));
				B <= std_logic_vector(to_unsigned(j, WIDTH));
				wait for 20 ns;
			end loop;
		end loop;
		wait for 200 ns;
		k <= '0';
		A <= std_logic_vector(to_signed(-1, WIDTH));
		B <= std_logic_vector(to_signed(-1, WIDTH));
		wait for 200 ns;
		wait for 200 ns;
		k <= '0';
		A <= std_logic_vector(to_signed(-1, WIDTH));
		B <= std_logic_vector(to_signed(1, WIDTH));
		wait for 200 ns;
	end process;


end Behavioral;
