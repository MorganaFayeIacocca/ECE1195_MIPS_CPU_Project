library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Multiplier_Unit is
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
		--testShift2 :  out std_logic_vector(31 downto 0);
		--testPlicandWS : out std_logic;
		--testState           : out    std_logic_vector(1 downto 0)

	);
end entity;

architecture rtl of Multiplier_Unit is
    component AddSub_Unit is
        generic (
            WIDTH : positive := 64
        );
        port (
            A     : in  std_logic_vector(WIDTH-1 downto 0);
            B     : in  std_logic_vector(WIDTH-1 downto 0);
            k     : in  std_logic;
            S     : out std_logic_vector(WIDTH-1 downto 0);
            Cout  : out std_logic
        );
    end component;

    component Controller_Unit IS
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
          --myState                : out    std_logic_vector(1 downto 0)
       );
    END component ;
    
    component Counter_Unit is
        GENERIC (
          n       : positive := 5);
        PORT( 
          CLK : IN     std_logic;
          RST : IN     std_logic;
          Q   : OUT    std_logic_vector(n-1 downto 0)
       );
    end component;
    
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
    END component ;
    
    component Shift_Register_Unit IS
       GENERIC (
          n       : positive := 32);
       PORT(
          CLK     : IN     std_logic;
          WS      : IN     std_logic; -- write/shift 1 is write, 0 is shift
          k       : IN     std_logic; -- direction, 0 = left, 1 = right
          RST     : IN     std_logic; 
          D       : IN     std_logic_vector (n-1 DOWNTO 0);
          Q       : OUT    std_logic_vector (n-1 DOWNTO 0)
       );
    END component ;
    
    constant WIDTH1 : positive := 64;
    constant WIDTH2 : positive := 32;
    constant WIDTHcounter : positive := 5;
    constant ZERO : std_logic_vector(WIDTH1-1 downto 0) := (others => '0');
    constant multiplicandDirec  : std_logic := '0'; -- set to shift left
    constant multiplierDirec    : std_logic := '1'; -- set to shift right
    constant addSubVal          : std_logic := '0'; -- set to add
    constant startSequence      : std_logic := '1'; -- always start FSM, dont wait for signal
    
    signal Mult0                : std_logic;
    signal ALUOut               : std_logic_vector(WIDTH1-1 downto 0);
    signal ProductOut           : std_logic_vector(WIDTH1-1 downto 0);
    signal MultiplicandShifted  : std_logic_vector(WIDTH1-1 downto 0);
    signal MultiplierShifted    : std_logic_vector(WIDTH2-1 downto 0);
    signal expandedA            : std_logic_vector(WIDTH1-1 downto 0);
    signal Multiplier_WS        : std_logic;
    signal Multiplicand_WS      : std_logic;
    signal Register_EN          : std_logic;
    signal Register_RST         : std_logic;
    signal Counter_RST          : std_logic;
    signal count                : std_logic_vector(4 downto 0);
    signal controlDone          : std_logic;
    signal ALUcOut              : std_logic; -- provide signal btu ignore it
begin
    --testPlicandWS <= Multiplicand_WS;
    expandedA <= ZERO(63 downto 32) & A;
    
	MultiplierShifter : Shift_Register_Unit
	   generic map(
	       n => WIDTH2
	   )
	   port map(
	       CLK => CLK,
	       WS => Multiplier_WS,
	       k => multiplierDirec,
	       RST => multiplicandDirec, --bad
	       D => B,
	       Q => MultiplierShifted
	   );
	
	MultiplicandShifter : Shift_Register_Unit
	   generic map(
	       n => WIDTH1
	   )
	   port map(
	       CLK => CLK,
	       WS => Multiplicand_WS,
	       k => multiplicandDirec,
	       RST => multiplicandDirec, --bad
	       D => expandedA,
	       Q => MultiplicandShifted
	   );
	
	ALU : AddSub_Unit
	   generic map(
	       WIDTH => WIDTH1
	   )
	   port map(
	       A => MultiplicandShifted,
           B => ProductOut,
           k => addSubVal,
           S => ALUOut,
           Cout => ALUcOut
	   );
	   
	CounterUnit : Counter_Unit
	   generic map(
	       n => WIDTHcounter
	   )
        port map(
           CLK => CLK,
           RST => Counter_RST,
           Q => count
        );
      
    ProductReg : Register_Unit
       generic map(
            n => WIDTH1
       )
       port map(
            CLK => CLK,
            D => ALUOut,
            EN => Register_EN,
            RST => Register_RST ,
            Q => ProductOut
       );
       
    Controller : Controller_Unit
        port map(
          CLK     => CLK,
          START   => startSequence,
          Multiplier0  => MultiplierShifted(0),
          Reset     => RST,
          Count    => count,
          Multiplier_WS   => Multiplier_WS,
          --Multiplier_EN          : OUT    std_logic;
          Multiplicand_WS  => Multiplicand_WS,
          --Multiplicand_EN        : OUT    std_logic;
          Register_EN   => Register_EN,
          Register_RST  => Register_RST,
          Counter_RST  => Counter_RST,
          Done    => controlDone
          --myState => testState
        );
	   
	R <= ProductOut;
	Done <= controlDone;
	--testALU <=  ALUOut;
	--testShift <= MultiplicandShifted;
	--testShift2 <= MultiplierShifted;
end architecture;
-- new comment

-- A wild new comment appeared!