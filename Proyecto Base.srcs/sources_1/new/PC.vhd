----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.10.2022 17:16:16
-- Design Name: 
-- Module Name: PC - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC is
    Port ( count_in : in STD_LOGIC_VECTOR (11 downto 0);
           rom_adress : out STD_LOGIC_VECTOR (11 downto 0);
           loadPC : in STD_LOGIC;
           clear : in STD_LOGIC;
           clock : in STD_LOGIC);
end PC;

architecture Behavioral of PC is

signal adress : std_logic_vector(11 downto 0) := (others => '0');

begin

pc_process : process (clock, clear)        -- Proceso sensible a clock y clear.
        begin
          if (clear = '1') then             -- Si clear = 1
            adress <= (others => '0');         -- Carga 0 en el registro.
          elsif (rising_edge(clock)) then   -- Si flanco de subida de clock.
            if (loadPC = '1') then            -- Si clear = 0, load = 1.
                adress <= count_in;              -- Carga la entrada de datos en el registro.
            else          
                adress <= adress + 1;             -- Incrementa el registro en 1.
        
            end if;
          end if;
        end process;
        
rom_adress <= adress;                             -- Los datos del registro salen sin importar el estado de clock.

end Behavioral;
