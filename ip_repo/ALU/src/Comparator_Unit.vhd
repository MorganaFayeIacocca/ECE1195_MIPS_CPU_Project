-- Created: by - Morgana Faye Iacocca

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY Comparator_Unit IS
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

END Comparator_Unit ;

--
ARCHITECTURE struct OF Comparator_Unit IS

BEGIN
    R(n-1 downto 1) <= (others => '0');
    R(0) <= ALUOp(1) AND ( (ALUOp(0) and (not CO)) or ( (not ALUOp(0)) and ( ((not B_31) and S_31) or ((not B_31) and A_31) or (S_31 and A_31) )) );
    
END struct;
