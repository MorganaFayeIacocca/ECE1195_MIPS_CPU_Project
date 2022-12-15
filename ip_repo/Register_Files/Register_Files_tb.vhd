


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity Register_Files_tb is
end Register_Files_tb;

architecture Behavioral of Register_Files_tb is
    component Register_Files IS
       PORT( 
          CLK           : IN     std_logic;
          --EN            : IN     std_logic;
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
    
    signal Clk: std_logic;
    --signal En: std_logic;
    signal RegWrite : std_logic;
    signal RST : std_logic;
    
    signal Rd_Reg_1 : std_logic_vector(4 downto 0);
    signal Rd_Reg_2 : std_logic_vector(4 downto 0);
    signal Write_Reg : std_logic_vector(4 downto 0);
    signal Write_Data : std_logic_vector(31 downto 0);
    
    signal Read_Data_1 : std_logic_vector(31 downto 0);
    signal Read_Data_2 : std_logic_vector(31 downto 0);
    --signal testOut : std_logic_vector(31 downto 0);
    
    
begin

    reg_files : Register_Files
        port map(
            CLK => Clk,
            --EN => En,
            RegWrite => RegWrite,
            RST => RST,
            Rd_Reg_1 => Rd_Reg_1,
            Rd_Reg_2 => Rd_Reg_2,
            Write_Reg => Write_Reg,
            Write_Data => Write_Data,
            Read_Data_1 => Read_Data_1,
            Read_Data_2 => Read_Data_2
            --testOut => testOut
        );
   
   process
   begin
      Clk <= '0';
      --En <= '1';
      RST <= '1';
      RegWrite <= '0';
      Rd_Reg_1 <= "00000";
      Rd_Reg_2 <= "00000";
      Write_Reg <= "00000";
      Write_Data <= std_logic_vector(to_unsigned(0, 32));
      wait for 20 ns;
      CLK <= '1';
      wait for 20 ns;
      Clk <= '0';
      RST <= '0';
      wait for 20 ns;
      CLK <= '1';
      wait for 20 ns;
      Clk <= '0';
      Write_Reg <= "00100";
      Write_Data <= std_logic_vector(to_unsigned(5, 32));
      RegWrite <= '1';
      wait for 20 ns;
      CLK <= '1';
      wait for 20 ns;
      Clk <= '0';
      RegWrite <= '0';
      Rd_Reg_1 <= "00100";
      wait for 20 ns;
      CLK <= '1';
      wait for 20 ns;
      Clk <= '0';
      Write_Reg <= "10100";
      Write_Data <= std_logic_vector(to_unsigned(15, 32));
      RegWrite <= '1';
      wait for 20 ns;
      CLK <= '1';
      wait for 20 ns;
      Clk <= '0';
      RegWrite <= '0';
      Rd_Reg_2 <= "10100";
      CLK <= '1';
      wait for 20 ns;
      Clk <= '0';
      wait for 20 ns;
      CLK <= '1';
      wait for 20 ns;
      Clk <= '0';
      wait for 20 ns;
   end process;



end Behavioral;
