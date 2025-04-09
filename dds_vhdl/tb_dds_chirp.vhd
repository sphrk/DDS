LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;

library std;
use std.textio.all;
 
ENTITY tb_dds_sine IS
END tb_dds_sine;
 
ARCHITECTURE behavior OF tb_dds_sine IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT dds
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         phase_inc : IN  std_logic_vector(31 downto 0);
         y : OUT  std_logic_vector(11 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal phase_inc : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal y : std_logic_vector(11 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: dds PORT MAP (
          rst => rst,
          clk => clk,
          phase_inc => phase_inc,
          y => y
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
	-- writing DDS output to file
	process
		file out_file : text open write_mode is "dds_out.txt";
		variable line_v : line;
	begin
		wait until rising_edge(clk);
		-- write(line_v, to_bitvector(y));
		write(line_v, to_integer(signed(y)));
		writeline(out_file, line_v);
	end process;

   -- Stimulus process
   stim_proc: process
   begin
		rst <= '1';
		wait until rising_edge(clk);
		rst <= '0';
		
		-- Chirp Pulse
		-- P=32
		while true loop
			phase_inc <= "00000010100011110101110000101000";
			for i in 1 to 10000 loop
				wait for clk_period;
				phase_inc <= std_logic_vector(unsigned(phase_inc) + "00000000000000000001000011000110");
			end loop;
		end loop;

		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
