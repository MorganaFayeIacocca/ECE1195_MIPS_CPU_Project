-- Created: by - Morgana Faye Iacocca

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY ALU_Controller IS
   PORT( 
      --CLK                    : IN     std_logic;
      --Reset                  : IN     std_logic;
      --Start                  : IN     std_logic;
      InstFunction           : IN     std_logic_vector(5 downto 0);
      ALUOp                  : In     std_logic_vector(2 downto 0);
      
      ALUOpCode              : Out    std_logic_vector(3 downto 0);
      --Done                   : Out    std_logic;
      SHAMTsel               : OUT    std_logic_vector(1 downto 0)
   );

-- Declarations

END ALU_Controller ;
-- GET RID OF FSM HERE IF POSSIBLE
--
ARCHITECTURE struct OF ALU_Controller IS
begin
   SHAMTsel(0) <= InstFunction(2);
   SHAMTsel(1) <= ALuOp(2);
   ALUOpCode(3) <= ALUOp(2) OR ((not ALUOp(2)) and ((ALUOp(1) and ALUOp(0)) OR ((not ALUOp(1)) AND (not ALUOp(0)) AND (not InstFunction(5)))));
   ALUOpCode(2) <= ALUOp(2) OR ((not ALUOp(2)) and (((not ALUOp(1)) and ALUOp(0)) OR ((not ALUOp(1)) and ((not InstFunction(5)) or (not InstFunction(2))))));
   ALUOpCode(1) <= (not ALUOp(2)) and ((ALUOp(1) and ALUOp(0)) OR ((not ALUOp(1)) and (not ALUOp(0)) and InstFunction(1)));
   ALUOpCode(0) <= (not ALUOp(2)) and (((not ALUOp(1)) and ALUOp(0)) OR (ALUOp(1) and (not ALUOp(0))) OR ((not ALUOp(1)) and ((not InstFunction(5)) and InstFunction(0))) OR ((not ALUOp(1)) and ((not InstFunction(1)) and InstFunction(0))));

    
END struct;
