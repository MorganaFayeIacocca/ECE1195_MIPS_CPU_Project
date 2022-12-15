----------------------------------------------------------------------------------
-- Created by Morgana Faye Iacocca
----------------------------------------------------------------------------------

library IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity Logic_Unit_tb is
end Logic_Unit_tb;

architecture Behavioral of Logic_Unit_tb is

    component Logic_Unit is
        GENERIC (
            n       : positive := 32);
        PORT( 
            A       : IN     std_logic_vector (n-1 DOWNTO 0);
            B       : IN     std_logic_vector (n-1 DOWNTO 0);
            Op      : IN     std_logic_vector (1 DOWNTO 0);
            R       : OUT    std_logic_vector (n-1 DOWNTO 0)
        );
    end component;
    
    constant WIDTH  : positive := 32;
    signal A        : std_logic_vector(WIDTH-1 downto 0);
    signal B        : std_logic_vector(WIDTH-1 downto 0);
    signal Op        : std_logic_vector(1 downto 0);
    signal R        : std_logic_vector(WIDTH-1 downto 0);

begin

    DUT: Logic_Unit
        generic map(
            n => WIDTH
        )
        port map(
            A => A,
            B => B,
            Op => Op,
            R => R
        );
    
    process
    begin
        -- Test Ands
        Op <= "00";
        A <= std_logic_vector(to_unsigned(0, WIDTH));
        B <= std_logic_vector(to_unsigned(0, WIDTH));
        wait for 20 ns;
        A <= std_logic_vector(to_unsigned(0, WIDTH));
        B <= std_logic_vector(to_signed(-1, WIDTH));
        wait for 20 ns;
        A <= std_logic_vector(to_signed(-1, WIDTH));
        B <= std_logic_vector(to_unsigned(0, WIDTH));
        wait for 20 ns;
        A <= std_logic_vector(to_signed(-1, WIDTH));
        B <= std_logic_vector(to_signed(-1, WIDTH));
        wait for 20 ns;
        A <= std_logic_vector(to_signed(-1, WIDTH));
        B <= "10101010101010101010101010101010";
        wait for 20 ns;
        A <= "10101010101010101010101010101010";
        B <= std_logic_vector(to_signed(-1, WIDTH));
        wait for 20 ns;
        A <= std_logic_vector(to_unsigned(0, WIDTH));
        B <= "10101010101010101010101010101010";
        wait for 20 ns;
        A <= "10101010101010101010101010101010";
        B <= "11111111111111110000000000000000";
        wait for 20 ns;
        A <= std_logic_vector(to_unsigned(0, WIDTH));
        B <= std_logic_vector(to_unsigned(0, WIDTH));
        wait for 40 ns;
        
        -- Test Ors
        Op <= "01";
        A <= std_logic_vector(to_unsigned(0, WIDTH));
        B <= std_logic_vector(to_unsigned(0, WIDTH));
        wait for 20 ns;
        A <= std_logic_vector(to_unsigned(0, WIDTH));
        B <= std_logic_vector(to_signed(-1, WIDTH));
        wait for 20 ns;
        A <= std_logic_vector(to_signed(-1, WIDTH));
        B <= std_logic_vector(to_unsigned(0, WIDTH));
        wait for 20 ns;
        A <= std_logic_vector(to_signed(-1, WIDTH));
        B <= std_logic_vector(to_signed(-1, WIDTH));
        wait for 20 ns;
        A <= std_logic_vector(to_signed(-1, WIDTH));
        B <= "10101010101010101010101010101010";
        wait for 20 ns;
        A <= "10101010101010101010101010101010";
        B <= std_logic_vector(to_signed(-1, WIDTH));
        wait for 20 ns;
        A <= std_logic_vector(to_unsigned(0, WIDTH));
        B <= "10101010101010101010101010101010";
        wait for 20 ns;
        A <= "10101010101010101010101010101010";
        B <= "11111111111111110000000000000000";
        wait for 20 ns;
        A <= std_logic_vector(to_unsigned(0, WIDTH));
        B <= std_logic_vector(to_unsigned(0, WIDTH));
        wait for 40 ns;
        
        -- Test xors
        Op <= "10";
        A <= std_logic_vector(to_unsigned(0, WIDTH));
        B <= std_logic_vector(to_unsigned(0, WIDTH));
        wait for 20 ns;
        A <= std_logic_vector(to_unsigned(0, WIDTH));
        B <= std_logic_vector(to_signed(-1, WIDTH));
        wait for 20 ns;
        A <= std_logic_vector(to_signed(-1, WIDTH));
        B <= std_logic_vector(to_unsigned(0, WIDTH));
        wait for 20 ns;
        A <= std_logic_vector(to_signed(-1, WIDTH));
        B <= std_logic_vector(to_signed(-1, WIDTH));
        wait for 20 ns;
        A <= std_logic_vector(to_signed(-1, WIDTH));
        B <= "10101010101010101010101010101010";
        wait for 20 ns;
        A <= "10101010101010101010101010101010";
        B <= std_logic_vector(to_signed(-1, WIDTH));
        wait for 20 ns;
        A <= std_logic_vector(to_unsigned(0, WIDTH));
        B <= "10101010101010101010101010101010";
        wait for 20 ns;
        A <= "10101010101010101010101010101010";
        B <= "11111111111111110000000000000000";
        wait for 20 ns;
        A <= std_logic_vector(to_unsigned(0, WIDTH));
        B <= std_logic_vector(to_unsigned(0, WIDTH));
        wait for 40 ns;
        
        -- Test xors
        Op <= "11";
        A <= std_logic_vector(to_unsigned(0, WIDTH));
        B <= std_logic_vector(to_unsigned(0, WIDTH));
        wait for 20 ns;
        A <= std_logic_vector(to_unsigned(0, WIDTH));
        B <= std_logic_vector(to_signed(-1, WIDTH));
        wait for 20 ns;
        A <= std_logic_vector(to_signed(-1, WIDTH));
        B <= std_logic_vector(to_unsigned(0, WIDTH));
        wait for 20 ns;
        A <= std_logic_vector(to_signed(-1, WIDTH));
        B <= std_logic_vector(to_signed(-1, WIDTH));
        wait for 20 ns;
        A <= std_logic_vector(to_signed(-1, WIDTH));
        B <= "10101010101010101010101010101010";
        wait for 20 ns;
        A <= "10101010101010101010101010101010";
        B <= std_logic_vector(to_signed(-1, WIDTH));
        wait for 20 ns;
        A <= std_logic_vector(to_unsigned(0, WIDTH));
        B <= "10101010101010101010101010101010";
        wait for 20 ns;
        A <= "10101010101010101010101010101010";
        B <= "11111111111111110000000000000000";
        wait for 20 ns;
        A <= std_logic_vector(to_unsigned(0, WIDTH));
        B <= std_logic_vector(to_unsigned(0, WIDTH));
        wait for 40 ns;
        
    end process;

end Behavioral;
