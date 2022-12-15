----------------------------------------------------------------------------------
-- Created by Morgana Faye Iacocca
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity Shift_Register_Unit_tb is
end Shift_Register_Unit_tb; 

architecture Behavioral of Shift_Register_Unit_tb is
    component Shift_Register_Unit IS
       GENERIC (
          n       : positive := 32
       );
       PORT(
          CLK     : IN     std_logic;
          WS      : IN     std_logic; -- write/shift 1 is write, 0 is shift
          k       : IN     std_logic; -- direction, 0 = left, 1 = right
          RST     : IN     std_logic; 
          D       : IN     std_logic_vector (n-1 DOWNTO 0);
          Q       : OUT    std_logic_vector (n-1 DOWNTO 0)
       );
    end component;
    
    constant WIDTH : positive := 64;
    signal CLK     :  std_logic;
    signal WS      :  std_logic; -- write/shift 1 is write, 0 is shift
    signal k       :  std_logic; -- direction, 0 = left, 1 = right
    signal RST     :  std_logic; 
    signal D       :  std_logic_vector (WIDTH-1 DOWNTO 0);
    signal Q       :  std_logic_vector (WIDTH-1 DOWNTO 0);
begin

    DUT: Shift_Register_Unit
        generic map(
            n => WIDTH
        )
        port map(
            CLK => CLK,
            WS => WS,
            k => k,
            RST => RST,
            D => D,
            Q => Q 
        );
    
    process
    begin
        CLK <= '0';
        WS <= '1';
        k <= '1';
        RST <= '0';
        D <= std_logic_vector(to_unsigned(742, WIDTH));
        wait for 20 ns;
        CLK <= '1';
        wait for 20 ns;
        WS <= '0';
        CLK <= '0';
        wait for 20 ns;
        CLK <= '1';
        wait for 20 ns;
        CLK <= '0';
        D <= std_logic_vector(to_unsigned(323, WIDTH));
        wait for 20 ns;
        WS <= '1';
        CLK <= '1';
        wait for 20 ns;
        WS <= '0';
        CLK <= '0';
        wait for 20 ns;
        k <= '0';
        CLK <= '1';
        wait for 20 ns;
        CLK <= '0';
        wait for 20 ns;
        
        CLK <= '1';
        wait for 20 ns;
        
        CLK <= '0';
        wait for 20 ns;
        
        CLK <= '1';
        wait for 20 ns;
        
        CLK <= '0';
        wait for 20 ns;
        
    end process;


end Behavioral;
