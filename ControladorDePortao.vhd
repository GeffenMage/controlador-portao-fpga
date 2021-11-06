-- Controlador de Portao Eletrico

-- Equipe:
-- Daniel Sousa Duplat,
-- Paulo Henrique Miranda Sa,
-- Lucas Lemos Ortega,
-- Rafael Bessa loureiro,
-- Pedro Marcelo de Carvalho

library ieee;
use ieee.std_logic_1164.all;

entity ControladorDePortao is

	port(
		clk	   : in	std_logic;
		command  : in	std_logic;
		sensor_1 : in  std_logic;
		sensor_2 : in  std_logic;
		reset	   : in	std_logic;
		b0   		: out	std_logic;
		b1			: out	std_logic
	);

end entity;

architecture rtl of ControladorDePortao is

	type state_type is (awaiting_command, oppening, closing);

	signal state   : state_type;

begin

	process (clk, reset)
	begin
		if reset = '0' then
			state <= awaiting_command;
			
		elsif (rising_edge(clk)) then
		
			case state is
			
				when awaiting_command=>
							
					if sensor_1 = '0' and sensor_2 = '1' and command = '0' then
					
						state <= oppening;
					end if;
						
					if sensor_2 = '0' and sensor_1 = '1' and command = '0' then
					
						state <= closing;
							
					end if;
					
				when oppening=>
				
					if sensor_2 = '0'  and sensor_1 = '1' then
						state <= awaiting_command;
					else
						state <= oppening;
					end if;
					
				when closing=>
				
					if sensor_1 = '0' and sensor_2 = '1' then
						state <= awaiting_command;
					else
						state <= closing;
						
					end if;
					
			end case;
		end if;
	end process;

	process (state)
	begin
		case state is
			when awaiting_command =>
				b0 <= '1';
				b1 <= '1';
			when oppening =>
				b0 <= '1';
				b1 <= '0';
			when closing =>
				b0 <= '0';
				b1 <= '1';
		end case;
	end process;

end rtl;