library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Basys3 is
    Port (
        sw          : in   std_logic_vector (15 downto 0); -- No Tocar - Señales de entrada de los interruptores -- Arriba   = '1'   -- Los 16 swiches.
        btn         : in   std_logic_vector (4 downto 0);  -- No Tocar - Señales de entrada de los botones       -- Apretado = '1'   -- 0 central, 1 arriba, 2 izquierda, 3 derecha y 4 abajo.
        led         : out  std_logic_vector (15 downto 0); -- No Tocar - Señales de salida  a  los leds          -- Prendido = '1'   -- Los 16 leds.
        clk         : in   std_logic;                      -- No Tocar - Señal de entrada del clock              -- Frecuencia = 100Mhz.
        seg         : out  std_logic_vector (7 downto 0);  -- No Tocar - Salida de las señales de segmentos.
        an          : out  std_logic_vector (3 downto 0)   -- No Tocar - Salida del selector de diplay.
          );
end Basys3;

architecture Behavioral of Basys3 is

-- Inicio de la declaración de los componentes.
    
component Debouncer -- No Tocar
    Port (
        clk         : in    std_logic;
        signal_in   : in    std_logic;
        signal_out  : out   std_logic
          );
    end component;
    
component Display_Controller -- No Tocar
    Port (  
        dis_a       : in    std_logic_vector (3 downto 0);
        dis_b       : in    std_logic_vector (3 downto 0);
        dis_c       : in    std_logic_vector (3 downto 0);
        dis_d       : in    std_logic_vector (3 downto 0);
        clk         : in    std_logic;
        seg         : out   std_logic_vector (7 downto 0);
        an          : out   std_logic_vector (3 downto 0)
          );
    end component;
    
component Reg -- No Tocar
    Port (
        clock       : in    std_logic;
        clear       : in    std_logic;
        load        : in    std_logic;
        up          : in    std_logic;
        down        : in    std_logic;
        datain      : in    std_logic_vector (15 downto 0);
        dataout     : out   std_logic_vector (15 downto 0)
          );
    end component;

component ALU -- No Tocar
    Port ( 
        a           : in    std_logic_vector (7 downto 0);
        b           : in    std_logic_vector (7 downto 0);
        sop         : in    std_logic_vector (2 downto 0);
        c           : out   std_logic;
        z           : out   std_logic;
        n           : out   std_logic;
        result      : out   std_logic_vector (7 downto 0)
          );
    end component;
    
component Mux 
    Port ( 
        datain0 : in STD_LOGIC_VECTOR (15 downto 0);
        datain1 : in STD_LOGIC_VECTOR (15 downto 0);
        datain2 : in STD_LOGIC_VECTOR (15 downto 0);
        datain3 : in STD_LOGIC_VECTOR (15 downto 0);
        sel : in STD_LOGIC_VECTOR (1 downto 0);
        dataout : out STD_LOGIC_VECTOR (15 downto 0)
);
end component;


component PC 
    Port ( count_in : in STD_LOGIC_VECTOR (11 downto 0);
           rom_adress : out STD_LOGIC_VECTOR (11 downto 0);
           loadPC : in STD_LOGIC;
           clear : in STD_LOGIC;
           clock : in STD_LOGIC
);
end component;

component status is
    Port ( c : in STD_LOGIC;
           z : in STD_LOGIC;
           n : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (2 downto 0));
end component;
-- Fin de la declaración de los componentes.

-- Inicio de la declaración de señales.

signal d_btn            : std_logic_vector(4 downto 0);  -- Señales de botones con anti-rebote.
            
signal dis_a            : std_logic_vector(3 downto 0);  -- Señales de salida al display A.    
signal dis_b            : std_logic_vector(3 downto 0);  -- Señales de salida al display B.     
signal dis_c            : std_logic_vector(3 downto 0);  -- Señales de salida al display C.    
signal dis_d            : std_logic_vector(3 downto 0);  -- Señales de salida al display D.
     
signal a                : std_logic_vector(15 downto 0);  -- Señal primer operador    
signal b                : std_logic_vector(15 downto 0);  -- Señal segundo operador.     

signal dataOutRegA                : std_logic_vector(15 downto 0);  -- Señal salida Reg A.    
signal dataOutRegB                : std_logic_vector(15 downto 0);  -- Señal salida Reg B.  

signal result           : std_logic_vector(7 downto 0);  -- Señales del resultado.
signal C                : std_logic;
signal Z                : std_logic;
signal N                : std_logic;
signal status_result           : std_logic_vector(3 downto 0);  -- Señales del resultado.



signal datain           : std_logic_vector(15 downto 0);  -- Señales de datos de entrada a los registros.

signal datainMuxA           : std_logic_vector(15 downto 0);
signal datainMuxB           : std_logic_vector(15 downto 0);

-- Fin de la declaración de señales.

begin

-- Inicio de declaración de comportamientos.

-- Muxer Regs
-- with sw(12) select
--    datain <= result            when '0',
--              sw(7 downto 0)    when others;

-- Muxers del Display
with btn(0) select
    dis_a <= a(7 downto 4)      when '0',
             "0000"             when others;
                     
with btn(0) select
    dis_b <= a(3 downto 0)      when '0',
             "0000"             when others;

with btn(0) select
    dis_c <= b(7 downto 4)      when '0',
             result(7 downto 4) when others;
                
with btn(0) select
    dis_d <= b(3 downto 0)      when '0',
             result(3 downto 0) when others;


-- Inicio de declaración de instancias.

inst_REG_A: Reg port map( -- !
    clock       => d_btn(2),
    clear       => '0',
    load        => '1',
    up          => '0',
    down        => '0',
    datain      => datain,
    dataout     => dataOutRegA
    );
    
inst_REG_B: Reg port map( -- !
    clock       => d_btn(3),
    clear       => '0',
    load        => '1',
    up          => '0',
    down        => '0',
    datain      => datain,
    dataout     => dataOutRegB
    );
    
 inst_Mux_A: Mux port map(
    datain0 => "0000000000000000",
    datain1 => "0000000000000001",
    datain2 => dataOutRegA,
    datain3 => "0000000000000000", -- not used
    sel => selA,  -- TODO: control unit
    dataout => a
    );
    
inst_Mux_B: Mux port map(
    datain0 => "0000000000000000",
    datain1 => ram_dataout, -- TODO
    datain2 => dataOutRegB,
    datain3 => rom_dataout, -- TODO
    sel => selB,  -- TODO: control unit
    dataout => a
);
 
inst_ALU: ALU port map(
    a           => a,
    b           => b,
    sop         => sw(15 downto 13),
    c           => C,
    z           => Z,
    n           => N,
    result      => result
    );

 
inst_PC: PC port map(
    count_in    => rom_dataout, -- TODO
    loadPC      => loadPC, -- TODO Control unit
    clear       => '0',
    clock       => '0', -- TODO
    rom_adress  => 
);
   
inst_status: status port map(
    c => C,
    z => Z,
    n => N,
    data_out => status_result

);

-- Intancia de Display_Controller.        
inst_Display_Controller: Display_Controller port map(
    dis_a => dis_a, 
    dis_b => dis_b, 
    dis_c => dis_c, 
    dis_d => dis_d,     
    clk => clk ,        -- No Tocar - Entrada del clock completo (100Mhz).
    seg => seg,         -- No Tocar - Salida de las señales de segmentos. 
    an => an            -- No Tocar - Salida del selector de diplay.
    );

-- No Tocar - Intancias de Debouncers.    
inst_Debouncer0: Debouncer port map( clk => clk, signal_in => btn(0), signal_out => d_btn(0) );
inst_Debouncer1: Debouncer port map( clk => clk, signal_in => btn(1), signal_out => d_btn(1) );
inst_Debouncer2: Debouncer port map( clk => clk, signal_in => btn(2), signal_out => d_btn(2) );
inst_Debouncer3: Debouncer port map( clk => clk, signal_in => btn(3), signal_out => d_btn(3) );
inst_Debouncer4: Debouncer port map( clk => clk, signal_in => btn(4), signal_out => d_btn(4) );
    
-- Fin de declaración de instancias.

-- Fin de declaración de comportamientos.
  
end Behavioral;