LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ball IS
	PORT (
		v_sync    : IN STD_LOGIC;
		pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		red       : OUT STD_LOGIC;
		green     : OUT STD_LOGIC;
		blue      : OUT STD_LOGIC
	);
END ball;

ARCHITECTURE Behavioral OF ball IS

--change size below to vary size of ball
----------------------------------------------------------------------------------------
	CONSTANT size  : INTEGER := 30;
----------------------------------------------------------------------------------------

	SIGNAL ball_on : STD_LOGIC; -- indicates whether ball is over current pixel position
	-- current ball position - intitialized to center of screen
	SIGNAL ball_x  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
	SIGNAL ball_y  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
	-- current ball motion - initialized to +4 pixels/frame
	SIGNAL ball_y_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000100";
	
	--add signal for x motion of ball
	SIGNAL ball_x_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000100";
    ----------------------------------------------------------------------
	
BEGIN

--adjust values below to vary color of ball
----------------------------------------------------------------------------------------
	red <= NOT ball_on;
	green <= '1';
	blue  <= '1';
----------------------------------------------------------------------------------------
	
	-- process to draw ball current pixel address is covered by ball position
	bdraw : PROCESS (ball_x, ball_y, pixel_row, pixel_col) IS
	BEGIN
	
	--change code below to make ball round instead of square
	
		--IF (pixel_col >= ball_x - size) AND
		 --(pixel_col <= ball_x + size) AND
			-- (pixel_row >= ball_y - size) AND
			 --(pixel_row <= ball_y + size) THEN
		IF ((conv_integer(pixel_col) - conv_integer(ball_x)) * (conv_integer(pixel_col) - conv_integer(ball_x))) + 
		   ((conv_integer(pixel_row) - conv_integer(ball_y)) * (conv_integer(pixel_row) - conv_integer(ball_y)))
		   <= (size*size) THEN	
    ------------------------------------------------------------------------------------------------------------------------
				ball_on <= '1';
		ELSE
			ball_on <= '0';
		END IF;
		END PROCESS;
		-- process to move ball once every frame (i.e. once every vsync pulse)
		mball : PROCESS
		BEGIN
			WAIT UNTIL rising_edge(v_sync);
			-- allow for bounce off top or bottom of screen
			IF ball_y + size >= 600 THEN
				ball_y_motion <= "11111111100"; -- -4 pixels
			ELSIF ball_y <= size THEN
				ball_y_motion <= "00000000100"; -- +4 pixels
			END IF;
			ball_y <= ball_y + ball_y_motion; -- compute next ball position
			
			--allow for bounce off side walls
			IF ball_x + size >= 800 THEN
				ball_x_motion <= "11111111100"; -- -4 pixels
			ELSIF ball_x <= size THEN
				ball_x_motion <= "00000000100"; -- +4 pixels
			END IF;
			ball_x <= ball_x + ball_x_motion; -- compute next ball position
			----------------------------------------------------------------
		END PROCESS;
END Behavioral;