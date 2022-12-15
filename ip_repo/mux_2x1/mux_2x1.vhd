----------------------------------------------------------------------------------
-- Created by Morgana Faye Iacocca
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


entity mux_2x1 is
    GENERIC (
      WIDTH       : positive := 32
    );
    Port ( 
        D0 : in STD_LOGIC_vector(WIDTH-1 downto 0);
        D1 : in STD_LOGIC_vector(WIDTH-1 downto 0);
        Sel : in STD_LOGIC;
        Y : out STD_LOGIC_vector(WIDTH-1 downto 0)
    );
end mux_2x1;

architecture Behavioral of mux_2x1 is

begin

    with Sel select
        Y <= D0 when '0',
             D1 when '1',
             (others => '0') when others;

end Behavioral;
