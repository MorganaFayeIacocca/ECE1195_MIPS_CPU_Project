-- Created: by - Morgana Faye Iacocca

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity Shifter_26to28 is
    Port ( A : in STD_LOGIC_VECTOR (25 downto 0);
           Y : out STD_LOGIC_VECTOR (27 downto 0));
end Shifter_26to28;

architecture Behavioral of Shifter_26to28 is
begin
    Y <= A & "00";

end Behavioral;
