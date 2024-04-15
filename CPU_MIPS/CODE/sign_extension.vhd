library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity sign_extension is port (

bits : in std_logic_vector (15 downto 0);
func : in std_logic_vector (1 downto 0);
output : out std_logic_vector (31 downto 0));

end sign_extension; 

architecture arch_sign of sign_extension is
begin

process (func,bits)
begin
if (func = "00") then

output <= bits (15 downto 0) & X"0000";

elsif (func = "01") then

output <= (31 downto 16 => bits(15)) & bits (15 downto 0);

elsif (func = "10") then

output <= (31 downto 16 => bits(15)) & bits (15 downto 0);

else 
 
output <= X"0000" & bits (15 downto 0);

end if;
end process; 
end arch_sign;


