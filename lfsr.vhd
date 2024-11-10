library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lfsr is
	port(
		clk : in std_logic;
		reset : in std_logic;
		enable : in std_logic;
		lfsr_out : out std_logic_vector(17 downto 0)
	);
end lfsr;

architecture synth of lfsr is

	signal lfsr_int : std_logic_vector(17 downto 0) := "000000000000000001";
	
	begin
		process(clk, reset)
		begin
			if reset = '1' then 
			-- Reset LFSR to a non-zero initial value
			lfsr_int <= "000000000000000001";
		elsif rising_edge(clk) then
			if enable = '1' then
				--shift and feedback
				--feedback taps: bits 17, 14, 13
				lfsr_int <= lfsr_int(16 downto 0) & (lfsr_int(17) xor lfsr_int(14) xor lfsr_int(13));
			end if;
		end if;
	end process;
	
	--output the LFSR value
	lfsr_out <= lfsr_int;
end synth;