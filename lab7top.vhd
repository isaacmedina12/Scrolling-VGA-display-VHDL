library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is
	port(
		clk_12M : in std_logic;
		pixel_clk_25125M : out std_logic;
		HSYNC : out std_logic;
		VSYNC : out std_logic;
		DISPLAY_ENABLE : out std_logic;
		ROW : out std_logic_vector(9 downto 0);
		COLUMN : out std_logic_vector(9 downto 0)
	);
end top;

architecture synth of top is

	signal pixel_clk : std_logic;
	signal pll_clk : std_logic;
	component mypll is
		port(
			ref_clk_i: in std_logic;
			rst_n_i: in std_logic;
			outcore_o: out std_logic;
			outglobal_o: out std_logic
		);
	end component;
	
	component vga is
		port(
		pixel_clk : in std_logic; --25 MHz pixel clock input
		hsync : out std_logic; --Horizontal sync signal
		vsync: out std_logic; -- vertical sync signal
		display_enable : out std_logic; -- display valid signal
		row : out std_logic_vector(9 downto 0); -- current row (vertical position)
		column : out std_logic_vector(9 downto 0) -- current column (horizontal position)
		);
	end component vga;
begin
	
	--pll instatiation
	mypll_inst : mypll 
		port map(
			ref_clk_i => clk_12M,
			rst_n_i => '1',
			outcore_o => pixel_clk_25125M,
			outglobal_o => pixel_clk
		);
	pll_clk <= pixel_clk;
	
	-- vga instatiation
	vga_inst : vga 
		port map(
			pixel_clk => pll_clk,
			hsync => HSYNC,
			vsync => VSYNC,
			display_enable => DISPLAY_ENABLE,
			row => ROW,
			column => COLUMN
		);
end synth;