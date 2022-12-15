----------------------------------------------------------------------------------
-- Created by Morgana Faye Iacocca 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity Comparator_Unit_tb is
end Comparator_Unit_tb;

architecture Behavioral of Comparator_Unit_tb is

    component Comparator_Unit IS
       generic (
          n       : positive := 32
        );
       port ( 
          A_31      : IN    std_logic;
          B_31      : IN    std_logic;
          S_31      : IN    std_logic;
          CO        : IN    std_logic;
          ALUOp     : IN    std_logic_vector(1 downto 0);
          R         : OUT   std_logic_vector (n-1 DOWNTO 0)
       );
    END component;
    
    constant WIDTH : positive := 32;
    signal  A_31, B_31, S_31, CO    :  std_logic;
    signal  ALUOp                   :  std_logic_vector(1 downto 0);
    signal  R                       :  std_logic_vector (WIDTH-1 DOWNTO 0);
begin

    DUT: Comparator_Unit
        generic map(
            n => WIDTH
        )
        port map(
            A_31 => A_31,
            B_31 => B_31,
            S_31 => S_31,
            CO => CO,
            ALUOp => ALUOp,
            R => R
        );

    process 
    begin
    
        for i in 0 to 4 loop
            for j in 0 to 1 loop
                for k in 0 to 1 loop
                    for l in 0 to 1 loop
                        for m in 0 to 1 loop
                            ALUOp <= std_logic_vector(to_unsigned(i, 2));
                            A_31  <= std_logic(to_unsigned(j, 1)(0));
                            B_31  <= std_logic(to_unsigned(k, 1)(0));
                            S_31  <= std_logic(to_unsigned(l, 1)(0));
                            CO    <= std_logic(to_unsigned(m, 1)(0));
                            wait for 20 ns;
                        end loop;
                    end loop;
                end loop;
            end loop;
        end loop;
        
    end process;

end Behavioral;
