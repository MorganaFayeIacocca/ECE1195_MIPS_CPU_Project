-- Created: by - Morgana Faye Iacocca

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY Register_Unit IS
   GENERIC (
      n       : positive := 64);
   PORT( 
      CLK : IN     std_logic;
      D   : IN     std_logic_vector(n-1 downto 0);
      EN  : IN     std_logic;
      RST : IN     std_logic;
      Q   : OUT    std_logic_vector(n-1 downto 0)
   );

-- Declarations

END Register_Unit ;

--
ARCHITECTURE struct OF Register_Unit IS
begin
     CLKD : process(CLK, RST)
     begin
        if(RST = '1') then
           Q <= (others => '0');
        elsif(CLK'event AND CLK = '1') then
           if(EN = '1') then
              Q <= D;
           end if;
        end if;
     end process CLKD;
    
END struct;
