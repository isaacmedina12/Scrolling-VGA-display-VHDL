library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity patterngen is
	port(
		CLK : in std_logic;
		RESET : in std_logic;
		Row : in std_logic_vector(9 downto 0);
		Col : in std_logic_vector(9 downto 0);
		display_on : in std_logic;
		rgb_patterngen : out std_logic_vector(5 downto 0)
	);
end patterngen;

architecture synth of patterngen is

	signal LFSR_OUT : std_logic_vector(15 downto 0);
	signal star_enable : std_logic;
	signal star_on : std_logic;
	
	component lfsr is
		port(
			clk : in std_logic;
			reset : in std_logic;
			enable : in std_logic;
			lfsr_out : out std_logic_vector(15 downto 0)
		);
	end component;
begin

	
	
	lfsr_inst : lfsr
		port map(
			clk => CLK,
			reset => RESET,
			enable => star_enable,
			lfsr_out => LFSR_OUT
		);
	
	--Enable LFSR only in a 256x265 bit area
	star_enable <= '1' when row(9) = '0' and col(9) = '0';
	
	-- Determine if the star should be "on" (all 7 high bits are set)
	star_on <= '1' when (lfsr_out(17 downto 1) = "1111111") else '0';
	
	-- Set RGB output based on display_on and star_on signals
	process(row, col, display_on, star_on, lfsr_out)
	begin
		if display_on = '1' and star_on = '1' then
			-- Example pattern: left half of the screen is white, right half black
			rgb_patterngen <= lfsr_out(5 downto 0); -- use lower 6 bits for rgb color
		else
			-- Set rgb to off during the blanking intervals defined in the vga module
			rgb_patterngen <= "000000";
		end if;
	end process;
end synth;