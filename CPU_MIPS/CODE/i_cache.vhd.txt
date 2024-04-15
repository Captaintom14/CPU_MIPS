
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;


entity iCache is port(

input_address: in std_logic_vector (4 downto 0);
data: out std_logic_vector (31 downto 0));

end iCache;

architecture arch_iCache  of iCache is

signal data_signal : std_logic_vector (31 downto 0);

begin 

process (input_address)

begin 
if (input_address = "00000") then
      data_signal <= "00100000000000110000000000000000";

elsif (input_address = "00001") then
        data_signal <= "00100000000000010000000000000000";

elsif (input_address = "00010") then
        data_signal <= "00100000000000100000000000000101";

elsif (input_address = "00011") then
        data_signal <= "00000000001000100000100000100000";

elsif (input_address = "00100") then
        data_signal <= "00100000010000101111111111111111";

elsif (input_address = "00101") then
        data_signal <= "00010000010000110000000000000001";

elsif (input_address = "00110") then
        data_signal <= "00001000000000000000000000000011";

elsif (input_address = "00111") then
        data_signal <= "10101100000000010000000000000000";

elsif (input_address = "01000") then
         data_signal <= "10001100000001000000000000000000";

elsif (input_address = "01001") then
         data_signal <= "00110000100001000000000000001010";

elsif (input_address = "01010") then
        data_signal <= "00110100100001000000000000000001";

elsif (input_address = "01011") then 
        data_signal <= "00111000100001000000000000001011";

elsif (input_address = "01100") then
         data_signal <= "00111000100001000000000000000000";

else 
       data_signal <= "00000000000000000000000000000000";
end if;
end process;

data <= data_signal;

end arch_iCache; 
















 


