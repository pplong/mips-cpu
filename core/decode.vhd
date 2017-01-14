library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;

entity decode is
  port (
    pc : in BLKRAM_ADDR; -- PC+1

    instruction : in WORD;

    opcode : out std_logic_vector (5 downto 0);
    rs : out REG;
    rt : out REG;
    rd : out REG;
    shamt : out std_logic_vector (4 downto 0);
    funct : out std_logic_vector (5 downto 0);
    immediate : out std_logic_vector (15 downto 0);

    reg_read1 : out REG;
    reg_read2 : out REG;
    reg_data1 : in WORD;
    reg_data2 : in WORD;
    reg_write_idx : out REG;
    reg_write_data : out WORD;
    alu_in1 : out WORD;
    alu_in2 : out WORD;
    alu_out : in WORD;

    freg_read1 : out REG;
    freg_read2 : out REG;
    freg_data1 : in WORD;
    freg_data2 : in WORD;
    freg_write_idx : out REG;
    freg_write_data : out WORD;
    fpu_in1 : out WORD;
    fpu_in2 : out WORD;
    fpu_op : out std_logic;
    fpu_wait : out unsigned (3 downto 0);

    jump_addr : out BLKRAM_ADDR;
    branch_taken : out std_logic;

    blkram_read_addr : out BLKRAM_ADDR;

    freg_write : out std_logic;
    reg_write : out std_logic;

    blocking : out std_logic;
    block_op_type : out std_logic_vector (2 downto 0);
    block_op_data : out WORD
  );
end decode;

architecture Behavioral of decode is
begin
  dec: process(pc, instruction, reg_data1, reg_data2, alu_out,
               freg_data1, freg_data2)
    variable i_rs, i_rt, i_rd : REG;
    variable i_shamt : std_logic_vector (4 downto 0);
    variable i_opcode, i_funct : std_logic_vector (5 downto 0);
    variable i_immediate : std_logic_vector (15 downto 0);
    variable is_jr : boolean;

    variable fcmp_data1, fcmp_data2 : WORD;
  begin
    i_opcode := instruction(31 downto 26);
    i_rs := instruction(25 downto 21);
    i_rt := instruction(20 downto 16);
    i_rd := instruction(15 downto 11);
    i_shamt := instruction(10 downto 6);
    i_funct := instruction(5 downto 0);
    i_immediate := instruction(15 downto 0);
    is_jr := i_opcode = "000000" and i_funct = "001000";

    opcode <= i_opcode;
    rs <= i_rs;
    rt <= i_rt;
    rd <= i_rd;
    shamt <= i_shamt;
    funct <= i_funct;
    immediate <= i_immediate;

    -- integer regsiter: write enable
    if (i_opcode = "000001" and i_funct(0) = '1') or -- out
       i_opcode = "000010" or -- j
       is_jr or -- jr
       i_opcode = "000100" or i_opcode = "000101" or -- beq, bne
       i_opcode = "101011" or i_opcode = "111001" or i_opcode = "110001" or -- sw, swcl, lwcl
       i_opcode = "010001" or -- FPU
       i_opcode = "110010" or i_opcode = "110011" or i_opcode = "111111"
    then
      reg_write <= '0';
    else 
      reg_write <= '1';
    end if;

    -- floating point register: read
    freg_write <= '0';
    freg_read1 <= i_rd;
    freg_read2 <= i_rt;
    if i_opcode = "110001" or i_opcode = "110010" then -- lwcl, lwclc
      freg_write <= '1';
      freg_write_idx <= i_rt;
    else
      freg_write_idx <= i_shamt;
    end if;
    fpu_in1 <= freg_data1;
    fpu_in2 <= freg_data2;

    -- floating point move
    freg_write_data <= (others => '-');
    if i_opcode = "110011" then
      freg_write <= '1';
      freg_read1 <= i_rs;
      freg_write_idx <= i_rd;
      freg_write_data <= (freg_data1(31) xor i_funct(0)) & freg_data1(30 downto 0);
    end if;

    -- jump address
    if i_opcode = "000010" or i_opcode = "000011" then
      jump_addr <= instruction(14 downto 0);
    elsif is_jr then
      jump_addr <= reg_data1(14 downto 0);
    else
      jump_addr <= std_logic_vector(unsigned(pc) + unsigned(instruction(14 downto 0)));
    end if;

    -- integer register: read
    reg_read1 <= i_rs;
    if i_opcode = "000001" then
      reg_read2 <= i_rd;
    else 
      reg_read2 <= i_rt;
    end if;

    -- operation
    alu_in1 <= reg_data1;
    alu_in2 <= (others => '-');
    fpu_op <= '0';
    fpu_wait <= "0000";
    blkram_read_addr <= (others => '-');
    if i_opcode = "000000" or i_opcode = "000001" then -- R-form
      reg_write_idx <= i_rd;
      if i_funct = "000000" or i_funct = "000010" then
        alu_in2 <= (26 downto 0 => '0') & i_shamt;
      else
        alu_in2 <= reg_data2;
      end if;
      if is_jr then
        branch_taken <= '1';
      else 
        branch_taken <= '0';
      end if;
    elsif i_opcode = "000010" or i_opcode = "000011" then -- jump
      reg_write_idx <= "11111";
      branch_taken <= '1';
      alu_in2 <= (others => '-');
    elsif i_opcode = "000100" or i_opcode = "000101" then -- beq, bne
      reg_write_idx <= (others => '-');
      reg_read2 <= i_rt;
      if reg_data1 = reg_data2 then
        branch_taken <= not i_opcode(0);
      else
        branch_taken <= i_opcode(0);
      end if;
    elsif i_opcode = "100011" or i_opcode = "101011" or i_opcode = "100100" or -- load, store
          i_opcode = "110001" or i_opcode = "111001" or i_opcode = "110010" then -- float, l/s
      if i_opcode = "100011" or i_opcode = "100100" then
        reg_write_idx <= i_rt;
      else 
        reg_write_idx <= (others => '-');
      end if;
      reg_read2 <= i_rt;
      alu_in2 <= std_logic_vector(resize(signed(i_immediate), 32));
      branch_taken <= '0';
    elsif i_opcode = "010001" then -- FPU
      reg_write_idx <= (others => '-');
      alu_in2 <= (others => '-');
      branch_taken <= '0'; 
      freg_write <= '1';
      fpu_op <= '1';
    elsif i_opcode = "010010" then -- FP compare
      if freg_data1(31) = '1' and freg_data2(31) = '1' then
        fcmp_data1 := (not freg_data2(31)) & freg_data2(30 downto 0);
        fcmp_data2 := (not freg_data1(31)) & freg_data1(30 downto 0);        
      else
        fcmp_data1 := (not freg_data1(31)) & freg_data1(30 downto 0);
        fcmp_data2 := (not freg_data2(31)) & freg_data2(30 downto 0);
      end if;
      alu_in2 <= (others => '-');
      reg_write_idx <= i_shamt;
      branch_taken <= '0';
    else -- I-form
      reg_write_idx <= i_rt;
      if i_opcode = "001100" or i_opcode = "001101" then
        alu_in2 <= x"0000" & i_immediate;
      else
        alu_in2 <= std_logic_vector(resize(signed(i_immediate), 32));
      end if;
      branch_taken <= '0';
    end if;

    -- jump and link: link
    if i_opcode = "000011" then
      reg_write_data <= (31 downto 15 => '0') & pc;
    elsif i_opcode = "010010" then -- FP compare
      if (freg_data1(30 downto 23) = "11111111" and unsigned(freg_data1(22 downto 0)) /= 0) or
         (freg_data2(30 downto 23) = "11111111" and unsigned(freg_data2(22 downto 0)) /= 0) then
        reg_write_data <= (others => '0');
      elsif i_funct(0) = '0' then
        if unsigned(fcmp_data1) < unsigned(fcmp_data2) then
          reg_write_data <= (0 => '1', others => '0');
        else
          reg_write_data <= (others => '0');
        end if;
      else
        if fcmp_data1 = fcmp_data2 then
          reg_write_data <= (31 downto 1 => '0', 0 => '1');
        else
          reg_write_data <= (others => '0');
        end if;
      end if;
    else
      reg_write_data <= alu_out;
    end if;

    -- blocking?
    if i_opcode = "000001" or i_opcode = "101011" or i_opcode = "100011" or
       i_opcode = "111001" or i_opcode = "110001" or i_opcode = "110010" or
       i_opcode = "100100" or i_opcode = "111111" then
      blocking <= '1';
      if i_opcode = "000001" then
        if i_funct(0) = '0' then
          block_op_type <= "000";
          block_op_data <= reg_data2;
        else 
          block_op_type <= "001";
          block_op_data <= reg_data1;
        end if;
      elsif i_opcode = "111111" then
        block_op_type <= "110";
        block_op_data <= reg_data1;
      elsif i_opcode = "101011" then  -- sw
        block_op_type <= "010";
        block_op_data <= reg_data2;
      elsif i_opcode = "100011" then -- lw
        block_op_type <= "011";
        block_op_data <= (31 downto 5 => '0') & i_rt; 
      elsif i_opcode = "111001" then -- swcl
        block_op_type <= "010";
        block_op_data <= freg_data2;
      elsif i_opcode = "110001" then -- lwcl
        block_op_type <= "011";
        block_op_data <= (31 downto 5 => '0') & i_rt;
      else -- lwclc, lwc
        block_op_type <= "101";
        blkram_read_addr <= alu_out(14 downto 0);
        block_op_data <= (31 downto 6 => '0') & i_opcode;
      end if;
    elsif i_opcode = "010001" then -- FPU
      blocking <= '1';
      block_op_type <= "100";
      block_op_data <= (others => '-');
      if i_funct = "000000" then -- fadd
        fpu_wait <= "0010";
      elsif i_funct = "000001" then -- fsub
        fpu_wait <= "0010";
        fpu_in2 <= (not freg_data2(31)) & freg_data2(30 downto 0);
      elsif i_funct = "000010" then -- fmul
        fpu_wait <= "0010";
      else -- finv
        fpu_wait <= "1001";
      end if;
    else 
      blocking <= '0';
      block_op_type <= "---";
      block_op_data <= (others => '-');
    end if;
  end process;
end Behavioral;
