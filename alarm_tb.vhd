LIBRARY ieee;
LIBRARY generics;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE generics.components.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE behavior OF testbench IS 

	COMPONENT Alarm
	PORT(
		i_clk : IN std_logic;
		i_A : IN std_logic;
		i_B : IN std_logic;
		i_C : IN std_logic;
		reset : IN std_logic;
		i_motion : IN std_logic;          
		o_alarm : OUT std_logic
		);
	END COMPONENT;

	SIGNAL i_clk :  std_logic;
	SIGNAL i_A :  std_logic;
	SIGNAL i_B :  std_logic;
	SIGNAL i_C :  std_logic;
	SIGNAL reset :  std_logic;
	SIGNAL i_motion :  std_logic;
	SIGNAL o_alarm :  std_logic;

BEGIN

	uut: Alarm PORT MAP(
		i_clk => i_clk,
		i_A => i_A,
		i_B => i_B,
		i_C => i_C,
		reset => reset,
		i_motion => i_motion,
		o_alarm => o_alarm
	);


-- *** Test Bench - User Defined Section ***
   ck: PROCESS
   BEGIN
	i_clk<='0';
	for i in 1 to 1000 loop
		wait for 5ns;
		i_clk<=not i_clk;
	end loop;
	wait;
   END PROCESS;

   tb : PROCESS
   BEGIN
	i_motion<='0';
	reset<='0';
	i_A<='0';
	i_B<='0';	-- pressed C
	i_C<='1';	
	wait for 10ns;
  	i_A<='0';
	i_B<='0';	-- unpressed C
	i_C<='0';
	wait for 20ns;
	i_A<='0';
	i_B<='1';	-- pressed B
	i_C<='0';
	wait for 10ns;
  	i_A<='0';
	i_B<='0';	-- unpressed B
	i_C<='0';
	wait for 20ns;
  	i_A<='0';
	i_B<='0';	-- pressed C
	i_C<='1';
	wait for 10ns;
  	i_A<='0';
	i_B<='0';	-- unpressed C
	i_C<='0';
	wait for 20ns;
	i_A<='1';
	i_B<='0';	-- pressed A
	i_C<='0';			--worng combination
	wait for 10ns;
  	i_A<='0';
	i_B<='0';	-- unpressed A
	i_C<='0';
	wait for 20ns;
	i_A<='0';	--presed B
	i_B<='1';			--click anything to reset
	i_C<='0';
	wait for 10ns;
  	i_A<='0';
	i_B<='0';	-- unpressed B
	i_C<='0';
	wait for 20ns;
	i_A<='0';
	i_B<='0';	-- pressed C
	i_C<='1';
	wait for 10ns;
  	i_A<='0';
	i_B<='0';	-- unpressed C
	i_C<='0';
	wait for 20ns;
	i_A<='0';
	i_B<='1';	-- pressed B
	i_C<='0';
	wait for 10ns;
  	i_A<='0';
	i_B<='0';	-- unpressed B
	i_C<='0';
	wait for 20ns;
	i_A<='1';
	i_B<='0';	-- pressed A
	i_C<='0';
	wait for 10ns;
  	i_A<='0';
	i_B<='0';	-- unpressed A
	i_C<='0';
	wait for 20ns;
	i_A<='0';
	i_B<='1';	-- pressed B
	i_C<='0';			-- correct password, alarm has been armed
	wait for 10ns;
  	i_A<='0';
	i_B<='0';	-- unpressed B
	i_C<='0';
	wait for 20ns;
	i_motion<='1';			--motion sensor gets acctivated
	wait for 20ns;
	i_A<='0';
	i_B<='0';	-- pressed C
	i_C<='1';
	wait for 10ns;
  	i_A<='0';
	i_B<='0';	-- unpressed C
	i_C<='0';
	wait for 20ns;
	i_A<='0';
	i_B<='1';	-- pressed B
	i_C<='0';
	wait for 10ns;
  	i_A<='0';
	i_B<='0';	-- unpressed B
	i_C<='0';
	wait for 20ns;
	i_A<='1';
	i_B<='0';	-- pressed A
	i_C<='0';
	wait for 10ns;
  	i_A<='0';
	i_B<='0';	-- unpressed A
	i_C<='0';
	wait for 20ns;
	i_A<='0';
	i_B<='1';	-- pressed B
	i_C<='0';			-- correct password, alarm has been turned off
	wait for 10ns;
  	i_A<='0';
	i_B<='0';	-- unpressed B
	i_C<='0';
	wait for 20ns;
	i_A<='0';	--presed B
	i_B<='1';			--click anything to reset
	i_C<='0';
	wait for 10ns;
  	i_A<='0';
	i_B<='0';	-- unpressed B
	i_C<='0';
	wait for 20ns;
	i_A<='0';
	i_B<='0';	-- pressed C
	i_C<='1';
	wait for 10ns;
  	i_A<='0';
	i_B<='0';	-- unpressed C
	i_C<='0';
	wait for 20ns;
	i_A<='0';
	i_B<='1';	-- pressed B
	i_C<='0';
	wait for 10ns;
  	i_A<='0';
	i_B<='0';	-- unpressed B
	i_C<='0';
	wait for 20ns;
	i_A<='1';
	i_B<='0';	-- pressed A
	i_C<='0';
	wait for 10ns;
  	i_A<='0';
	i_B<='0';	-- unpressed A
	i_C<='0';
	wait for 20ns;
	i_A<='0';
	i_B<='1';	-- pressed B
	i_C<='0';			-- correct password, alarm has been armed again
	wait for 10ns;
  	i_A<='0';
	i_B<='0';	-- unpressed B
	i_C<='0';
	wait for 20ns;
      wait; -- will wait forever
   END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;

