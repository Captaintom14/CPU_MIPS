library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity next_address is 
port (
-- inputs 
rt, rs : in std_logic_vector (31 downto 0);
pc : in std_logic_vector (31 downto 0);
target_address : in std_logic_vector (25 downto 0);
branch_type : in std_logic_vector (1 downto 0);
pc_sel : in std_logic_vector (1 downto 0);

-- outputs 
next_pc : out std_logic_vector (31 downto 0));

end next_address;


architecture arch_NA of next_address is 

signal new_pc : std_logic_vector(31 downto 0);
signal outPC: std_logic_vector (31 downto 0);


begin 

-- branch type functionality 

process (branch_type, rs, rt,pc)

begin 

if (branch_type = "01") then 

   if (rs = rt) then
    new_pc <= pc + X"00000001" + ((31 downto 16 => target_address(15)) & target_address(15 downto 0)); 
    else
         new_pc <= pc + X"00000001";
    end if;


elsif (branch_type = "10") then

      if (rs /= rt) then
    new_pc <= pc + X"00000001" + ((31 downto 16 => target_address(15)) & target_address(15 downto 0));
      else
         new_pc <= pc + X"00000001"; 
      end if;

elsif (branch_type = "11") then

      if (rs < 0)then 
    new_pc <= pc + X"00000001" + ((31 downto 16 => target_address(15)) & target_address(15 downto 0)); 
      else 
          new_pc <= pc + X"00000001";
      end if;

else

     new_pc <= pc + X"00000001";


end if;
end process;


-- pc sel functionality

process (pc_sel, new_pc,pc)
begin 

if (pc_sel = "00") then 
     outPC <= new_pc;

elsif (pc_sel = "01") then
     outPC <= "000000" & target_address(25 downto 0);

elsif (pc_sel = "10") then
     outPC <= rs;
else 
     outPC <= pc;
end if;
end process;

next_pc <= outPC;

end arch_NA;













