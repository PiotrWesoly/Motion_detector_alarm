library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-----------------------------------------------------
entity Alarm is port( 
 i_clk:     in  std_logic;
 i_A, i_B, i_C, reset, i_motion:     in  std_logic;	--- Three code buttons: A, B, C plus motion sensor for armed state 
 o_alarm:   out std_logic);
end;
-----------------------------------------------------
-----------------------------------------------------
architecture sequential of Alarm is

type state is (
	initState0, initState1, initState2, initState3, initState4, initState5, initState6,
	armedState0, armedState1, armedState2, armedState3, armedState4, armedState5, armedState6,	
	wrongState, alarmState, deactivatedState);
signal currState, nextState: state;
signal alarm_flag, alarm_reset: std_logic;

begin

-----------------------------------------------------
stateMemory: process (i_clk)
begin
 if( rising_edge(i_clk) ) then
	currState <= nextState;
 	if( alarm_flag = '1' and alarm_reset/='1') then
		o_alarm<='1';
	elsif(alarm_reset='1' and alarm_flag/='1') then
		o_alarm<='0';
	end if;	
 end if;
end process stateMemory;
---------------------------------------------------
stateDecode:process(i_A, i_B, i_C, i_motion, reset, alarm_flag, currState )
begin


 case currState is
		-----INITIAL STATES-----		--- In order to turn on the alarm you have to enter correct  
  when	initState0 =>				        	-- sequence, in this case C, B, A, B
	alarm_reset<='0';
	if(i_A='0' and i_B='0' and i_C='1') then
		nextState <= initState1;
	elsif(i_A='0' and i_B='0' and i_C='0') then
			nextState <= initState0;	
		else
		nextState <= initState4;
	end if;
  when	initState1 =>
--	o_alarm<='0';
	if(reset='1') then
		nextState<= initState0;
	else 
		if(i_A='0' and i_B='1' and i_C='0') then
			nextState <= initState2;
		elsif(i_A='0' and i_B='0' and i_C='0') then
			nextState <= initState1;	
		else
			nextState <= initState5;
		end if;
	end if;
when	initState2 =>
	if(reset='1') then
		nextState<= initState0;
	else 
		if(i_A='1' and i_B='0' and i_C='0') then
			nextState <= initState3;
		elsif(i_A='0' and i_B='0' and i_C='0') then
			nextState <= initState2;	
		else
			nextState <= initState6;
		end if;
	end if;
when	initState3 =>
	if(reset='1') then
		nextState<= initState0;
	else 
		if(i_A='0' and i_B='1' and i_C='0') then
			nextState <= armedState0;
		elsif(i_A='0' and i_B='0' and i_C='0') then
			nextState <= initState3;	
		else
			nextState <= wrongState;
		end if;
	end if;
when	initState4 =>					--if at any point you pressed a wrong button, then you have to go 
--	o_alarm<='0';						--through additional states since its 4-button code you
	if(reset='1') then					--have to input 4 buttons even if they are incorrect
		nextState<= initState0;				
	else
		if(i_A='1' or i_B='1' or i_C='1') then
			nextState <= initState5;
		elsif(i_A='0' and i_B='0' and i_C='0') then
			nextState <= initState4;	
		end if;
	end if;
when	initState5 =>
	if(reset='1') then
		nextState<= initState0;
	else 
		if(i_A='1' or i_B='1' or i_C='1') then
			nextState <= initState6;
		elsif(i_A='0' and i_B='0' and i_C='0') then
			nextState <= initState5;	
		end if;
	end if;
when	initState6 =>
	if(reset='1') then
		nextState<= initState0;
	else 
		if(i_A='1' or i_B='1' or i_C='1') then
			nextState <= wrongState;
		elsif(i_A='0' and i_B='0' and i_C='0') then
			nextState <= initState6;
		end if;
	end if;

		-----WRONG STATE-----

when	wrongState =>
	if(i_A='0' and i_B='0' and i_C='0') then
		nextState <= wrongState;
	elsif(reset='1' or i_A='1' or i_B='1' or i_C='1') then
		nextState<= initState0;			---Wrong combination was entered, you cannot arm this alarm
	end if;							---press anything to start again

		-----ARMED STATES-----

  when	armedState0 =>				
	if(reset='1') then
		nextState<= initState0;
	elsif(i_motion='1' and alarm_flag/= '0') then 
		nextState <= alarmState;		---If in any of armed states motion detector will detect somethig
	else							-- it will  trigger the alarm and go to alarm state 
		if(i_A='0' and i_B='0' and i_C='1') then
			nextState <= armedState1;
		elsif(i_A='0' and i_B='0' and i_C='0') then
			nextState <= armedState0;	
		else
			nextState <= armedState4;
		end if;
	end if;
  when	armedState1 =>
	if(reset='1') then
		nextState<= armedState0;
	elsif(i_motion='1' and alarm_flag= '0') then 
		nextState <= alarmState;
	else 
		if(i_A='0' and i_B='1' and i_C='0') then
			nextState <= armedState2;
		elsif(i_A='0' and i_B='0' and i_C='0') then
			nextState <= armedState1;	
		else
			nextState <= armedState5;
		end if;
	end if;
when	armedState2 =>	
	if(reset='1') then
		nextState<= armedState0;
	elsif(i_motion='1' and alarm_flag= '0') then 
		nextState <= alarmState;
	else 
		if(i_A='1' and i_B='0' and i_C='0') then
			nextState <= armedState3;
		elsif(i_A='0' and i_B='0' and i_C='0') then
			nextState <= armedState2;	
		else
			nextState <= armedState6;
		end if;
	end if;
when	armedState3 =>
	if(reset='1') then
		nextState<= armedState0;
	elsif(i_motion='1' and alarm_flag= '0') then 
		nextState <= alarmState;
	else 
		if(i_A='0' and i_B='1' and i_C='0') then
			nextState <= deactivatedState;
		elsif(i_A='0' and i_B='0' and i_C='0') then
			nextState <= armedState3;	
		else
			nextState <= alarmState;
		end if;
	end if;
when	armedState4 =>
	if(reset='1') then
		nextState<= armedState0;
	elsif(i_motion='1' and alarm_flag= '0') then 
		nextState <= alarmState;
	else
		if(i_A='1' or i_B='1' or i_C='1') then
			nextState <= armedState5;
		end if;
	end if;
when	armedState5 =>
	if(reset='1') then
		nextState<= armedState0;
	elsif(i_motion='1' and alarm_flag= '0') then 
		nextState <= alarmState;
	else 
		if(i_A='1' or i_B='1' or i_C='1') then
			nextState <= armedState6;
		end if;
	end if;
when	armedState6 =>
	if(reset='1') then
		nextState<= armedState0;
	elsif(i_motion='1' and alarm_flag= '0') then 
		nextState <= alarmState;
	else 
		if(i_A='1' or i_B='1' or i_C='1') then
			nextState <= alarmState;
		end if;
	end if;

		-----DEACTIVATED STATE-----

when	deactivatedState =>
	alarm_reset<='1';
	alarm_flag<='0';
	i_motion<='0';
	if(i_A='0' and i_B='0' and i_C='0') then
		nextState <= deactivatedState;	
	elsif(reset='1' or i_A='1' or i_B='1' or i_C='1') then
		nextState<= initState0;			---Correct combination was entered, you have disabled this alarm
	end if;							--- to enable it again enter correct password

		-----ALARM STATE-----

when	alarmState =>
	alarm_flag<='1';
	
	if(i_A='0' and i_B='0' and i_C='1') then	---Alarm was triggered, enter correct password to deactivate it 
			nextState <= armedState1;
	elsif(i_A='0' and i_B='0' and i_C='0') then
			nextState <= alarmState;
	else
			nextState <= armedState4;
	end if;
  when	others =>
	nextState <= initState0;
	alarm_flag<='0';
	alarm_reset<='0';
end case;


end process stateDecode;
-----------------------------------------------------

end sequential;
