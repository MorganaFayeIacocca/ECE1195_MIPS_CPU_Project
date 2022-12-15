-- Created: by - Morgana Faye Iacocca

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY Shifter_Unit IS
   GENERIC (
      n       : positive := 32);
   PORT( 
      A       : IN     std_logic_vector (n-1 DOWNTO 0);
      SHAMT   : IN     std_logic_vector (4 DOWNTO 0);
      ALUOp   : IN     std_logic_vector (1 DOWNTO 0);
      R       : OUT    std_logic_vector (n-1 DOWNTO 0)
   );

-- Declarations

END Shifter_Unit ;

--
ARCHITECTURE struct OF Shifter_Unit IS

    component mux_2x1 is
        generic(
            WIDTH : positive := 32
        );
        port(
            D0 : in STD_LOGIC_vector(n-1 downto 0);
            D1 : in STD_LOGIC_vector(n-1 downto 0);
            Sel : in STD_LOGIC;
            Y : out STD_LOGIC_vector(n-1 downto 0)
        );
    end component;
    
    constant muxWIDTH : positive := 32;
   
signal L0, L1, L2, L3, L4, R0, R1, R2, R3, R4, Fill: std_logic_vector(n-1 DOWNTO 0);

BEGIN
    with SHAMT(0) select
        L0 <= A when '0',
              A(30 downto 0) & '0' when '1',
             (others => '0') when others;
    
    with SHAMT(1) select
        L1 <= L0 when '0',
              L0(29 downto 0) & "00" when '1',
             (others => '0') when others; 
    
    with SHAMT(2) select
        L2 <= L1 when '0',
              L1(27 downto 0) & "0000" when '1',
             (others => '0') when others; 
    
    with SHAMT(3) select
        L3 <= L2 when '0',
              L2(23 downto 0) & "00000000" when '1',
             (others => '0') when others;    
    
    with SHAMT(4) select
        L4 <= L3 when '0',
              L3(15 downto 0) & "0000000000000000" when '1',
             (others => '0') when others; 
    
    Fill <= (others => ALUOp(0) and A(31));
    
    with SHAMT(0) select
        R0 <= A when '0',
              Fill(0) & A(31 downto 1) when '1',
             (others => '0') when others;
    
    with SHAMT(1) select
        R1 <= R0 when '0',
              Fill(1 downto 0) & R0(31 downto 2) when '1',
             (others => '0') when others; 
    
    with SHAMT(2) select
        R2 <= R1 when '0',
              Fill(3 downto 0) & R1(31 downto 4) when '1',
             (others => '0') when others; 
    
    with SHAMT(3) select
        R3 <= R2 when '0',
              Fill(7 downto 0) & R2(31 downto 8) when '1',
             (others => '0') when others;    
    
    with SHAMT(4) select
        R4 <= R3 when '0',
              Fill(15 downto 0) & R3(31 downto 16) when '1',
             (others => '0') when others; 
    
    shifter_mux: mux_2x1
        generic map (
            WIDTH => muxWIDTH
        )
        port map(
            D0 => L4,
            D1 => R4,
            Sel => ALUOp(1),
            Y => R
        );
    
END struct;
