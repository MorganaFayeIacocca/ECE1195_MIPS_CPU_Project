-- Created: by - Morgana Faye Iacocca

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY Control IS
   PORT( 
      CLK                    : IN     std_logic;
      Reset                  : IN     std_logic;
      OP                     : IN     std_logic_vector(5 downto 0);
      InstFunc               : IN     std_logic_vector(5 downto 0);
      
      HiLoSel                : out    std_logic;
      writeData3Sel          : out    std_logic;
      multRST                : OUT    std_logic;
      writeHI                : OUT    std_logic;
      writeLO                : OUT    std_logic;
      MultDone               : IN     std_logic;
      PCWriteCond            : OUT    std_logic;
      PCWrite                : OUT    std_logic;
      IorD                   : OUT    std_logic;
      MemWrite               : OUT    std_logic;
      MemtoReg               : OUT    std_logic_vector(1 downto 0);
      IRWrite                : OUT    std_logic;
      RegDst                 : OUT    std_logic;
      RegWrite               : OUT    std_logic;
      ALUSrcA                : OUT    std_logic;
      ALUSrcB                : OUT    std_logic_vector(1 downto 0);
      ALUOp                  : OUT    std_logic_vector(2 downto 0);
      PCSource               : OUT    std_logic_vector(1 downto 0);
      memDataWrite           : OUT    std_logic;
      writeA                 : OUT    std_logic;
      writeB                 : OUT    std_logic;
      writeALUout            : OUT    std_logic;
      extenderSel            : OUT    std_logic;
      myState                : OUT    std_logic_vector(4 downto 0)
   );

-- Declarations

END Control ;

--
ARCHITECTURE struct OF Control IS

	-- Build an enumerated type for the state machine
	type state_type is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17);
	   -- s0 start
	   -- s1 Instruction Fetch
	   -- s2 Instruction Decode
	   -- s3 R Type Execution
	   -- s4 R-Type Completion
	   -- d5 I-Type Execution
	   -- s6 I-Type Completion
	   -- s7 Special - JR
	   -- s8 J
	   -- s9 BNE
	   -- s10 MemoryAddressComp
	   -- s11 LW Memory Access
	   -- s12 LW Memory Read Completion
	   -- s13 LH Memory Access
	   -- s14 CLO Committ
	   -- s15 Mult Execute
	   -- s16 Move from HI Reg
	   -- s17 Move from LO Reg
	
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
				    state <= s1;
				when s1=>
				    state <= s2;
				when s2=>
				    if OP = "000000" then -- Special Func, look at [5-0]
				        if (InstFunc = "001000") then
				            state <= s7;
				        elsif (InstFunc = "011001") then -- MULTU
				            state <= s15;
				        elsif (InstFunc = "010000") then -- MFHI
				            state <= s16;
				        elsif (InstFunc = "010010") then -- MFLO
				            state <= s17;
				        else
						  state <= s3;
						end if;
			        elsif OP(5 downto 3) = "001" then -- I type
			            state <= s5;
			        elsif OP = "000010" then
			            state <= s8;
			        elsif OP = "000101" then
			            state <= s9;
			        elsif OP = "100011" then
			            state <= s10; -- LW
			        elsif OP = "100001" then
			            state <= s10; -- LH
			        elsif OP = "101011" then
			            state <= s10; -- SW
			        elsif OP = "011100" then
			            state <= s14; -- CLO
					else
						state <= s1;
					end if;
				when s3 =>
					state <= s4;
			   when s4 =>
			        state <= s1;
			   when s5 =>
			        state <= s6;
			   when s6 =>
			        state <= s1;
			   when s7 =>
			        state <= s1;
			   when s8 =>
			        state <= s1;
			   when s9 =>
			        state <= s1;
			   when s10 =>
			        if OP(5 downto 3) = "100" then
			             state <= s11;
			        elsif OP(5 downto 3) = "101" then
			             state <= s13;
			        end if;
			   when s11 =>
			        state <= s12;
			   when s12 =>
			        state <= s1;
			   when s13 =>
			        state <= s1;
			   when s14 =>
			        state <= s1;
			   when s15 =>
			         if MultDone = '1' then
			             state <= s1;
			         else
			             state <= s15;
			         end if;
			   when s16 =>
			        state <= s1;
			   when s17 =>
			        state <= s1;
			end case;
		end if;
	end process;
	
	-- Output depends on the current state AND input (op)
	process (state, OP)
	begin
	
		case state is
		    when s0 => -- Start
		        PCWriteCond <= '0';
		        PCWrite <= '0';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "00";
                IRWrite <= '0';
                RegDst <= '0';
                RegWrite <= '0';
                ALUSrcA <= '0';
                ALUSrcB <= "00";
                ALUOp <= "001"; -- 01 means force add (FOR PC counter)
                extenderSel <= '0';
                PCSource <= "00";
                memDataWrite <= '0';
                writeA <= '0';
                writeB <= '0';
                writeALUout <= '0';
                myState <= "00000";
                multRST <= '1';
                writeHI <= '0';
                writeLO <= '0';
                HiLoSel <= '0';
                writeData3Sel <= '0';
			when s1 => -- Fetch
			    PCWriteCond <= '0';
			    PCWrite <= '1';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "00";
                IRWrite <= '1';
                RegDst <= '0';
                RegWrite <= '0';
                ALUSrcA <= '0';
                ALUSrcB <= "01"; --add 4
                ALUOp <= "001"; -- 01 means force add (FOR PC counter)
                extenderSel <= '0';
                PCSource <= "00";
                memDataWrite <= '0';
                writeA <= '0';
                writeB <= '0';
                writeALUout <= '0';
                myState <= "00001";
                multRST <= '1';
                writeHI <= '0';
                writeLO <= '0';
                HiLoSel <= '0';
                writeData3Sel <= '0';
			when s2 => -- Decode
                PCWriteCond <= '0';
                PCWrite <= '0';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "00";
                IRWrite <= '0';
                RegDst <= '0';
                RegWrite <= '0';
                ALUSrcA <= '0'; -- put PC in ALU A
                ALUSrcB <= "11"; -- put 16 bit offset in ALU B (for when relevant)
                ALUOp <= "001"; -- 01 means force add (FOR PC counter)
                extenderSel <= '1'; --Sign extend the 16 bit offset for ALU
                PCSource <= "00";
                memDataWrite <= '0';
                writeA <= '1';
                writeB <= '1';
                writeALUout <= '1';
                myState <= "00010";
                multRST <= '1';
                writeHI <= '0';
                writeLO <= '0';
                HiLoSel <= '0';
                writeData3Sel <= '0';
			when s3 => -- R Type Execution
			    PCWriteCond <= '0';
			    PCWrite <= '0';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "00";
                IRWrite <= '0';
                RegDst <= '0';
                RegWrite <= '0';
                ALUSrcA <= '1';
                ALUSrcB <= "00";
                ALUOp <= "000"; -- 00 means R-Type/add
                extenderSel <= '0';
                PCSource <= "00";
                memDataWrite <= '0';
                writeA <= '0';
                writeB <= '0';
                writeALUout <= '1';
                myState <= "00011";
                multRST <= '1';
                writeHI <= '0';
                writeLO <= '0';
                HiLoSel <= '0';
                writeData3Sel <= '0';
			when s4 => -- R Type Completion
                PCWriteCond <= '0';
                PCWrite <= '0';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "00";
                IRWrite <= '0';
                RegDst <= '1';
                RegWrite <= '1';
                ALUSrcA <= '1';
                ALUSrcB <= "00";
                ALUOp <= "000"; -- 00 means R-Type/add
                extenderSel <= '0';
                PCSource <= "00";
                memDataWrite <= '0';
                writeA <= '0';
                writeB <= '0';
                writeALUout <= '0';
                myState <= "00100";
                multRST <= '1';
                writeHI <= '0';
                writeLO <= '0';
                HiLoSel <= '0';
                writeData3Sel <= '0';
            when s5 => -- I Type Execution
                PCWriteCond <= '0';
                PCWrite <= '0';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "00";
                IRWrite <= '0';
                RegDst <= '0';
                RegWrite <= '0';
                ALUSrcA <= '1';
                ALUSrcB <= "10";
                if (OP(2 downto 0) = "000") then
                    ALUOp <= "001"; -- Force Add, ignore Instruct/Func
                    extenderSel <= '1';
                elsif (OP(2 downto 0) = "101") then
                    ALUOp <= "010"; -- Force OR, ignore Instruct/Func
                    extenderSel <= '0';
                elsif (OP(2 downto 0) = "010") then
                    ALUOp <= "011"; -- Force Less Than, ignore Instruct/Func
                    extenderSel <= '1';
                elsif (OP(2 downto 0) = "111") then
                    ALUOp <= "100"; -- Force Shift, ignore Instruct/Func
                    extenderSel <= '0';
                end if;
                PCSource <= "00";
                memDataWrite <= '0';
                writeA <= '0';
                writeB <= '0';
                writeALUout <= '1';
                myState <= "00101";
                multRST <= '1';
                writeHI <= '0';
                writeLO <= '0';
                HiLoSel <= '0';
                writeData3Sel <= '0';
            when s6 => --I Type Completion
                PCWriteCond <= '0';
                PCWrite <= '0';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "00";
                IRWrite <= '0';
                RegDst <= '0';
                RegWrite <= '1';
                ALUSrcA <= '1';
                ALUSrcB <= "00";
                ALUOp <= "000"; -- 00 means R-Type/add
                extenderSel <= '0';
                PCSource <= "00";
                memDataWrite <= '0';
                writeA <= '0';
                writeB <= '0';
                writeALUout <= '0';
                myState <= "00110";
                multRST <= '1';
                writeHI <= '0';
                writeLO <= '0';
                HiLoSel <= '0';
                writeData3Sel <= '0';
            when s7 => -- JR
                PCWriteCond <= '0';
                PCWrite <= '1';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "00";
                IRWrite <= '0';
                RegDst <= '0';
                RegWrite <= '0';
                ALUSrcA <= '1';
                ALUSrcB <= "00";
                ALUOp <= "001"; -- 01 Force ADD
                extenderSel <= '0';
                PCSource <= "00";
                memDataWrite <= '0';
                writeA <= '0';
                writeB <= '0';
                writeALUout <= '0';
                myState <= "00111";
                multRST <= '1';
                writeHI <= '0';
                writeLO <= '0';
                HiLoSel <= '0';
                writeData3Sel <= '0';
            when s8 => -- J
                PCWriteCond <= '0';
                PCWrite <= '1';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "00";
                IRWrite <= '0';
                RegDst <= '0';
                RegWrite <= '0';
                ALUSrcA <= '1';
                ALUSrcB <= "00";
                ALUOp <= "001"; -- 01 Force ADD (for safety)
                extenderSel <= '0';
                PCSource <= "10";
                memDataWrite <= '0';
                writeA <= '0';
                writeB <= '0';
                writeALUout <= '0';
                myState <= "01000";
                multRST <= '1';
                writeHI <= '0';
                writeLO <= '0';
                HiLoSel <= '0';
                writeData3Sel <= '0';
            when s9 => --BNE
                PCWriteCond <= '1';
                PCWrite <= '0';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "00";
                IRWrite <= '0';
                RegDst <= '0';
                RegWrite <= '0';
                ALUSrcA <= '1';
                ALUSrcB <= "00";
                ALUOp <= "011"; -- Force SLT to "perform subtraction" to get zero bit
                extenderSel <= '0'; 
                PCSource <= "01"; -- take from ALU OUT, saved in Decode
                memDataWrite <= '0';
                writeA <= '0';
                writeB <= '0';
                writeALUout <= '0';
                myState <= "01001";
                multRST <= '1';
                writeHI <= '0';
                writeLO <= '0';
                HiLoSel <= '0';
                writeData3Sel <= '0';
            when s10 => -- Mem Address Calc
                PCWriteCond <= '0';
		        PCWrite <= '0';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "00";
                IRWrite <= '0';
                RegDst <= '0';
                RegWrite <= '0';
                ALUSrcA <= '1';
                ALUSrcB <= "10";
                ALUOp <= "001"; -- 01 means force add (FOR PC counter)
                extenderSel <= '1'; --want signed offset
                PCSource <= "00";
                memDataWrite <= '0';
                writeA <= '0';
                writeB <= '0';
                writeALUout <= '1';
                myState <= "01010";
                multRST <= '1';
                writeHI <= '0';
                writeLO <= '0';
                HiLoSel <= '0';
                writeData3Sel <= '0';
            when s11 => -- LW/LH Type Mem Access
                PCWriteCond <= '0';
		        PCWrite <= '0';
                IorD <= '1';
                MemWrite <= '0';
                MemtoReg <= "01";
                IRWrite <= '0';
                RegDst <= '0';
                RegWrite <= '0';
                ALUSrcA <= '1';
                ALUSrcB <= "10";
                ALUOp <= "001"; -- 01 means force add (FOR PC counter)
                extenderSel <= '1'; --want signed
                PCSource <= "00";
                memDataWrite <= '1';
                writeA <= '0';
                writeB <= '0';
                writeALUout <= '0';
                myState <= "01011";
                multRST <= '1';
                writeHI <= '0';
                writeLO <= '0';
                HiLoSel <= '0';
                writeData3Sel <= '0';
            when s12 => -- LW Type Mem read completion
                PCWriteCond <= '0';
		        PCWrite <= '0';
                IorD <= '0';
                MemWrite <= '0';
                if (OP(2 downto 0) = "011") then
                    MemtoReg <= "01"; -- Select MemData
                elsif OP(2 downto 0) = "001" then
                    MemtoReg <= "10"; -- Select sign extended lower half word
                end if;
                IRWrite <= '0';
                RegDst <= '0';
                RegWrite <= '1'; -- Write to register files!
                ALUSrcA <= '1';
                ALUSrcB <= "10";
                ALUOp <= "001"; -- 01 means force add (FOR PC counter)
                extenderSel <= '1'; --want signed
                PCSource <= "00";
                memDataWrite <= '0';
                writeA <= '0';
                writeB <= '0';
                writeALUout <= '0';
                myState <= "01100";
                multRST <= '1';
                writeHI <= '0';
                writeLO <= '0';
                HiLoSel <= '0';
                writeData3Sel <= '0';
            when s13 => -- SW Type Mem access
                PCWriteCond <= '0';
		        PCWrite <= '0';
                IorD <= '1';
                MemWrite <= '1';
                MemtoReg <= "01"; -- Select MemData
                IRWrite <= '0';
                RegDst <= '0';
                RegWrite <= '0'; -- Write to register files!
                ALUSrcA <= '1';
                ALUSrcB <= "10";
                ALUOp <= "001"; -- 01 means force add (FOR PC counter)
                extenderSel <= '1'; --want signed
                PCSource <= "00";
                memDataWrite <= '0';
                writeA <= '0';
                writeB <= '0';
                writeALUout <= '0';
                myState <= "01101";
                multRST <= '1';
                writeHI <= '0';
                writeLO <= '0';
                HiLoSel <= '0';
                writeData3Sel <= '0';
            when s14 => -- CLO Committ
                PCWriteCond <= '0';
                PCWrite <= '0';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "11";
                IRWrite <= '0';
                RegDst <= '1';
                RegWrite <= '1';
                ALUSrcA <= '1';
                ALUSrcB <= "00";
                ALUOp <= "001"; -- 01 means add
                extenderSel <= '0';
                PCSource <= "00";
                memDataWrite <= '0';
                writeA <= '0';
                writeB <= '0';
                writeALUout <= '0';
                myState <= "01110";
                multRST <= '1';
                writeLO <= '0';
                writeLO <= '0';
                HiLoSel <= '0'; -- V important to be 0 so CLO is put into data write
                writeData3Sel <= '0';
            when s15 => -- Run Mult / Committ
                PCWriteCond <= '0';
                PCWrite <= '0';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "11";
                IRWrite <= '0';
                RegDst <= '0';
                RegWrite <= '0';
                ALUSrcA <= '1';
                ALUSrcB <= "00";
                ALUOp <= "001"; -- 01 means add
                extenderSel <= '0';
                PCSource <= "00";
                memDataWrite <= '0';
                writeA <= '0';
                writeB <= '0';
                writeALUout <= '0';
                myState <= "01111";
                multRST <= '0';
                writeHI <= '1';
                writeLO <= '1';
                HiLoSel <= '0';
                writeData3Sel <= '0';
            when s16 => -- MFHI
                PCWriteCond <= '0';
                PCWrite <= '0';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "11";
                IRWrite <= '0';
                RegDst <= '1';
                RegWrite <= '1';
                ALUSrcA <= '1';
                ALUSrcB <= "00";
                ALUOp <= "001"; -- 01 means add
                extenderSel <= '0';
                PCSource <= "00";
                memDataWrite <= '0';
                writeA <= '0';
                writeB <= '0';
                writeALUout <= '0';
                myState <= "10000";
                multRST <= '1';
                writeHI <= '0';
                writeLO <= '0';
                HiLoSel <= '1';
                writeData3Sel <= '1';
            when s17 => -- MFHI
                PCWriteCond <= '0';
                PCWrite <= '0';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "11";
                IRWrite <= '0';
                RegDst <= '1';
                RegWrite <= '1';
                ALUSrcA <= '1';
                ALUSrcB <= "00";
                ALUOp <= "001"; -- 01 means add
                extenderSel <= '0';
                PCSource <= "00";
                memDataWrite <= '0';
                writeA <= '0';
                writeB <= '0';
                writeALUout <= '0';
                myState <= "10001";
                multRST <= '1';
                writeHI <= '0';
                writeLO <= '0';
                HiLoSel <= '0';
                writeData3Sel <= '1';
		end case;
	end process;
    
END struct;
