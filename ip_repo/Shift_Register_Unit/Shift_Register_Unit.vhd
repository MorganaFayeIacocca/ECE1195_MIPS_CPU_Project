-- Created: by - Morgana Faye Iacocca

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY Shift_Register_Unit IS
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

-- Declarations

END Shift_Register_Unit ;

--
ARCHITECTURE struct OF Shift_Register_Unit IS
    signal tempQ : std_logic_vector(n-1 downto 0);
begin
        Q <= tempQ;
    CLKD: process(CLK, RST)
    begin
        if(RST='1') then
            tempQ <= (others => '0');
        elsif(CLK'event and CLK = '1') then
             if(WS ='1') then
                tempQ <= D;
             elsif(WS = '0') then
                if(k = '1') then
                    tempQ <= D(n-1)& tempQ(n-1 downto 1);
                elsif(k = '0') then
                    tempQ <= tempQ(n-2 downto 0) & '0';
                end if;
             end if;
        end if;    
    end process CLKD;
END struct;
