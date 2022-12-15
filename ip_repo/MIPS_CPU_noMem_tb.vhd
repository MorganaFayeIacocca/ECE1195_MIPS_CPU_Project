----------------------------------------------------------------------------------
-- Created by Morgana Faye Iacocca
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


entity MIPS_CPU is
    PORT( 
          --CLK             : IN     std_logic;
          --RST             : IN     std_logic;
          MemoryDataIn    : IN     std_logic_vector(31 downto 0);
          MemoryAddress   : OUT    std_logic_vector(31 downto 0);
          MemoryDataOut   : OUT    std_logic_vector(31 downto 0);
          MemWrite        : OUT    std_logic
          --testOut       : out    std_logic_vector(31 downto 0)
       );
end MIPS_CPU;

architecture Behavioral of MIPS_CPU is
    component Register_Files IS
       PORT( 
          CLK           : IN     std_logic;
         -- EN            : IN     std_logic;
          RegWrite      : in     std_logic;
          RST           : IN     std_logic;
          Rd_Reg_1      : IN     std_logic_vector(4 downto 0);
          Rd_Reg_2      : IN     std_logic_vector(4 downto 0);
          Write_Reg     : IN     std_logic_vector(4 downto 0);
          Write_Data    : IN     std_logic_vector(31 downto 0);
          Read_Data_1   : OUT    std_logic_vector(31 downto 0);
          Read_Data_2   : OUT    std_logic_vector(31 downto 0)
          --testOut       : out    std_logic_vector(31 downto 0)
       );
    end component;
    
    component ALU IS
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
    end component;
    
    component CPU_memory IS
       PORT( 
          Clk      : IN     std_logic;
          MemWrite : IN     std_logic;
          addr     : IN     std_logic_vector (31 DOWNTO 0);
          dataIn   : IN     std_logic_vector (31 DOWNTO 0);
          dataOut  : OUT    std_logic_vector (31 DOWNTO 0)
       );
    end component;
    
    component SignExtend_16to32 is
        Port ( 
            A : in STD_LOGIC_vector(15 downto 0);
            sel : in std_logic;
            Y : out STD_LOGIC_vector(31 downto 0)
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
    end component;
    
    component Shifter_32to32 is
        Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
               Y : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
    component Shifter_26to28 is
        Port ( A : in STD_LOGIC_VECTOR (25 downto 0);
               Y : out STD_LOGIC_VECTOR (27 downto 0));
    end component;
    
    component mux_4x1 is
        GENERIC (
          WIDTH       : positive := 32
        );
        Port ( 
            D0 : in STD_LOGIC_vector(WIDTH-1 downto 0);
            D1 : in STD_LOGIC_vector(WIDTH-1 downto 0);
            D2 : in STD_LOGIC_vector(WIDTH-1 downto 0);
            D3 : in STD_LOGIC_vector(WIDTH-1 downto 0);
            Sel : in STD_LOGIC_vector(1 downto 0);
            Y : out STD_LOGIC_vector(WIDTH-1 downto 0)
        );
    end component;
    
    component Multiplier_Unit is
        port (
            A     : in  std_logic_vector(31 downto 0);
            B     : in  std_logic_vector(31 downto 0);
            Clk   : in  std_logic;
            RST   : in  std_logic;
            -- 
            R     : out std_logic_vector(63 downto 0);
            Done  : out std_logic
        );
    end component;
    
    component mux_2x1 is
        GENERIC (
          WIDTH       : positive := 32
        );
        Port ( 
            D0 : in STD_LOGIC_vector(WIDTH-1 downto 0);
            D1 : in STD_LOGIC_vector(WIDTH-1 downto 0);
            Sel : in STD_LOGIC;
            Y : out STD_LOGIC_vector(WIDTH-1 downto 0)
        );
    end component;
    
    component ALU_Controller IS
       PORT(
          InstFunction           : IN     std_logic_vector(5 downto 0);
          ALUOp                  : In     std_logic_vector(2 downto 0);
          ALUOpCode              : Out    std_logic_vector(3 downto 0);
          SHAMTsel               : OUT    std_logic_vector(1 downto 0)
       );
    end component;
 
    component Control IS
       PORT( 
          CLK                    : IN     std_logic;
          Reset                  : IN     std_logic;
          OP                     : IN     std_logic_vector(5 downto 0);
          InstFunc               : IN     std_logic_vector(5 downto 0);
          HiLoSel                : out    std_logic;
          writeData3Sel          : out    std_logic;
          multRST                : OUT    std_logic;
          writeHI                : OUT     std_logic;
          writeLO                : OUT     std_logic;
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
    end component;
    
    component CLO is
        Port ( A : in STD_LOGIC_vector(31 downto 0);
               Y : out STD_LOGIC_vector(31 downto 0)
              );
    end component;
   
    
    
    constant Width : positive := 32;
    constant regFileWidth : positive := 5;
    constant highBit : std_logic := '1';
    constant four : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(4, 32));
    constant sixteen : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(16, 5));
    -- On Path
    signal CLK : std_logic;
    signal RST : std_logic;
    
    signal newPC : std_logic_vector(31 downto 0);
    
    signal PCOutput : std_logic_vector(31 downto 0);
    signal ALUOut : std_logic_vector(31 downto 0);
    
    signal MemAddressIn : std_logic_vector(31 downto 0);
    
    signal memDataOut : std_logic_vector(31 downto 0);
    
    signal Instruction : std_logic_vector(31 downto 0);
    signal MemDataRegOut : std_logic_vector(31 downto 0);
    
    signal WriteRegisterIn : std_logic_vector(4 downto 0);
    signal WriteDataIn : std_logic_vector(31 downto 0);
    
    signal writeData3Out : std_logic_vector(31 downto 0);
    signal HiLoMuxOut : std_logic_vector(31 downto 0);
    signal CLOOut : std_logic_vector(31 downto 0);
    
    signal readData1 : std_logic_vector(31 downto 0);
    signal readData2 : std_logic_vector(31 downto 0);
    signal signExtenderOutput : std_logic_vector(31 downto 0);
    signal memSignExtenderOutput : std_logic_vector(31 downto 0);
    
    signal Aout : std_logic_vector(31 downto 0);
    signal Bout : std_logic_vector(31 downto 0);
    signal shift32Output : std_logic_vector(31 downto 0);
    
    signal ALUinA : std_logic_vector(31 downto 0);
    signal ALUinB : std_logic_vector(31 downto 0);
    
    signal ALUOpCode : std_logic_vector(3 downto 0);
    
    signal ALUResult : std_logic_vector(31 downto 0);
    signal ALUzero : std_logic;
    signal ALUoverflow : std_logic;
    signal JumpAddress : std_logic_vector(31 downto 0);
    
    signal Shamt : std_logic_vector(4 downto 0);
    
    signal PCWriteCondANDZero : std_logic;
    signal PCWriteEnable : std_logic;
    
    signal multOut : std_logic_vector(63 downto 0);
    signal LOout : std_logic_vector(31 downto 0);
    signal HIout : std_logic_vector(31 downto 0);    
    -- from Control
    signal PCWrite : std_logic;
    signal PCWriteCond : std_logic;
    signal IorD : std_logic;
    signal MemWrite2 : std_logic;
    signal memDataWrite : std_logic; -- might not need
    signal IRWrite : std_logic;
    signal RegDst : std_logic;
    signal MemToReg : std_logic_vector(1 downto 0);
    signal regWrite : std_logic;
    signal writeA : std_logic; -- might not need
    signal writeB : std_logic; -- might not need
    signal ALUSrcA : std_logic;
    signal ALUSrcB : std_logic_vector(1 downto 0);
    signal extenderSel : std_logic;
    
    signal multRST : std_logic;
    signal writeHI : std_logic;
    signal writeLO : std_logic;
    signal multDone : std_logic;
    signal ShamtSel : std_logic_vector(1 downto 0);
    
    signal HiLoSel : std_logic;
    signal writeData3Sel : std_logic;
    -- might be in control unit, might be in smaller ALU control, yet unsure
    signal ALUOp : std_logic_vector(2 downto 0);
    --
    signal writeALUout : std_logic; -- might not need
    signal PCSource : std_logic_vector(1 downto 0);
    
    -- Temporary Override to Memory
    signal InstructionIn : std_logic_vector(31 downto 0);
    signal nonsense : std_logic_vector(31 downto 0);
    signal nonsense2 : std_logic;
    signal myState : std_logic_vector(4 downto 0);
begin
    PCWriteCondANDZero <= (not ALUzero) AND PCWriteCond;
    PCWriteEnable <= PCWriteCondANDZero OR PCWrite;
    
    PC : Register_Unit
        generic map(
            n => Width
        )
        port map(
          CLK  => CLK,
          D    => newPC,
          EN   => PCWriteEnable,
          RST  => RST,
          Q    => PCOutput
        );
        
    MemAddressMux : mux_2x1
        generic map(
            Width => Width
        )
        port map(
            D0 => PCOutput,
            D1 => ALUOut,
            Sel => IorD,
            Y => MemAddressIn
        );
     
    Memory : CPU_Memory
        port map(
            Clk => CLK,
            MemWrite => MemWrite2,
            addr => MemAddressIn,
            dataIn => Bout,
            dataOut => memDataOut
        );
     
    IR : Register_Unit
        generic map(
            n => Width
        )
        port map(
          CLK  => CLK,
          D    => InstructionIn,
          EN   => IRWrite,
          RST  => RST,
          Q    => Instruction
        );
        
    MemDataRegister : Register_Unit
        generic map(
            n => Width
        )
        port map(
          CLK  => CLK,
          D    => InstructionIn,
          EN   => memDataWrite,
          RST  => RST,
          Q    => MemDataRegOut
        );
     
    WriteRegMux : Mux_2x1
        generic map(
            Width => regFileWidth
        )
        port map(
            D0 => Instruction(20 downto 16),
            D1 => Instruction(15 downto 11),
            Sel => RegDst,
            Y => WriteRegisterIn
        );
     
    HiLoMux :  mux_2x1
        generic map(
            Width => Width
        )
        port map(
            D0 => LOout,
            D1 => HIout,
            Sel => HiLoSel,
            Y => HiLoMuxOut
        );
     
    writeData3Mux : mux_2x1
        generic map(
            Width => Width
        )
        port map(
            D0 => CLOOut,
            D1 => HiLoMuxOut,
            Sel => writeData3Sel,
            Y => writeData3Out
        );
     
    WriteDataMux : mux_4x1
        generic map(
            Width => Width
        )
        port map(
            D0 => ALUOut,
            D1 => MemDataRegOut,
            D2 => memSignExtenderOutput,
            D3 => writeData3Out,
            Sel => MemToReg,
            Y => WriteDataIn
        );
    
    memSignExtender : SignExtend_16to32 -- Extends lower 16 bits of memory data for Load Half Word
        port map(
            A => MemDataRegOut(15 downto 0),
            sel => extenderSel,
            Y => memSignExtenderOutput 
        );
        
    RegisterFile : Register_Files
        port map(
          CLK  =>  CLK,
          RegWrite => RegWrite ,
          RST       => RST,
          Rd_Reg_1   => Instruction(25 downto 21),
          Rd_Reg_2    => Instruction(20 downto 16),
          Write_Reg   => WriteRegisterIn,
          Write_Data   => WriteDataIn,
          Read_Data_1  => ReadData1,
          Read_Data_2  => ReadData2
        );
    
    signExtender : SignExtend_16to32
        port map(
            A => Instruction(15 downto 0),
            sel => extenderSel,
            Y => signExtenderOutput 
        );
        
    A : Register_Unit
        generic map(
            n => Width
        )
        port map(
          CLK  => CLK,
          D    => ReadData1,
          EN   => writeA,
          RST  => RST,
          Q    => Aout
        );
    
    B : Register_Unit
        generic map(
            n => Width
        )
        port map(
          CLK  => CLK,
          D    => ReadData2,
          EN   => writeB,
          RST  => RST,
          Q    => Bout
        );
        
    shiftAfterExtend: Shifter_32to32
        port map(
            A => signExtenderOutput,
            Y => shift32Output
        );
    
    ALUmuxA : mux_2x1
        generic map(
            Width => Width
        )
        port map(
            D0 => PCOutput,
            D1 => Aout,
            Sel => ALUSrcA,
            Y => ALUinA
        );
    
    ALUmuxB : mux_4x1
        generic map(
            Width => Width
        )
        port map(
            D0 => Bout,
            D1 => four,
            D2 => signExtenderOutput,
            D3 => shift32Output,
            Sel => ALUSrcB,
            Y => ALUinB
        );
    
    shiftIR : Shifter_26to28
        port map(
            A => Instruction(25 downto 0),
            Y => JumpAddress(27 downto 0)
            
        );
    
    ALU_Unit : ALU
       GENERIC map (
          n  => Width
       )
       PORT map( 
          A       => ALUinA,
          B      => ALUinB,
          ALUOp   => ALUOpCode,
          SHAMT    => Shamt,
          R       => ALUResult,
          Zero    => ALUzero,
          Overflow  =>  ALUoverflow
       );        
    
    ALU_Out : Register_Unit
        generic map(
            n => Width
        )
        port map(
          CLK  => CLK,
          D    => ALUResult,
          EN   => writeALUout,
          RST  => RST,
          Q    => ALUOut
        );
    
    JumpAddress(31 downto 28) <= PCOutput(31 downto 28);
        
    PCMux : mux_4x1
        generic map(
            Width => Width
        )
        port map(
            D0 => ALUResult,
            D1 => ALUOut,
            D2 => JumpAddress,
            D3 => Aout, -- Put Multiplication Here
            Sel => PCSource,
            Y => newPC
        );
     
     ALUcontrol : ALU_Controller
        port map(
            InstFunction => Instruction(5 downto 0),
            ALUOp => ALUOp,
            ALUOpCode => ALUOpCode,
            SHAMTsel => ShamtSel
        );
    
    Controller : Control
        port map( 
          CLK  => CLK, 
          Reset   => RST,
          OP    => Instruction(31 downto 26),
          InstFunc => Instruction(5 downto 0),
          HiLoSel          => HiLoSel, 
          writeData3Sel    => writeData3Sel,
          multRST => multRST,
          writeHI => writeHI,
          writeLO => writeLO,
          MultDone  => multDone,
          PCWriteCond => PCWriteCond,
          PCWrite => PCWrite,
          IorD    => IorD,
          MemWrite => MemWrite2,
          MemtoReg  => MemtoReg,
          IRWrite  => IRWrite,
          RegDst   => RegDst,
          RegWrite  => RegWrite,
          ALUSrcA    => ALUSrcA,
          ALUSrcB  => ALUSrcB,
          ALUOp   => ALUOp,
          PCSource  => PCSource,
          memDataWrite  => memDataWrite,
          writeA  => writeA,
          writeB => writeB,
          writeALUout   => writeALUout,
          extenderSel   => extenderSel,
          myState  => myState
       );
    
    SHAMTMux : mux_4x1
        generic map(
           Width => regFileWidth
        )
        port map(
            D0 => Instruction(10 downto 6),
            D1 => ALUinA(4 downto 0),
            D2 => sixteen,
            D3 => sixteen,
            Sel => ShamtSel,
            Y => Shamt
        );
        
    cpuCLO : CLO
        port map(
            A => Aout,
            Y => CLOOut
        );
    
    Multiplier : Multiplier_Unit
        port map(
            A     => Aout,
            B     => Bout,
            Clk   => CLK,
            RST   => multRST,
            -- 
            R     => multOut,
            Done  => multDone
        );
    
    LO : Register_Unit
        generic map(
            n => Width
        )
        port map(
          CLK  => CLK,
          D    => multOut(31 downto 0),
          EN   => writeLO,
          RST  => RST,
          Q    => LOout
        );
    HI : Register_Unit
        generic map(
            n => Width
        )
        port map(
          CLK  => CLK,
          D    => multOut(63 downto 32),
          EN   => writeHI,
          RST  => RST,
          Q    => HIout
        );

    process
    begin
        RST <= '1';
        CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	RST <= '0';
    	wait for 20 ns; --- 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	InstructionIn <= "00000000101000100010000000100001"; --ADDU, put in 4
        wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	InstructionIn <= "00000000101000100000100000100010"; -- SUB, put in 1
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	InstructionIn <= "00000000000001010001100011000000"; --SLL r5 by 3, put in r3
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	InstructionIn <= "00000000101000100011100000000100"; -- SLLV r2 by r5 put in r7
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	InstructionIn <= "00000000000000100100000001000011"; --SRA  put in 8
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	InstructionIn <= "00000000101000100011000000100100"; -- AND, put in 6
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	InstructionIn <= "00100000101010010000000000010101"; --ADDI 21 to r5 put in 9,  b 001000 00101 01001 0000000000010101 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	InstructionIn <= "00110100101010101111111111111111"; --ORI xFFFF to r5 put in r10,  b 001101 00101 01010 1111111111111111
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	InstructionIn <= "00101000101010110000000000001111"; --SLTI 15 to r5 put in r11,  b 001010 00101 01011 0000000000001111
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	InstructionIn <= "00000000101000000000000000001000"; --JR to r5,  b 000000 00101 00000 00000 00000 001000
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	InstructionIn <= "00001000000000000000000001000000"; --J by 64,  b 000010 00000 00000 00000 00001 000000
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	InstructionIn <= "00010100010001010000000001111111"; --BNE r2 r5,  b 000101 00010 00101 00000 00001 111111
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	InstructionIn <= "00111100000011001000000000111111"; --LUI r12 b10000 00000 111111,  b 001111 00000 01100 10000 00000 111111
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	InstructionIn <= "10001100001011010000000000111111"; --LW r13 b10000 00000 111111,  b 100011 00001 01101 00000 00000 111111
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	InstructionIn <= "10000100001011100000000000111111"; --LW r14 b10000 00000 111111,  b 100001 00001 01110 00000 00000 111111
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	InstructionIn <= "10101100001001010000000000111111"; --SW r5 b10000 00000 111111,  b 101011 00001 00101 00000 00000 111111
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	InstructionIn <= "01110001101000000111100000100001"; --CLO r13 => 15 b10000 00000 111111,  b 011100 01101 00000 01111 00000 100001
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	InstructionIn <= "00000000101000100000000000011001"; --MULTU r5 r2,  b 000000 00101 00010 00000 00000 011001
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns; 
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	InstructionIn <= "00000000000000001000000000010000"; --MFHI r16,  b 000000 00000 00000 10000 00000 010000  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	InstructionIn <= "00000000000000001000100000010010"; --MFLO r17,  b 000000 00000 00000 10001 00000 010010  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;  
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	CLK <= '1';
    	wait for 20 ns;
    	CLK <= '0';
    	wait for 20 ns;
    	
    	
    end process;

end Behavioral;
