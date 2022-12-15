-- Created: by - Morgana Faye Iacocca

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity Shifter_32to32 is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           Y : out STD_LOGIC_VECTOR (31 downto 0));
end Shifter_32to32;

architecture Behavioral of Shifter_32to32 is
begin
    Y <= A(29 downto 0) & "00";

end Behavioral;
