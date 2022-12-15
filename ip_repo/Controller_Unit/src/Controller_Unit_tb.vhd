----------------------------------------------------------------------------------
-- Created by Morgana Faye Iacocca
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity Controller_Unit_tb is
end Controller_Unit_tb;

architecture Behavioral of Controller_Unit_tb is
    Component Controller_Unit IS
       PORT( 
          CLK                    : IN     std_logic;
          START                  : IN     std_logic;
          Multiplier0            : IN     std_logic;
          Reset                  : IN     std_logic;
          Count                  : IN     std_logic_vector(4 downto 0);
          Multiplier_WS          : OUT    std_logic;
          --Multiplier_EN          : OUT    std_logic;
          Multiplicand_WS        : OUT    std_logic;
          --Multiplicand_EN        : OUT    std_logic;
          Register_EN            : OUT    std_logic;
          Register_RST           : OUT    std_logic;
          Counter_RST            : OUT    std_logic;
          Done                   : OUT    std_logic
       );
    end component;
    
      signal CLK                    :      std_logic;
      signal START                  :      std_logic;
      signal Multiplier0            :      std_logic;
      signal Reset                  :      std_logic;
      signal Count                  :      std_logic_vector(4 downto 0);
      signal Multiplier_WS          :     std_logic;
      --signal Multiplier_EN          :     std_logic;
      signal Multiplicand_WS        :     std_logic;
      --signal Multiplicand_EN        :     std_logic;
      signal Register_EN            :     std_logic;
      signal Register_RST           :     std_logic;
      signal Counter_RST            :     std_logic;
      signal Done                   :     std_logic;
begin
    DUT: Controller_Unit
		port map (
			CLK     =>  CLK,
			START     => START,
			Multiplier0     => Multiplier0,
			Reset     => Reset,
			Count  => Count,
			Multiplier_WS  => Multiplier_WS,
			--Multiplier_EN  => Multiplier_EN,
			Multiplicand_WS  => Multiplicand_WS,
			--Multiplicand_EN  => Multiplicand_EN,
			Register_EN  => Register_EN,
			Register_RST  => Register_RST,
			Counter_RST => Counter_RST,
			Done  => Done
		);
    
    process
    begin
        START <= '0';
        Multiplier0 <= '0';
        Reset <= '0';
        Count <= std_logic_vector(to_unsigned(0, 5));
        CLK <= '0';
        wait for 20 ns;
        
        CLK <= '1';
        wait for 20 ns;
        
        CLK <= '0';
        wait for 20 ns;
        START <= '1';
        CLK <= '1';
        wait for 20 ns;
        START <= '0';
        CLK <= '0';
        wait for 20 ns;
        CLK <= '1';
        wait for 20 ns;
        CLK <= '0';
        wait for 20 ns;
        Multiplier0 <= '1';
        CLK <= '1';
        wait for 20 ns;
        CLK <= '0';
        wait for 20 ns;
        Multiplier0 <= '0';
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
        Count <= std_logic_vector(to_unsigned(31, 5));
        CLK <= '1';
        wait for 20 ns;
        
        CLK <= '0';
        wait for 20 ns;
        
        CLK <= '1';
        wait for 20 ns;
        RESET <= '1';
        CLK <= '0';
        wait for 20 ns;
        
        CLK <= '1';
        wait for 20 ns;
    end process;


end Behavioral;
