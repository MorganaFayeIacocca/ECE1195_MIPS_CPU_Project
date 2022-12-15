-- Created: by - Morgana Faye Iacocca

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY Controller_Unit IS
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
   );

-- Declarations

END Controller_Unit ;

--
ARCHITECTURE struct OF Controller_Unit IS

	-- Build an enumerated type for the state machine
	type state_type is (s0, s1, s2);
	   -- s0 start
	   -- s1 Save sum Shift multiplicant and multiplier 
	   -- s2 Shift multiplicant and multiplier 
	
	-- Register to hold the current state
	signal state   : state_type;
	
begin
    process (clk, reset)
	begin
		if reset = '1' then
			state <= s0;
		elsif (rising_edge(clk)) then
			case state is
				when s0=>
				    if(START = '1') then
					   state <= s1;
					else
					   state <= s0;
					end if;
				when s1=>
					if Count = std_logic_vector(to_unsigned(31, 5)) then
						state <= s2;
					else
						state <= s1;
					end if;
				when s2=>
					state <= s2;
			end case;
		end if;
	end process;
	
	-- Output depends solely on the current state
	process (state, Multiplier0)
	begin
	
		case state is
			when s0 =>
				Multiplier_WS  <= '1';
                --Multiplier_EN <= '1';
                Multiplicand_WS <= '1';
                --Multiplicand_EN <= '1';
                Register_RST <= '1';
                Register_EN  <= '0';
                Done  <= '0';
                Counter_RST <= '1';
			when s1 =>
				Multiplier_WS  <= '0';
                --Multiplier_EN <= '1';
                Multiplicand_WS <= '0';
                --Multiplicand_EN <= '1';
                Register_RST <= '0';
                if Multiplier0 = '1' then
                    Register_EN  <= '1';
                else
                    Register_EN <= '0';
                end if;
                Done  <= '0';
                Counter_RST <= '0';
			when s2 =>
				Multiplier_WS  <= '0';
                --Multiplier_EN <= '0';
                Multiplicand_WS <= '0';
                --Multiplicand_EN <= '0';
                Register_RST <= '0';
                Register_EN  <= '0';
                Done  <= '1';
                Counter_RST <= '0';
		end case;
	end process;
    
END struct;
