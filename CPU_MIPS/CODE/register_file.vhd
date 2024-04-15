library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity regfile is port (
--inputs
din : in std_logic_vector(31 downto 0);
reset, clk, write : in std_logic;
read_a, read_b, write_address : in std_logic_vector (4 downto 0);

--outputs
out_a, out_b : out std_logic_vector (31 downto 0));

end regfile;


architecture arch_reg of regfile is 

type registers is array (0 to 31) of std_logic_vector(31 downto 0);

signal r : registers;
begin

    process (reset,clk)
          begin 
                if (reset = '1') then
                  r <= (others => (others => '0'));
                elsif (clk'event and clk = '1') then 
                     if (write = '1') then 
                        r(TO_INTEGER(unsigned(write_address))) <= din;
                     end if;
                end if;
       end process;

out_a <= r(TO_INTEGER(unsigned(read_a)));
out_b <= r(TO_INTEGER(unsigned(read_b)));

end arch_reg;
