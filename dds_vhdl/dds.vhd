library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

library std;
use std.textio.all;

entity dds is
	generic(
		P : integer := 32; 	-- phase acc & inc
		M : integer := 8;	-- table address
		L : integer := 12	-- table word length
	);
    Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           phase_inc : in  STD_LOGIC_VECTOR (P-1 downto 0);
           y : out  STD_LOGIC_VECTOR (L-1 downto 0));
end dds;

architecture Behavioral of dds is
	signal phase_acc : unsigned(P-1 downto 0);
	signal phase_inc_r : unsigned(P-1 downto 0);
	signal index : unsigned(M-1 downto 0);
	
	type table_t is array(0 to 2**M-1) of std_logic_vector(L-1 downto 0);
	
	-- reading data from file
	impure function read_table(file_name : string) return table_t is
		variable table : table_t;
		
		file txt_file : text open read_mode is file_name;
		variable line_v : line;
		variable bv_v : bit_vector(L-1 downto 0);
	begin
		for i in 0 to 2**M-1 loop
			readline(txt_file, line_v);
			read(line_v, bv_v);
			
			table(i) := to_stdlogicvector(bv_v);
		end loop;
		return table;
	end function;
	
	constant TABLE : table_t := read_table("sine_table.txt");
begin
	-- TEST : Reading TABLE Values (test read_table function)
--	process
--	begin
--		for i in 0 to 2**M-1 loop
--			y <= TABLE(i);
--			wait for 35 ns;
--		end loop;
--	end process;
	
	-- resgister phase_inc input
	process(rst, clk)
	begin
		if rst = '1' then
			phase_inc_r <= (others => '0');
		elsif rising_edge(clk) then
			phase_inc_r <= unsigned(phase_inc);
		end if;
	end process;
	
	-- Update Phase_Acc register
	process(rst, clk)
	begin
		if rst = '1' then
			phase_acc <= (others => '0');
		elsif rising_edge(clk) then
			phase_acc <= phase_acc + phase_inc_r;
		end if;
	end process;
	
	-- Select most significant M bits of Phase_Acc
	index <= phase_acc(P-1 downto P-M);
	-- phase_acc(phase_acc'HIGH downto phase_acc'HIGH - M + 1)
	
	-- Set Output
	y <= TABLE(to_integer(index));
	
end Behavioral;







