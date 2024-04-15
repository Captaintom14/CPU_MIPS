
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity pc_reg is port (

d_in : in std_logic_vector (31 downto 0);
reset,clk : in std_logic;
q_out : out std_logic_vector (31 downto 0));

end pc_reg;

architecture arch_pc of pc_reg is 

begin 
process (d_in, reset, clk)

begin 
    if (reset = '1') then
         q_out <= X"00000000";
    
    elsif (clk'event and clk = '1') then 
         q_out <= d_in;
    
     end if;
     end process;
end arch_pc;


