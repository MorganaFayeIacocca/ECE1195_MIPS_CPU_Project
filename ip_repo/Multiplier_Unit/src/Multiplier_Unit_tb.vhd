----------------------------------------------------------------------------------
-- Created by Morgana Faye Iacocca
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity Multiplier_Unit_tb is
end Multiplier_Unit_tb;

architecture Behavioral of Multiplier_Unit_tb is
    component Multiplier_Unit is
        port (
            A     : in  std_logic_vector(31 downto 0);
            B     : in  std_logic_vector(31 downto 0);
            Clk   : in  std_logic;
            RST   : in  std_logic;
            -- 
            R     : out std_logic_vector(63 downto 0);
            Done  : out std_logic
            --testALU : out std_logic_vector(63 downto 0);
		    --testShift : out std_logic_vector(63 downto 0);
		    --testShift2 : out std_logic_vector(31 downto 0);
		    --testPlicandWS : out std_logic;
		    --testState           : out    std_logic_vector(1 downto 0)

        );
    end component;
    
    signal A : std_logic_vector(31 downto 0);
    signal B : std_logic_vector(31 downto 0);
    signal Clk : std_logic;
    signal RST : std_logic;
    signal R : std_logic_vector(63 downto 0);
    signal Done : std_logic;
    --signal testALU : std_logic_vector(63 downto 0);
	--signal testShift : std_logic_vector(63 downto 0);
	--signal testShift2 : std_logic_vector(31 downto 0);
	--signal testPlicandWS : std_logic;
	--signal testState    :  std_logic_vector(1 downto 0);
begin
        
    mult : Multiplier_Unit
        port map(
            A => A,
            B => B,
            Clk => Clk, 
            RST => RST, 
            R => R, 
            Done => Done
            --testALU => testALU,
            --testShift =>testShift,
            --testShift2 =>testShift2,
            --testPlicandWS => testPlicandWS,
            --testState => testState
        );
    
    process
    begin
       A <= std_logic_vector(to_unsigned(0, 32));
       B <= std_logic_vector(to_unsigned(0, 32));
       CLK <= '0';
       RST <= '1';
       wait for 20 ns;
       CLK <= '1';
       wait for 20 ns;
       CLK <= '0';
       RST <= '0';
       A <= std_logic_vector(to_unsigned(3, 32));
       B <= std_logic_vector(to_unsigned(4, 32));
       wait for 20 ns;
       CLK <= '1';
       wait for 20 ns;
       CLK <= '0';
       for i in 0 to 32 loop
           CLK <= '1';
           wait for 20 ns;
           CLK <= '0';
           wait for 20 ns;
       end loop;

        
    end process;


end Behavioral;
