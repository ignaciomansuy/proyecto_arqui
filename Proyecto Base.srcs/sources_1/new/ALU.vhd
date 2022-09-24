library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU is
    Port ( a        : in  std_logic_vector (15 downto 0);   -- Primer operando.
           b        : in  std_logic_vector (15 downto 0);   -- Segundo operando.
           sop      : in  std_logic_vector (2 downto 0);   -- Selector de la operación.
           c        : out std_logic;                       -- Señal de 'carry'.
           z        : out std_logic;                       -- Señal de 'zero'.
           n        : out std_logic;                       -- Señal de 'nagative'.
           result   : out std_logic_vector (15 downto 0));  -- Resultado de la operación.
end ALU;

architecture Behavioral of ALU is

component Adder16 is
    Port ( a  : in  std_logic_vector (15 downto 0);
           b  : in  std_logic_vector (15 downto 0);
           ci : in  std_logic;
           s  : out std_logic_vector (15 downto 0);
           co : out std_logic);
end component;

signal alu_result   : std_logic_vector(15 downto 0);
signal adder_result   : std_logic_vector(15 downto 0);
signal ci   : std_logic;
signal co   : std_logic;
signal adder_b   : std_logic_vector(15 downto 0);


begin

-- Sumador/Restaror

ci <= sop(0) and not sop(1) and not sop(2);

with ci select
    adder_b <= b when '0',
               not b when others;

inst_Adder16: Adder16 port map(
        a      =>a,
        b      =>adder_b,
        ci     =>ci,
        s      =>adder_result,
        co     =>co
    );
    


                
-- Resultado de la Operación
               
with sop select
    alu_result <= adder_result     when "000",
                  adder_result     when "001",
                  a and b          when "010",
                  a or b           when "011",
                  a xor b          when "100",
                  not a            when "101",
                  '0' & a(15 downto 1)  when "110",
                  a(7 downto 0) & '0'  when "111",
                  "0000000000000000" when others;
                  
result  <= alu_result;

-- Flags c z n
with sop select
    c <= co     when "000",
         co     when "001",
         '0'     when "010",
         '0'     when "011",
         '0'     when "100",
         '0'     when "101",
         a(0)     when "110",
         a(15)     when "111",
         '0' when others;
            
with alu_result select
    z <= '1' when "0000000000000000",
        '0' when others;
     
with sop select
    n <= not co when "001",
        '0' when others;          
    
end Behavioral;

