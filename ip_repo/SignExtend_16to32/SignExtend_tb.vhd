LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity SignExtend_tb is
end SignExtend_tb;

architecture Behavioral of SignExtend_tb is
    component SignExtend_16to32 is
        Port ( 
            A : in STD_LOGIC_vector(15 downto 0);
            Y : out STD_LOGIC_vector(31 downto 0)
        );
    end component; 
    
    signal A : std_logic_vector(15 downto 0);
    signal Y : std_logic_vector(31 downto 0);
begin
    extender: SignExtend_16to32
        port map(
            A => A,
            Y => Y
        );
    
    process
    begin
        A <= std_logic_vector(to_unsigned(15, 16));
        wait for 20 ns;
        A <= std_logic_vector(to_unsigned(4, 16));
        wait for 20 ns;
        A <= std_logic_vector(to_unsigned(32769, 16));
        wait for 20 ns;
    end process;

end Behavioral;
