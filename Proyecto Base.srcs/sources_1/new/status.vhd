----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.10.2022 19:13:14
-- Design Name: 
-- Module Name: status - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity status is
    Port ( c : in STD_LOGIC;
           z : in STD_LOGIC;
           n : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (2 downto 0));
end status;

architecture Behavioral of status is

begin
-- For E1 only implementing JEQ and JNE
with z select
    data_out <= "001" when '1', -- JEQ
            "010" when '0', -- JNE
            "000" when others;

end Behavioral;
