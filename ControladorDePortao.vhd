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
		output   : out	std_logic_vector(1 downto 0)
	);

end entity;

architecture rtl of ControladorDePortao is

	type state_type is (awaiting_command, oppening, closing);

	signal state   : state_type;

begin

	process (clk, reset)
	begin
	
		if reset = '1' then
			state <= awaiting_command;
			
		elsif (rising_edge(clk)) then
		
			case state is
			
				when awaiting_command=>
				
					if command = '1' then
						
						if sensor_1 = '1' then
						
							state <= oppening;
							
						elsif sensor_2 = '1' then
						
							state <= closing;
							
						else
						
							state <= closing;
							
						end if;
						
					else
					
						state <= awaiting_command;
						
					end if;
					
				when oppening=>
				
					if sensor_2 = '1' then
						state <= awaiting_command;
					else
						state <= oppening;
					end if;
					
				when closing=>
				
					if sensor_1 = '1' then
					
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
				output <= "11";
			when oppening =>
				output <= "10";
			when closing =>
				output <= "01";
		end case;
	end process;

end rtl;
