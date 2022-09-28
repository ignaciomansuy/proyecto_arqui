----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.09.2022 12:54:54
-- Design Name: 
-- Module Name: Mux - Behavioral
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

entity Mux is
    Port ( datain0 : in STD_LOGIC_VECTOR (15 downto 0);
           datain1 : in STD_LOGIC_VECTOR (15 downto 0);
           datain2 : in STD_LOGIC_VECTOR (15 downto 0);
           datain3 : in STD_LOGIC_VECTOR (15 downto 0);
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           dataout : out STD_LOGIC_VECTOR (15 downto 0));
end Mux;

architecture Behavioral of Mux is


begin

with sel select
    dataout <= datain0 when "00",
                datain1 when "01",
                datain2 when "10",
                datain3 when others;

end Behavioral;
