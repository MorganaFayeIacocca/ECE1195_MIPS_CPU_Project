-- Created: by - Morgana Faye Iacocca

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY Logic_Unit IS
   GENERIC (
      n       : positive := 32);
   PORT( 
      A       : IN     std_logic_vector (n-1 DOWNTO 0);
      B       : IN     std_logic_vector (n-1 DOWNTO 0);
      Op      : IN     std_logic_vector (1 DOWNTO 0);
      R       : OUT    std_logic_vector (n-1 DOWNTO 0)
   );

-- Declarations

END Logic_Unit ;

--
ARCHITECTURE struct OF Logic_Unit IS

    component mux_4x1 is
        generic(
            WIDTH : positive := 32
        );
        port(
            D0 : in STD_LOGIC_vector(n-1 downto 0);
            D1 : in STD_LOGIC_vector(n-1 downto 0);
            D2 : in STD_LOGIC_vector(n-1 downto 0);
            D3 : in STD_LOGIC_vector(n-1 downto 0);
            Sel : in STD_LOGIC_vector(1 downto 0);
            Y : out STD_LOGIC_vector(n-1 downto 0)
        );
    end component;
    
    constant muxWIDTH : positive := 32;
   
signal AxorB, AnorB, AorB, AandB: std_logic_vector(n-1 DOWNTO 0);

BEGIN
    AandB <= A and B;
    AorB <= A or B;
    AxorB <= A xor B;
    AnorB <= A nor B;
    
    logic_mux: mux_4x1
        generic map (
            WIDTH => muxWIDTH
        )
        port map(
            D0 => AandB,
            D1 => AorB,
            D2 => AxorB,
            D3 => AnorB,
            Sel => Op,
            Y => R
        );
    
END struct;
