----------------------------------------------------------------------------------
-- Created by Morgana Faye Iacocca
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity Register_Unit_tb is
end Register_Unit_tb;

architecture Behavioral of Register_Unit_tb is
    component Register_Unit IS
       GENERIC (
          n       : positive := 64);
       PORT( 
          CLK : IN     std_logic;
          D   : IN     std_logic_vector(n-1 downto 0);
          EN  : IN     std_logic;
          RST : IN     std_logic;
          Q   : OUT    std_logic_vector(n-1 downto 0)
       );
    
    -- Declarations
    
    END component;

    constant WIDTH : positive := 64;
	signal D       : std_logic_vector(WIDTH-1 downto 0);
	signal EN      : std_logic;
	signal CLK     : std_logic;
	signal RST     : std_logic;
	signal Q       : std_logic_vector(WIDTH-1 downto 0);
begin

    DUT: Register_Unit
        generic map(
             n => WIDTH
        )
        port map(
            CLK => CLK,
            D => D,
            EN => EN,
            RST => RST,
            Q => Q
        );
    
    process
    begin
        EN <= '0';
        RST <= '0';
        CLK <= '0';
        D <= std_logic_vector(to_unsigned(30, WIDTH));
        wait for 20 ns;
        CLK <= '1';
        wait for 20 ns;
        CLK <= '0';
        wait for 20 ns;
        EN <= '1';
        wait for 20 ns;
        CLK <= '1';
        wait for 20 ns;
        EN <= '0';
        CLK <= '0';
        wait for 20 ns;
        D <= std_logic_vector(to_unsigned(36, WIDTH));
        CLK <= '1';
        wait for 20 ns;
        CLK <= '0';
        wait for 20 ns;
        EN <= '1';
        CLK <= '1';
        wait for 20 ns;
        EN <= '0';
        CLK <= '0';
        wait for 20 ns;
        RST <= '1';
        wait for 20 ns;
    end process;


end Behavioral;
