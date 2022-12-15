-- Created: by - Morgana Faye Iacocca

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity cpu_tb is
    port(
        clock : in std_logic;
        reset : in std_logic
    );
end cpu_tb;

architecture Behavioral of cpu_tb is
    component MIPS_CPU is
        PORT( 
              CLK             : IN     std_logic;
              RST             : IN     std_logic;
              MemoryDataIn    : IN     std_logic_vector(31 downto 0);
              MemoryAddress   : OUT    std_logic_vector(31 downto 0);
              MemoryDataOut   : OUT    std_logic_vector(31 downto 0);
              MemWrite        : OUT    std_logic
              --testOut       : out    std_logic_vector(31 downto 0)
           );
    end component;
    
    component CPU_memory IS
       PORT( 
          Clk      : IN     std_logic;
          MemWrite : IN     std_logic;
          addr     : IN     std_logic_vector (31 DOWNTO 0);
          dataIn   : IN     std_logic_vector (31 DOWNTO 0);
          dataOut  : OUT    std_logic_vector (31 DOWNTO 0)
       );
    
    -- Declarations
    
    END component ;
    
    signal MemoryDataIn : std_logic_vector(31 downto 0);
    signal MemoryAddress : std_logic_vector(31 downto 0);
    signal MemoryDataOut : std_logic_vector(31 downto 0);
    signal MemWrite : std_logic;
    
begin
    U_0 : MIPS_CPU
        port map(
            CLK => clock,
            RST => reset,
            MemoryDataIn => MemoryDataIn,
            MemoryAddress => MemoryAddress,
            MemoryDataOut => MemoryDataOut,
            MemWrite => MemWrite
        );
    
    U_1 : CPU_memory
        port map(
            Clk => clock,
            MemWrite => MemWrite, 
            addr => MemoryAddress,
            dataIn => MemoryDataOut,
            dataOut => MemoryDataIn
        );

end Behavioral;
