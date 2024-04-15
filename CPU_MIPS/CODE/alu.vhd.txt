
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity alu is port(

-- inputs
x_in, y_in : in std_logic_vector (31 downto 0);
add_sub : in std_logic;
logic_func : in std_logic_vector (1 downto 0);
func: in std_logic_vector (1 downto 0);



-- outputs

output_out : out std_logic_vector (31 downto 0);
overflow : out std_logic;
zero : out std_logic);

end alu;


--Beginning of the architecture

architecture alu_arch of alu is 

signal x,y: std_logic_vector (31 downto 0);
signal result: std_logic_vector (31 downto 0);
signal x_y_logic : std_logic_vector (31 downto 0);
 
begin

-- logic unit 

process (logic_func, x_in, y_in, x_y_logic)
begin 

if (logic_func = "00") then 
    x_y_logic <= x_in AND y_in;

elsif (logic_func = "01") then 
    x_y_logic <= x_in OR y_in;

elsif (logic_func = "10") then
    x_y_logic <= x_in XOR y_in;

else 
x_y_logic <= x_in XNOR y_in;

end if;
end process;
--end of the logic unit


-- adder substract unit

process (add_sub, x_in, y_in,result)
begin 

 if (add_sub = '1') then

    result <= x_in - y_in; 

    overflow  <= (not x_in(31) and y_in(31) and  result(31)) or (x_in(31) and not y_in(31) and not result(31));

else 
     result <= x_in + y_in;

     overflow <= (not x_in(31) and not y_in(31) and result(31)) or (x_in(31) and y_in(31) and not  result(31));
    
    end if;
    end process;

--end of the adder-substract unit



--checking if the result gives out null (zero unit)
process (result)
 begin 
       if (result = "00000000000000000000000000000000") then 
        zero <= '1';      else 
         zero <= '0';
end if;
end process;


-- function unit last part

process (func, y_in, result, x_y_logic)
begin 

case func is 
          when "00" =>
             output_out <= y_in;
          when "01" =>
             output_out <= "0000000000000000000000000000000" & result(31);
          when "10" =>
              output_out <= result;
          when others =>
              output_out <= x_y_logic;
end case;
end process;


end alu_arch;

--end of the architecture


