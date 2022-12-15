----------------------------------------------------------------------------------
-- Created by Morgana Faye Iacocca
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


entity SignExtend_16to32 is
    Port ( 
        A : in STD_LOGIC_vector(15 downto 0);
        sel : in std_logic;
        Y : out STD_LOGIC_vector(31 downto 0)
    );
end SignExtend_16to32; 

architecture Behavioral of SignExtend_16to32 is

begin
    Y(31 downto 16) <= (31 downto 16 => A(15)) when sel = '1' else (others => '0');
    Y(15 downto 0) <= A;


end Behavioral;
