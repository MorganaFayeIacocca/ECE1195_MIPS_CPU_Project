----------------------------------------------------------------------------------
-- Created by Morgana Faye Iacocca
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity Shifter_Unit_tb is
end Shifter_Unit_tb;

architecture Behavioral of Shifter_Unit_tb is

    component Shifter_Unit is
        GENERIC (
            n       : positive := 32);
        PORT( 
            A       : IN     std_logic_vector (n-1 DOWNTO 0);
            SHAMT   : IN     std_logic_vector (4 DOWNTO 0);
            ALUOp   : IN     std_logic_vector (1 DOWNTO 0);
            R       : OUT    std_logic_vector (n-1 DOWNTO 0)
   );
    end component;
    
    constant WIDTH  : positive := 32;
    signal A        : std_logic_vector(WIDTH-1 downto 0);
    signal SHAMT        : std_logic_vector(4 downto 0);
    signal ALUOp        : std_logic_vector(1 downto 0);
    signal R        : std_logic_vector(WIDTH-1 downto 0);

begin

    DUT: Shifter_Unit
        generic map(
            n => WIDTH
        )
        port map(
            A => A,
            SHAMT => SHAMT,
            ALUOp => ALUOp,
            R => R
        );
    
    process
    begin
        A <= x"FEDCBA98";
        
        for i in 0 to 2**5 -1 loop
            SHAMT <= std_logic_vector(to_unsigned(i, 5));
            ALUOp <= "00";
            wait for 20ns;
            ALUOp <= "01";
            wait for 20ns;
            ALUOp <= "10";
            wait for 20ns;
            ALUOp <= "11";
            wait for 40ns;
        end loop;
        
    end process;


end Behavioral;
