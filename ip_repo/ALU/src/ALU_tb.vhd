----------------------------------------------------------------------------------
-- Created by Morgana Faye Iacocca
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity ALU_tb is
end ALU_tb;

architecture Behavioral of ALU_tb is
    component ALU IS
       GENERIC (
          n       : positive := 32);
       PORT( 
          A       : IN     std_logic_vector (n-1 DOWNTO 0);
          B       : IN     std_logic_vector (n-1 DOWNTO 0);
          ALUOp   : IN     std_logic_vector (3 DOWNTO 0);
          SHAMT   : IN     std_logic_vector (4 downto 0);
          R       : OUT    std_logic_vector (n-1 DOWNTO 0);
          Zero    : OUT    std_logic;
          Overflow: OUT    std_logic
       );

    END component  ;
    
    constant WIDTH : positive := 32;
    signal A       :  std_logic_vector (WIDTH-1 DOWNTO 0);
    signal B       :  std_logic_vector (WIDTH-1 DOWNTO 0);
    signal ALUOp   :  std_logic_vector (3 DOWNTO 0);
    signal SHAMT   :  std_logic_vector (4 downto 0);
    signal R       :  std_logic_vector (WIDTH-1 DOWNTO 0);
    signal Zero    :  std_logic;
    signal Overflow:  std_logic;
    
begin

    DUT: ALU
        generic map(
            n => WIDTH
        )
        port map(
            A => A,
            B => B,
            ALUOp => ALUOp,
            SHAMT => SHAMT,
            R => R,
            Zero => Zero,
            Overflow => Overflow
        );
        
    process
    begin
        SHAMT <= "00000";
        -- Test the Logic
        -- and
        ALUOp <= "0000";
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
        ALUOp <= "0001";
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
        ALUOp <= "0010";
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
        ALUOp <= "0011";
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
        
        -- Test Arithmetic
        A <= std_logic_vector(to_unsigned(0, WIDTH));
        B <= std_logic_vector(to_unsigned(0, WIDTH));
        wait for 100 ns;
    
        for i in -16 to 16 loop
            for j in -16 to 16 loop
                ALUOp <= "0100";
                A <= std_logic_vector(to_signed(i, WIDTH));
                B <= std_logic_vector(to_signed(j, WIDTH));
                wait for 20 ns;
                ALUOp <= "0110";
                A <= std_logic_vector(to_signed(i, WIDTH));
                B <= std_logic_vector(to_signed(j, WIDTH));
                wait for 20 ns;
            end loop;
        end loop;
        
        for i in 0 to 16 loop
            for j in 0 to 16 loop
                ALUOp <= "0101";
                A <= std_logic_vector(to_unsigned(i, WIDTH));
                B <= std_logic_vector(to_unsigned(j, WIDTH));
                wait for 20 ns;
                ALUOp <= "0111";
                A <= std_logic_vector(to_unsigned(i, WIDTH));
                B <= std_logic_vector(to_unsigned(j, WIDTH));
                wait for 20 ns;
            end loop;
        end loop;
    
    -- Test Comparator
    
    for i in -16 to 16 loop
        for j in -16 to 16 loop
            ALUOp <= "1010";
            A <= std_logic_vector(to_signed(i, WIDTH));
	        B <= std_logic_vector(to_signed(j, WIDTH));
            wait for 20 ns;
        end loop;
    end loop;
    wait for 40 ns;
    for i in 0 to 16 loop
        for j in 0 to 16 loop
            ALUOp <= "1011";
            A <= std_logic_vector(to_unsigned(i, WIDTH));
	        B <= std_logic_vector(to_unsigned(j, WIDTH));
            wait for 20 ns;
        end loop;
    end loop;
    
    -- Test Shifter
    A <= x"FEDCBA98";
        
    for i in 0 to 2**5 -1 loop
        SHAMT <= std_logic_vector(to_unsigned(i, 5));
        ALUOp <= "1100";
        wait for 20ns;
        ALUOp <= "1101";
        wait for 20ns;
        ALUOp <= "1110";
        wait for 20ns;
        ALUOp <= "1111";
        wait for 40ns;
    end loop;
    end process;    
    
    
    


end Behavioral;
