-- Created: by - Morgana Faye Iacocca

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY ALU IS
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

END ALU  ;

--
ARCHITECTURE struct OF ALU  IS
    component Logic_Unit IS
       GENERIC (
          n       : positive := 32);
       PORT( 
          A       : IN     std_logic_vector (n-1 DOWNTO 0);
          B       : IN     std_logic_vector (n-1 DOWNTO 0);
          Op      : IN     std_logic_vector (1 DOWNTO 0);
          R       : OUT    std_logic_vector (n-1 DOWNTO 0)
       );
    
    END component ;
    
    component Shifter_Unit IS
       GENERIC (
          n       : positive := 32);
       PORT( 
          A       : IN     std_logic_vector (n-1 DOWNTO 0);
          SHAMT   : IN     std_logic_vector (4 DOWNTO 0);
          ALUOp   : IN     std_logic_vector (1 DOWNTO 0);
          R       : OUT    std_logic_vector (n-1 DOWNTO 0)
       );
    
    END component ;
    
    component Arith_Unit IS
       GENERIC (
          n       : positive := 32);
       PORT( 
          A       : IN     std_logic_vector (n-1 DOWNTO 0);
          B       : IN     std_logic_vector (n-1 DOWNTO 0);
          C_op    : IN     std_logic_vector (1 DOWNTO 0);
          CO      : OUT    std_logic;
          OFL     : OUT    std_logic;
          S       : OUT    std_logic_vector (n-1 DOWNTO 0);
          Z       : OUT    std_logic
       );
    
    END component ;
    
    component Comparator_Unit IS
       GENERIC (
          n       : positive := 32);
       PORT( 
          A_31      : IN    std_logic;
          B_31      : IN    std_logic;
          S_31      : IN    std_logic;
          CO        : IN    std_logic;
          ALUOp     : IN    std_logic_vector(1 downto 0);
          R         : OUT   std_logic_vector (n-1 DOWNTO 0)
       );
    
    END component ;
    
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
    
    constant WIDTH : positive := 32;
    signal LogicalR, ArithR, CompR, ShiftR : std_logic_vector(WIDTH-1 downto 0);
    signal Carryout : std_logic;
    
BEGIN
    
    ALU_Logical: Logic_Unit
        generic map(
            n => WIDTH
        )
        port map(
            A => A,
            B => B,
            Op => ALUOp(1 downto 0),
            R => LogicalR
        );
    
    ALU_Arith: Arith_Unit
        generic map(
            n => WIDTH
        )
        port map(
            A => A,
            B => B,
            C_op => ALUOp(1 downto 0),
            CO => Carryout,
            OFL => Overflow,
            S => ArithR,
            Z => Zero
        );
     
    ALU_Comp: Comparator_Unit
        generic map(
            n => WIDTH
        )
        port map(
            A_31   => A(31),
            B_31   => B(31),
            S_31   => ArithR(31),
            CO     => Carryout,
            ALUOp  => ALUOp(1 downto 0),
            R      => CompR
        );
    
    ALU_Shift: Shifter_Unit
        generic map(
            n => WIDTH
        )
        port map(
            A      => B,
            SHAMT  => SHAMT,
            ALUOp  => ALUOp(1 downto 0),
            R      => ShiftR
        );
    
    ALU_Mux : mux_4x1
        generic map(
            WIDTH => WIDTH
        )
        port map(
            D0 => LogicalR,
            D1 => ArithR,
            D2 => CompR,
            D3 => ShiftR,
            Sel => ALUOp(3 downto 2),
            Y => R
        );
    
END struct;
