
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_controller is
    Port (
        pixel_clk : in std_logic;             -- 25.175 MHz clock input
        hsync     : out std_logic;            -- Horizontal sync signal
        vsync     : out std_logic;            -- Vertical sync signal
        display_on : out std_logic;           -- Display enable signal
        row       : out std_logic_vector(9 downto 0); -- Current row (vertical position)
        col       : out std_logic_vector(9 downto 0)  -- Current column (horizontal position)
    );
end vga_controller;

architecture Behavioral of vga_controller is

    -- VGA Timing Parameters
    constant H_VISIBLE_AREA   : integer := 640;
    constant H_FRONT_PORCH    : integer := 16;
    constant H_SYNC_PULSE     : integer := 96;
    constant H_BACK_PORCH     : integer := 48;
    constant H_WHOLE_LINE     : integer := H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;

    constant V_VISIBLE_AREA   : integer := 480;
    constant V_FRONT_PORCH    : integer := 10;
    constant V_SYNC_PULSE     : integer := 2;
    constant V_BACK_PORCH     : integer := 33;
    constant V_WHOLE_FRAME    : integer := V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;

    -- Horizontal and Vertical Counters
    signal h_count : integer range 0 to H_WHOLE_LINE - 1 := 0;
    signal v_count : integer range 0 to V_WHOLE_FRAME - 1 := 0;

begin

    -- Process for horizontal and vertical counters
    process(pixel_clk)
    begin
        if rising_edge(pixel_clk) then

            -- Horizontal Counter
            if h_count = H_WHOLE_LINE - 1 then
                h_count <= 0;

                -- Vertical Counter (incremented once per row)
                if v_count = V_WHOLE_FRAME - 1 then
                    v_count <= 0;
                else
                    v_count <= v_count + 1;
                end if;

            else
                h_count <= h_count + 1;
            end if;

        end if;
    end process;

    -- Combinational Logic for Horizontal Sync (HSYNC)
    hsync <= '0' when (h_count >= H_VISIBLE_AREA + H_FRONT_PORCH and
                       h_count < H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE) else '1';

    -- Combinational Logic for Vertical Sync (VSYNC)
    vsync <= '0' when (v_count >= V_VISIBLE_AREA + V_FRONT_PORCH and
                       v_count < V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE) else '1';

    -- Display Enable Signal (Display is on during the visible area)
    display_on <= '1' when (h_count < H_VISIBLE_AREA and v_count < V_VISIBLE_AREA) else '0';

    -- Assign the current row and column for display
    col <= std_logic_vector(to_unsigned(h_count, 10));
    row <= std_logic_vector(to_unsigned(v_count, 10));

end Behavioral;
