-------------------------------------------------------------
-- Local oscillator (complex)
--
-- Frequency = f_trig/DIV
-- Update LUTs for DIV!=10
--
-- Wojciech Kaczmarski, SP5WWP
-- M17 Project
-- May 2023
-------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity local_osc is
	generic(
		DIV		: integer := 10
	);
	port(
		clk_i	: in std_logic;
		trig_i	: in std_logic;
		i_o		: out signed(15 downto 0) := x"7FFF";
		q_o		: out signed(15 downto 0) := x"0000"
	);
end local_osc;

architecture magic of local_osc is
	type lut is array(integer range 0 to DIV-1) of signed(15 downto 0);
	constant i_lut : lut := (
		x"7FFF", x"678D", x"278E", x"D872", x"9873", x"8001", x"9873", x"D872", x"278E", x"678D"
	);
	constant q_lut : lut := (
		x"0000", x"4B3C", x"79BB", x"79BB", x"4B3C", x"0000", x"B4C4", x"8645", x"8645", x"B4C4"
	);
	
	signal p_trig, pp_trig : std_logic := '0';
begin
	process(clk_i)
		variable cnt : integer range 0 to DIV := 0;
	begin
		if rising_edge(clk_i) then
			p_trig <= trig_i;
			pp_trig <= p_trig;
		
			if pp_trig='0' and p_trig='1' then
				if cnt=DIV-1 then
					cnt := 0;
				else
					cnt := cnt + 1;
				end if;

				i_o <= i_lut(cnt);
				q_o <= q_lut(cnt);
			end if;
		end if;
	end process;
end magic;
