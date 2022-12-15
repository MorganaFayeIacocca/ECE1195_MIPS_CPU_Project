-- Created: by - Morgana Faye Iacocca

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY Register_Files IS
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

-- Declarations

END Register_Files ;

--
ARCHITECTURE struct OF Register_Files IS

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

    component decoder_5to32 is
        Port ( A : in STD_LOGIC_VECTOR (4 downto 0);
               Y : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
    constant Width : positive := 32;
    signal enableLines: std_logic_vector(31 downto 0);
    
    signal enableLinesWithWriteEn : std_logic_vector(31 downto 0);
    
    type t_muxInputs is array(0 to 31) of std_logic_vector(31 downto 0);
    signal muxInputs : t_muxInputs;
    
    
    signal muxR1_3_0_out, muxR1_3_1_out, muxR1_3_2_out, muxR1_3_3_out : std_logic_vector(31 downto 0);
    signal muxR1_3_4_out, muxR1_3_5_out, muxR1_3_6_out, muxR1_3_7_out : std_logic_vector(31 downto 0);
    signal muxR1_2_0_out, muxR1_2_1_out : std_logic_vector(31 downto 0);
    
    signal muxR2_3_0_out, muxR2_3_1_out, muxR2_3_2_out, muxR2_3_3_out : std_logic_vector(31 downto 0);
    signal muxR2_3_4_out, muxR2_3_5_out, muxR2_3_6_out, muxR2_3_7_out : std_logic_vector(31 downto 0);
    signal muxR2_2_0_out, muxR2_2_1_out : std_logic_vector(31 downto 0);
    
    
begin
   Dec: decoder_5to32
        port map(
            A => Write_Reg,
            Y => enableLines
        );

   Gen1: for i in 0 to 31 generate
        enableLinesWithWriteEn(i) <= enableLines(i) and RegWrite;
        regs: Register_Unit 
            generic map(
                n => Width
             ) 
            port map(
                CLK => CLK, 
                D => Write_Data, 
                EN => enableLinesWithWriteEn(i), 
                RST => RST, 
                Q => muxInputs(i)
            );
   end generate;
   
  ---------------------------- 
  
   mux_R1_3_0: mux_4x1
    generic map(
          WIDTH => Width
        )
    port map( 
        D0 => muxInputs(0),
        D1 => muxInputs(1),
        D2 => muxInputs(2), 
        D3 => muxInputs(3),
        Sel =>  Rd_Reg_1(1 downto 0),
        Y => muxR1_3_0_out
    );
   
   mux_R1_3_1: mux_4x1
    generic map(
          WIDTH => Width
        )
    port map( 
        D0 => muxInputs(4),
        D1 => muxInputs(5),
        D2 => muxInputs(6), 
        D3 => muxInputs(7),
        Sel =>  Rd_Reg_1(1 downto 0),
        Y => muxR1_3_1_out
    );
   mux_R1_3_2: mux_4x1
    generic map(
          WIDTH => Width
        )
    port map( 
        D0 => muxInputs(8),
        D1 => muxInputs(9),
        D2 => muxInputs(10), 
        D3 => muxInputs(11),
        Sel =>  Rd_Reg_1(1 downto 0),
        Y => muxR1_3_2_out
    );
    
    mux_R1_3_3: mux_4x1
    generic map(
          WIDTH => Width
        )
    port map( 
        D0 => muxInputs(12),
        D1 => muxInputs(13),
        D2 => muxInputs(14), 
        D3 => muxInputs(15),
        Sel =>  Rd_Reg_1(1 downto 0),
        Y => muxR1_3_3_out
    );
    
    mux_R1_3_4: mux_4x1
    generic map(
          WIDTH => Width
        )
    port map( 
        D0 => muxInputs(16),
        D1 => muxInputs(17),
        D2 => muxInputs(18), 
        D3 => muxInputs(19),
        Sel =>  Rd_Reg_1(1 downto 0),
        Y => muxR1_3_4_out
    );
    
    mux_R1_3_5: mux_4x1
    generic map(
          WIDTH => Width
        )
    port map( 
        D0 => muxInputs(20),
        D1 => muxInputs(21),
        D2 => muxInputs(22), 
        D3 => muxInputs(23),
        Sel =>  Rd_Reg_1(1 downto 0),
        Y => muxR1_3_5_out
    );
    
    mux_R1_3_6: mux_4x1
    generic map(
          WIDTH => Width
        )
    port map( 
        D0 => muxInputs(24),
        D1 => muxInputs(25),
        D2 => muxInputs(26), 
        D3 => muxInputs(27),
        Sel =>  Rd_Reg_1(1 downto 0),
        Y => muxR1_3_6_out
    );
    
    mux_R1_3_7: mux_4x1
    generic map(
          WIDTH => Width
        )
    port map( 
        D0 => muxInputs(28),
        D1 => muxInputs(29),
        D2 => muxInputs(30), 
        D3 => muxInputs(31),
        Sel =>  Rd_Reg_1(1 downto 0),
        Y => muxR1_3_7_out
    );
    
    mux_R1_2_0: mux_4x1
    generic map(
          WIDTH => Width
        )
    port map( 
        D0 => muxR1_3_0_out,
        D1 => muxR1_3_1_out,
        D2 => muxR1_3_2_out, 
        D3 => muxR1_3_3_out,
        Sel =>  Rd_Reg_1(3 downto 2),
        Y => muxR1_2_0_out
    );
    
    mux_R1_2_1: mux_4x1
    generic map(
          WIDTH => Width
        )
    port map( 
        D0 => muxR1_3_4_out,
        D1 => muxR1_3_5_out,
        D2 => muxR1_3_6_out, 
        D3 => muxR1_3_7_out,
        Sel =>  Rd_Reg_1(3 downto 2),
        Y => muxR1_2_1_out
    );
    
    mux_R1_1_0: mux_2x1
    generic map(
          WIDTH => Width
        )
    port map( 
        D0 => muxR1_2_0_out,
        D1 => muxR1_2_1_out,
        Sel =>  Rd_Reg_1(4),
        Y => Read_Data_1
    );
    -----------------------------------
    
    ---------------------------- 
  
   mux_R2_3_0: mux_4x1
    generic map(
          WIDTH => Width
        )
    port map( 
        D0 => muxInputs(0),
        D1 => muxInputs(1),
        D2 => muxInputs(2), 
        D3 => muxInputs(3),
        Sel =>  Rd_Reg_2(1 downto 0),
        Y => muxR2_3_0_out
    );
   
   mux_R2_3_1: mux_4x1
    generic map(
          WIDTH => Width
        )
    port map( 
        D0 => muxInputs(4),
        D1 => muxInputs(5),
        D2 => muxInputs(6), 
        D3 => muxInputs(7),
        Sel =>  Rd_Reg_2(1 downto 0),
        Y => muxR2_3_1_out
    );
   mux_R2_3_2: mux_4x1
    generic map(
          WIDTH => Width
        )
    port map( 
        D0 => muxInputs(8),
        D1 => muxInputs(9),
        D2 => muxInputs(10), 
        D3 => muxInputs(11),
        Sel =>  Rd_Reg_2(1 downto 0),
        Y => muxR2_3_2_out
    );
    
    mux_R2_3_3: mux_4x1
    generic map(
          WIDTH => Width
        )
    port map( 
        D0 => muxInputs(12),
        D1 => muxInputs(13),
        D2 => muxInputs(14), 
        D3 => muxInputs(15),
        Sel =>  Rd_Reg_2(1 downto 0),
        Y => muxR2_3_3_out
    );
    
    mux_R2_3_4: mux_4x1
    generic map(
          WIDTH => Width
        )
    port map( 
        D0 => muxInputs(16),
        D1 => muxInputs(17),
        D2 => muxInputs(18), 
        D3 => muxInputs(19),
        Sel =>  Rd_Reg_2(1 downto 0),
        Y => muxR2_3_4_out
    );
    
    mux_R2_3_5: mux_4x1
    generic map(
          WIDTH => Width
        )
    port map( 
        D0 => muxInputs(20),
        D1 => muxInputs(21),
        D2 => muxInputs(22), 
        D3 => muxInputs(23),
        Sel =>  Rd_Reg_2(1 downto 0),
        Y => muxR2_3_5_out
    );
    
    mux_R2_3_6: mux_4x1
    generic map(
          WIDTH => Width
        )
    port map( 
        D0 => muxInputs(24),
        D1 => muxInputs(25),
        D2 => muxInputs(26), 
        D3 => muxInputs(27),
        Sel =>  Rd_Reg_2(1 downto 0),
        Y => muxR2_3_6_out
    );
    
    mux_R2_3_7: mux_4x1
    generic map(
          WIDTH => Width
        )
    port map( 
        D0 => muxInputs(28),
        D1 => muxInputs(29),
        D2 => muxInputs(30), 
        D3 => muxInputs(31),
        Sel =>  Rd_Reg_2(1 downto 0),
        Y => muxR2_3_7_out
    );
    
    mux_R2_2_0: mux_4x1
    generic map(
          WIDTH => Width
        )
    port map( 
        D0 => muxR2_3_0_out,
        D1 => muxR2_3_1_out,
        D2 => muxR2_3_2_out, 
        D3 => muxR2_3_3_out,
        Sel =>  Rd_Reg_2(3 downto 2),
        Y => muxR2_2_0_out
    );
    
    mux_R2_2_1: mux_4x1
    generic map(
          WIDTH => Width
        )
    port map( 
        D0 => muxR2_3_4_out,
        D1 => muxR2_3_5_out,
        D2 => muxR2_3_6_out, 
        D3 => muxR2_3_7_out,
        Sel =>  Rd_Reg_2(3 downto 2),
        Y => muxR2_2_1_out
    );
    
    mux_R2_1_0: mux_2x1
    generic map(
          WIDTH => Width
        )
    port map( 
        D0 => muxR2_2_0_out,
        D1 => muxR2_2_1_out,
        Sel =>  Rd_Reg_2(4),
        Y => Read_Data_2
    );
    -----------------------------------
    --testOut <= muxR1_2_0_out;
END struct;
