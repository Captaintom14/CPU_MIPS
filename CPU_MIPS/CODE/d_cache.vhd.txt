library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity dCache is port (

d_in : in std_logic_vector (31 downto 0);
clk : in std_logic;
reset : in std_logic; 
data_write : in std_logic;
address : in std_logic_vector (4 downto 0);
d_out : out std_logic_vector (31 downto 0));

end dCache;

architecture arch_dCache of dCache is 

type registers is array (0 to 31) of std_logic_vector(31 downto 0);

signal r : registers;
begin

    process (reset,clk)
          begin 
                if (reset = '1') then
                  r <= (others => (others => '0'));
                elsif (clk'event and clk = '1') then 
                     if (data_write = '1') then 
                        r(TO_INTEGER(unsigned(address))) <= d_in;
                     end if;
                end if;
       end process;

d_out <= r(TO_INTEGER(unsigned(address)));

end arch_dCache;
