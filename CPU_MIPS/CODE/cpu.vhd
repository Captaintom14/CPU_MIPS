library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity cpu1 is port (

-- inputs
        reset_cpu : in std_logic;
        clk_cpu : in std_logic;

--outputs
        rs_out, rt_out, pc_out : out std_logic_vector(3 downto 0);

        overflow_cpu, zero_cpu : out std_logic);

end cpu1;

architecture cpu_arch of cpu1 is


-- declaring pc_reg component

    component pc_reg port (
        d_in : in std_logic_vector (31 downto 0);
        reset,clk : in std_logic;
        q_out : out std_logic_vector (31 downto 0));
end component;

-- declaring iCache component

component iCache port (
    input_address: in std_logic_vector (4 downto 0);
    data: out std_logic_vector (31 downto 0));
end component;

-- declaring next_address component
component next_address port (
   
    rt, rs : in std_logic_vector (31 downto 0);
    pc : in std_logic_vector (31 downto 0);
    target_address : in std_logic_vector (25 downto 0);
    branch_type : in std_logic_vector (1 downto 0);
    pc_sel : in std_logic_vector (1 downto 0);
    next_pc : out std_logic_vector (31 downto 0));
end component;

-- declaring reg_file component
component regfile port (
    din : in std_logic_vector(31 downto 0);
    reset, clk, write : in std_logic;
    read_a, read_b, write_address : in std_logic_vector (4 downto 0);
    out_a, out_b : out std_logic_vector (31 downto 0));
end component;

-- declaring sign_extension component
component sign_extension port (

    bits : in std_logic_vector (15 downto 0);
    func : in std_logic_vector (1 downto 0);
    output : out std_logic_vector (31 downto 0));
end component;

-- declaring alu component
component alu port(
   
    x_in, y_in : in std_logic_vector (31 downto 0);
    add_sub : in std_logic;
    logic_func : in std_logic_vector (1 downto 0);
    func: in std_logic_vector (1 downto 0);
    output_out : out std_logic_vector (31 downto 0);
    overflow : out std_logic;
    zero : out std_logic);
end component;

-- declaring dCache
component dCache port (
    d_in : in std_logic_vector (31 downto 0);
    clk : in std_logic;
    reset : in std_logic;
    data_write : in std_logic;
    address : in std_logic_vector (4 downto 0);
    d_out : out std_logic_vector (31 downto 0));
end component;








--declaring the port maps

for PC_R : pc_reg use entity WORK.pc_reg(arch_pc);
for I_Cache : iCache use entity WORK.iCache(arch_iCache);
for N_A : next_address use entity WORK.next_address (arch_NA);
for REGFILE_P : regfile use entity WORK.regfile(arch_reg);
for SIGN_EX : sign_extension use entity WORK.sign_extension(arch_sign);
for ALU_P : alu use entity WORK.alu(alu_arch);
for D_Cache : dCache use entity WORK.dCache(arch_dCache);



--declaring the signal inputs
signal ALU_input, reg_input : std_logic_vector (31 downto 0);
signal reg_addr : std_logic_vector (4 downto 0);

--declaring the signal outputs
signal pc_output, next_pc_output, iCache_output, dCache_output, out_A_S, out_B_S, ALU_output, SIGNX_output  : std_logic_vector (31 downto 0);

--declaring the control signals
signal logic_funct, funct, BR_type, PC_S : std_logic_vector (1 downto 0);
signal reg_write, reg_dst, reg_in_src, alu_src, A_S, D_W : std_logic;
signal control : std_logic_vector (13 downto 0);


-- declaring the Opcode and function fields
signal OP, FUNC : std_logic_vector (5 downto 0);


begin

-- implementation of the control unit

    process (OP,FUNC,control,iCache_output)
    begin
        OP <= iCache_output (31 downto 26);
        FUNC <= iCache_output (5 downto 0);
       
        if (OP = "000000") then
           
            if (FUNC = "100000") then
                control <= "11100000100000"; --add instruction
               
            elsif (FUNC = "100010") then
                control <= "11101000100000"; --sub instruction
               
            elsif (FUNC = "101010") then
                control <= "11100000010000"; --slt instruction
               
            elsif (FUNC = "100100") then
                control <= "11101000110000"; --and instruction
               
            elsif (FUNC = "100101") then
                control <= "11100001110000"; --or instruction
               
            elsif (FUNC = "100110") then
                control <= "11100010110000"; --xor instruction
               
            elsif (FUNC = "100111") then
                control <= "11100011110000"; --nor instruction
               
            elsif (FUNC = "001000") then
                control <= "00000000000010"; --jr instruction
               
            end if;
           
        elsif (OP = "001111") then
            control <= "10110000000000"; --lui instruction
       
        elsif (OP = "001000" ) then
            control <= "10110000100000"; --addi instruction
           
        elsif (OP = "001010") then
            control <= "10110000010000"; --slti instruction
           
        elsif (OP = "001100") then
            control <= "10110000110000"; --andi instruction
           
        elsif (OP = "001101") then
            control <= "10110001110000"; --ori instruction
           
        elsif (OP = "001110") then
            control <= "10110010110000"; --xori instruction
           
        elsif (OP = "100011") then
            control <= "10010010100000"; --lw instruction
           
        elsif (OP = "101011") then
            control <= "00010100100000"; --sw instruction
           
        elsif (OP = "000010") then
            control <= "00000000000001"; --j instruction
           
        elsif (OP = "000001") then
            control <= "00000000001100"; --bltz instruction
           
        elsif (OP = "000100") then
            control <= "00000000000100"; --beq instruction
           
        elsif (OP = "000101") then
            control <= "00000000001000"; --bne instruction
           
        end if;
       
        reg_write <= control(13);
       
        reg_dst <= control(12);
       
        reg_in_src <= control(11);
       
        alu_src <= control(10);
       
        A_S <= control(9);
       
        D_W <= control(8);
       
        logic_funct <= control(7 downto 6);
       
        funct <= control (5 downto 4);
       
        BR_type <= control (3 downto 2);
       
        PC_S <= control (1 downto 0);
       
    end process;



PC_R : pc_reg port map (d_in => next_pc_output, reset => reset_cpu, clk => clk_cpu, q_out => pc_output);
------------------------------------------------------------------

I_Cache : iCache port map (input_address => pc_output (4 downto 0), data => iCache_output);

---------------------------------------------------------------------
N_A : next_address port map(rt => out_B_S, rs => out_A_S, pc => pc_output, target_address => iCache_output(25 downto 0), branch_type => BR_type, pc_sel => PC_S, next_pc => next_pc_output);

-----------------------------------------------------------------------
REGFILE_P : regfile port map(din => reg_input, reset => reset_cpu, clk => clk_cpu, write => reg_write, read_a => iCache_output(25 downto 21), read_b => iCache_output (20 downto 16), write_address => reg_addr, out_a => out_A_S, out_b => out_B_S);

-----------------------------------------------------------------------
SIGN_EX : sign_extension port map(bits => iCache_output(15 downto 0), func => funct, output => SIGNX_output);

------------------------------------------------------------------------------
ALU_P : alu port map(x_in => out_A_S, y_in => ALU_input, add_sub => A_S, logic_func => logic_funct, func => funct, output_out => ALU_output, overflow => overflow_cpu, zero => zero_cpu);


D_Cache : dCache port map (d_in => out_B_S, clk => clk_cpu, reset => reset_cpu, address => ALU_output(4 downto 0), data_write => D_W, d_out => dCache_output);



-- multiplexer for the reg_dst

reg_addr <= iCache_output (15 downto 11) when (reg_dst = '1') else 
            iCache_output (20 downto 16) when (reg_dst = '0');

-- multiplexer for the alu_src

ALU_input <= SIGNX_output when (alu_src = '1') else
             out_B_S when (alu_src = '0');

-- multiplexer for the reg_in_src
reg_input <= ALU_output when (reg_in_src = '1') else 
         dCache_output when (reg_in_src = '0');


rs_out <= (out_A_S(3 downto 0));
rt_out <= (out_B_S (3 downto 0));
pc_out <= (pc_output (3 downto 0));


end cpu_arch;









