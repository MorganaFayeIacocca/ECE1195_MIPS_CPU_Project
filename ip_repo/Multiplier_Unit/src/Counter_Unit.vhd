library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity Counter_Unit is
    GENERIC (
      n       : positive := 5);
    PORT( 
      CLK : IN     std_logic;
      RST : IN     std_logic;
      Q   : OUT    std_logic_vector(n-1 downto 0)
   );

end entity;

architecture rtl of Counter_Unit is

    signal tempQ : std_logic_vector(n-1 downto 0);
begin

    CLKD : process(CLK, RST)
     begin
        if(RST = '1') then
           tempQ <= (others => '0');
        elsif(CLK'event AND CLK = '1') then
           tempQ <= tempQ + "00001";
        end if;
     end process CLKD;
     Q <= tempQ;
end architecture;
