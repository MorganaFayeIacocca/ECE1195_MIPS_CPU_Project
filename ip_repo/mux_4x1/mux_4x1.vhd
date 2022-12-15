----------------------------------------------------------------------------------
-- Created by Morgana Faye Iacocca
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


entity mux_4x1 is
    GENERIC (
      WIDTH       : positive := 32
    );
    Port ( 
        D0 : in STD_LOGIC_vector(WIDTH-1 downto 0);
        D1 : in STD_LOGIC_vector(WIDTH-1 downto 0);
        D2 : in STD_LOGIC_vector(WIDTH-1 downto 0);
        D3 : in STD_LOGIC_vector(WIDTH-1 downto 0);
        Sel : in STD_LOGIC_vector(1 downto 0);
        Y : out STD_LOGIC_vector(WIDTH-1 downto 0)
    );
end mux_4x1;

architecture Behavioral of mux_4x1 is

begin

    with Sel select
        Y <= D0 when "00",
             D1 when "01",
             D2 when "10",
             D3 when "11",
             (others => '0') when others;

end Behavioral;
