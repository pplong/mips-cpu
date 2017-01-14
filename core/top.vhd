library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;

library UNISIM;
use UNISIM.VComponents.all;

entity top is
  port (
    mclk1 : in std_logic;
    rs_tx : out std_logic;
    rs_rx : in std_logic;
    
    ZD : inout std_logic_vector(31 downto 0);
    ZDP : inout std_logic_vector(3 downto 0);
    ZA : out std_logic_vector(19 downto 0);
    XWA : out std_logic;
    
    ZCLKMA : out std_logic_vector(1 downto 0);

    -- DAC
    XLDAC : out std_logic;
    XCS : out std_logic;
    SCK : out std_logic;
    SDI : out std_logic;
    -- DAC

    -- FIXED
    XE1 : out std_logic;
    E2A : out std_logic;
    XE3 : out std_logic;
    XZBE : out std_logic_vector(3 downto 0);
    XGA : out std_logic;
    XZCKE : out std_logic;
    
    ADVA : out std_logic;
    XFT : out std_logic;
    XLBO : out std_logic;
    ZZA : out std_logic
    -- FIXED
  );
end top;

architecture Behavioral of top is
  -------------------------------
  ---         SIGNALS         ---
  -------------------------------

  -- clock
  signal clk, iclk : std_logic;
  
  -- cpu state
  signal cpu_state : std_logic_vector(2 downto 0) := "000";

  -- read program
  signal program_size_read : std_logic_vector (2 downto 0) := "000";
  signal program_size : std_logic_vector (31 downto 0);
  signal program_read : std_logic_vector (31 downto 0);
  signal program_word_read : std_logic_vector (2 downto 0) := "000";
  signal program_word : WORD;

  -- execution
  signal exec_state : integer range 0 to 31 := 0;
  signal exec_start : std_logic := '0';
  signal instruction : WORD;
  signal prev_instruction : WORD;
  signal branching : std_logic := '0';

  -- decode instruction
  signal opcode : std_logic_vector (5 downto 0);
  signal rs : REG;
  signal rt : REG;
  signal rd : REG;
  signal shamt : std_logic_vector (4 downto 0);
  signal funct : std_logic_vector (5 downto 0);
  signal immediate : std_logic_vector (15 downto 0);

  -------------------------------
  ---        COMPONENTS       ---
  -------------------------------

  -- RS232C
  component rs232c_read
    generic (
      wtime : std_logic_vector(15 downto 0) := x"1C06";
      sampling_interval : std_logic_vector(15 downto 0) := x"0708"
    );
    port (
      clk : in std_logic;
      rx : in std_logic;
      read_complete : in std_logic;

      data_out : out std_logic_vector (7 downto 0);
      has_data : out std_logic
    );
  end component;
  signal read_complete : std_logic := '0';
  signal rs232c_read_data : BYTE;
  signal rs232c_has_data : std_logic := '0';

  component rs232c_write
    generic (
      wtime: std_logic_vector(15 downto 0) := x"1C06"
    );
    port (
      clk  : in std_logic;
      data : in std_logic_vector (7 downto 0);
      go   : in std_logic;
      busy : out std_logic;
      tx   : out std_logic
    );
  end component;
  signal rs232c_write_data : BYTE;
  signal rs232c_write_go : std_logic := '0';
  signal rs232c_write_busy : std_logic;
  signal rs232c_buf : WORD;

  -- Blcok RAM
  component block_ram
    port (
      clk : in std_logic;

      we : in std_logic;
      w_addr : in BLKRAM_ADDR;
      w_data : in WORD;

      r_addr : in BLKRAM_ADDR;
      r_data : out WORD
    );
  end component;
  signal blkram_we : std_logic;
  signal blkram_w_addr : BLKRAM_ADDR;
  signal blkram_w_data : WORD;
  signal blkram_r_addr : BLKRAM_ADDR;
  signal blkram_r_data : WORD;
  signal blkram_r_addr2 : BLKRAM_ADDR;
  signal blkram_r_addr2_latched : BLKRAM_ADDR;
  signal blkram_r_addr_mux : BLKRAM_ADDR;
  signal blkram_read2 : std_logic := '0';

  -- instruction decoder
  component decode
    port (
      pc : in BLKRAM_ADDR;

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
  end component;
  signal op_blocking_now : std_logic := '0';
  signal op_reg_write : std_logic;
  signal op_blocking : std_logic;
  signal op_block_type : std_logic_vector (2 downto 0);
  signal op_block_data : WORD;
  signal op_block_complete : std_logic := '0';
  signal op_jump_addr : BLKRAM_ADDR;
  signal op_branch_taken : std_logic := '0';
  signal op_freg_write : std_logic := '0';
  signal op_fpu : std_logic := '0';
  signal op_fpu_wait : unsigned(3 downto 0) := "0000";

  -- registers
  component pc
    port (
      clk : in std_logic;

      pc_next : in std_logic;
      pc_src : in std_logic;
      pc_nextvalue : in BLKRAM_ADDR;

      ptr : out BLKRAM_ADDR
    );
  end component;
  signal pc_next : std_logic;
  signal pc_src : std_logic;
  signal pc_nextvalue : BLKRAM_ADDR;
  signal pc_ptr : BLKRAM_ADDR;

  component regs
    port (
      clk : in std_logic;

      write_enable : in std_logic;
      write_reg : in std_logic_vector (4 downto 0);
      write_data : in std_logic_vector (31 downto 0);

      read_reg1 : in std_logic_vector (4 downto 0);
      read_reg2 : in std_logic_vector (4 downto 0);

      reg_data1 : out std_logic_vector (31 downto 0);
      reg_data2 : out std_logic_vector (31 downto 0)
    );
  end component;
  signal reg_write : std_logic := '0';
  signal reg_write_idx : REG := "00000";
  signal reg_write_data : WORD;
  signal reg_write_data_io : WORD;
  signal reg_write_data_mux : WORD;
  signal reg_read1 : REG := "00000";
  signal reg_read2 : REG := "00000";
  signal reg_data1 : WORD;
  signal reg_data2 : WORD;

  component fregs
    port (
      clk : in std_logic;

      write_enable : in std_logic;
      write_reg : in std_logic_vector (4 downto 0);
      write_data : in std_logic_vector (31 downto 0);

      read_reg1 : in std_logic_vector (4 downto 0);
      read_reg2 : in std_logic_vector (4 downto 0);

      reg_data1 : out std_logic_vector (31 downto 0);
      reg_data2 : out std_logic_vector (31 downto 0)
    );
  end component;
  signal freg_write : std_logic := '0';
  signal freg_write_or : std_logic := '0';
  signal freg_write_idx : REG := "00000";
  signal freg_write_data_1clk : WORD;
  signal freg_write_data : WORD;
  signal freg_write_data_io : WORD;
  signal freg_write_data_mux : WORD;
  signal freg_read1 : REG := "00000";
  signal freg_read2 : REG := "00000";
  signal freg_data1 : WORD;
  signal freg_data2 : WORD;

  -- ALU
  component alu
    port (
      data_in1 : in WORD;
      data_in2 : in WORD;
      data_out : out WORD;
      zero : out std_logic;

      op : in std_logic_vector(3 downto 0)
    );
  end component;
  signal alu_in1 : WORD;
  signal alu_in2 : WORD;
  signal alu_out : WORD;
  signal alu_flag_z : std_logic;

  component alu_control
    port (
      opcode : in std_logic_vector (5 downto 0);
      funct : in std_logic_vector (5 downto 0);

      op : out std_logic_vector (3 downto 0)
    );
  end component;
  signal alu_control_op : std_logic_vector (3 downto 0);

  -- FPU
  component fpu
    port (
      clk : in std_logic;

      data_in1 : in WORD;
      data_in2 : in WORD;
      data_out : out WORD;

      funct : in std_logic_vector (5 downto 0)
    );
  end component;
  signal fpu_in1 : WORD;
  signal fpu_in2 : WORD;
  signal fpu_out : WORD;
  signal fpu_wait : unsigned (3 downto 0);

  -- Prescaler
  component prescaler is
    port (
      clk : in std_logic;
      iclk : out std_logic
    );
  end component;
  signal dac_clk : std_logic;

  -- DAC
  component dac
    port (
      clk : in std_logic;
      data : in std_logic_vector(11 downto 0);
      go : in std_logic;
      busy : out std_logic;

      XLDAC : out std_logic;
      XCS : out std_logic;
      SDI : out std_logic
    );
  end component;
  signal dac_go : std_logic := '0';
  signal dac_busy : std_logic := '0';

  signal dac_data : std_logic_vector(11 downto 0) :=
    "111111111111";

  -- Synthesizer
  component synthesizer
    port (
      clk : in std_logic;
      synth_instr : in WORD;

      wave : out WAV
    );
  end component;
  signal synth_data : WORD := (others => '1');
begin
  -- ?
  ZCLKMA(0) <= clk;
  ZCLKMA(1) <= clk;

  -- FIXED
  XE1 <= '0';
  E2A <= '1';
  XE3 <= '0';
  XGA <= '0';
  XZCKE <= '0';
  ADVA <= '0';
  XLBO <= '1';
  ZZA <= '0';
  XFT <= '1';
  XZBE <= "0000";
  -- FIXED

--  clk <= mclk1;
  ib: IBUFG port map (
    i => mclk1,
    o => iclk
  );
  bg: BUFG port map (
    i => iclk,
    o => clk
  );

  -- RS232C
  rs232c_read_map: rs232c_read port map (
    clk => clk,
    rx => rs_rx,
    read_complete => read_complete,
    data_out => rs232c_read_data,
    has_data => rs232c_has_data
  );

  rs232c_write_map: rs232c_write port map (
    clk => clk,
    data => rs232c_write_data,
    go => rs232c_write_go,
    busy => rs232c_write_busy,
    tx => rs_tx
  );

  -- Block RAM
  block_ram_map: block_ram port map (
    clk => clk,
    we => blkram_we,
    w_addr => blkram_w_addr,
    w_data => blkram_w_data,
    r_addr => blkram_r_addr_mux,
    r_data => blkram_r_data
  );
  blkram_r_addr_mux <= blkram_r_addr when blkram_read2 = '0' else blkram_r_addr2_latched;

  -- registers
  pc_map: pc port map (
    clk => clk,
    pc_next => pc_next,
    pc_src => pc_src,
    pc_nextvalue => pc_nextvalue,
    ptr => pc_ptr
  );

  regs_map: regs port map (
    clk => clk,
    
    write_enable => reg_write,
    write_reg => reg_write_idx,
    write_data => reg_write_data_mux,

    read_reg1 => reg_read1,
    read_reg2 => reg_read2,
    reg_data1 => reg_data1,
    reg_data2 => reg_data2
  );
  reg_write_data_mux <= reg_write_data when exec_state = 0 else
                        reg_write_data_io;

  fregs_map: fregs port map (
    clk => clk,

    write_enable => freg_write_or,
    write_reg => freg_write_idx,
    write_data => freg_write_data_mux,

    read_reg1 => freg_read1,
    read_reg2 => freg_read2,
    reg_data1 => freg_data1,
    reg_data2 => freg_data2
  );
  freg_write_or <= (not branching) and ((not op_blocking) or freg_write) and op_freg_write;
  freg_write_data_mux <= freg_write_data when exec_state = 12 or exec_state = 13 else
                         freg_write_data_1clk when exec_state = 0 else
                         freg_write_data_io;

  -- ALU
  alu_map: alu port map (
    data_in1 => alu_in1,
    data_in2 => alu_in2,
    data_out => alu_out,
    zero => alu_flag_z,
    op => alu_control_op
  );

  alu_control_map: alu_control port map (
    opcode => opcode,
    funct => funct,
    op => alu_control_op
  );

  -- FPU
  fpu_map: fpu port map (
    clk => clk,

    data_in1 => fpu_in1,
    data_in2 => fpu_in2,
    data_out => fpu_out,

    funct => funct
  );

  -- decoder
  decode_map: decode port map (
    pc => pc_ptr,

    instruction => instruction,
    opcode => opcode,
    rs => rs,
    rt => rt,
    rd => rd,
    shamt => shamt,
    funct => funct,
    immediate => immediate,

    reg_read1 => reg_read1,
    reg_read2 => reg_read2,
    reg_data1 => reg_data1,
    reg_data2 => reg_data2,
    reg_write_idx => reg_write_idx,
    reg_write_data => reg_write_data,
    alu_in1 => alu_in1,
    alu_in2 => alu_in2,
    alu_out => alu_out,

    freg_read1 => freg_read1,
    freg_read2 => freg_read2,
    freg_data1 => freg_data1,
    freg_data2 => freg_data2,
    freg_write_idx => freg_write_idx,
    freg_write_data => freg_write_data_1clk,
    fpu_in1 => fpu_in1,
    fpu_in2 => fpu_in2,
    fpu_op => op_fpu,
    fpu_wait => op_fpu_wait,

    jump_addr => op_jump_addr,
    branch_taken => op_branch_taken,

    blkram_read_addr => blkram_r_addr2,

    freg_write => op_freg_write,
    reg_write => op_reg_write,

    blocking => op_blocking,
    block_op_type => op_block_type,
    block_op_data => op_block_data
  );

  -- Synth
  prescaler_map: prescaler port map (
    clk => clk,
    iclk => dac_clk
  );

  dac_map: dac port map (
    clk => dac_clk,
    data => dac_data,
    -- data => std_logic_vector(counter(16 downto 5)),
    go => dac_go,
    busy => dac_busy,

    XLDAC => XLDAC,
    XCS => XCS,
    SDI => SDI
  );

  dac_go <= not dac_busy;
  SCK <= dac_clk;

  synthesizer_map: synthesizer port map (
    clk => clk,
    synth_instr => synth_data,
    wave => dac_data
  );

  --------------------------
  --- decode instruction ---
  --------------------------
  blkram_r_addr <= pc_ptr;
  instruction <= prev_instruction when op_blocking_now = '1' else blkram_r_data;
  pc_next <= '1' when exec_state = 6 else
             exec_start or ((not op_blocking) or op_block_complete) when cpu_state = "011" else '0';
  reg_write <= (not branching) and ((not op_blocking) or op_block_complete) and op_reg_write when cpu_state = "011" else '0';
  pc_src <= op_branch_taken and (not branching);
  pc_nextvalue <= op_jump_addr;
  ZA <= alu_out(19 downto 0);

  --------------------
  --- read program ---
  --------------------
  statemachine: process(clk)
  begin
    if rising_edge(clk) then
      case cpu_state is
        -- wait for program input
        when "000" =>
          if rs232c_has_data = '1' then
            program_size_read <= "000";
            cpu_state <= std_logic_vector(unsigned(cpu_state) + 1);
          end if;

        -- read program size
        when "001" =>
          if program_size_read = "100" then
            read_complete <= '0';
            cpu_state <= std_logic_vector(unsigned(cpu_state) + 1);
            program_read <= x"00000000";
          elsif rs232c_has_data = '1' and read_complete = '0' then
            read_complete <= '1';
            program_size <= program_size(23 downto 0) & rs232c_read_data;
            program_size_read <= std_logic_vector(unsigned(program_size_read) + 1);
          else
            read_complete <= '0';
          end if;

        -- read program
        when "010" =>
          if program_read = program_size then
            read_complete <= '0';
            blkram_we <= '0';
            cpu_state <= std_logic_vector(unsigned(cpu_state) + 1);
            exec_start <= '1';
          elsif program_word_read = "100" then
            read_complete <= '0';
            blkram_we <= '1';
            blkram_w_addr <= program_read(14 downto 0);
            blkram_w_data <= program_word;
            program_read <= std_logic_vector(unsigned(program_read) + 1);
            program_word_read <= "000";
          elsif rs232c_has_data = '1' and read_complete = '0' then
            read_complete <= '1';
            program_word <= program_word(23 downto 0) & rs232c_read_data;
            program_word_read <= std_logic_vector(unsigned(program_word_read) + 1);
          else 
            read_complete <= '0';
          end if;

        when "011" =>
          exec_start <= '0';
          if op_blocking_now = '0' then
            prev_instruction <= instruction;
          end if;
          if exec_state /= 6 then
            op_blocking_now <= op_blocking and (not op_block_complete);
          end if;
          if opcode = "111111" then
            synth_data <= reg_data1;
          else
            synth_data <= (others => '1');
          end if;

          case exec_state is
            -- execute
            when 0 =>
              if op_blocking = '1' then
                rs232c_buf <= op_block_data;
                case op_block_type is
                  when "000" => exec_state <= 1;
                  when "001" => exec_state <= 3;
                  when "010" => -- sw
                    XWA <= '0';
                    ZD <= op_block_data;
                    ZDP <= "0000";
                    exec_state <= 7;
                  when "011" =>
                    XWA <= '1';
                    ZD <= (others => 'Z');
                    ZDP <= "ZZZZ";
                    exec_state <= 9; -- lw
                  when "100" => -- fpu
                    fpu_wait <= op_fpu_wait;
                    exec_state <= 12;
                  when "101" => -- load float from blkram
                    blkram_read2 <= '1';
                    blkram_r_addr2_latched <= blkram_r_addr2;
                    exec_state <= 14;
                  when "110" => -- synth
                    exec_state <= 17;
                  when others => null;
                end case;
              end if;
              if op_branch_taken = '1' then
                branching <= '1';
                exec_state <= 6;
              end if;

            -- RS232C read
            when 1 =>
              if rs232c_has_data = '1' and read_complete = '0' then
                read_complete <= '1';
                reg_write_data_io <= rs232c_buf(31 downto 8) & rs232c_read_data;
                exec_state <= 2;
                op_block_complete <= '1';
              end if;
            when 2 =>
              read_complete <= '0';
              op_block_complete <= '0';
              exec_state <= 0;

            -- RS232C write
            when 3 =>
              if rs232c_write_busy = '0' and rs232c_write_go = '0' then
                rs232c_write_go <= '1';
                rs232c_write_data <= rs232c_buf(7 downto 0);
                exec_state <= 4;
              end if;
            when 4 =>
              rs232c_write_go <= '0';
              op_block_complete <= '1';
              exec_state <= 5;
            when 5 =>
              op_block_complete <= '0';
              exec_state <= 0;

            -- branch taken
            when 6 =>
              branching <= '0';
              exec_state <= 0;

            -- SRAM store
            when 7 =>
              XWA <= '1';
              op_block_complete <= '1';
              exec_state <= 8;
            when 8 =>
              op_block_complete <= '0';
              exec_state <= 0;

            -- SRAM load
            when 9 =>
              exec_state <= 10;
            when 10 =>
              if prev_instruction(31 downto 26) = "110001" then
                freg_write <= '1';
                freg_write_data_io <= ZD;
              else
                reg_write_data_io <= ZD;
              end if;
              op_block_complete <= '1';
              exec_state <= 11;
            when 11 =>
              freg_write <= '0';
              op_block_complete <= '0';
              exec_state <= 0;

            -- FPU wait
            when 12 =>
              if fpu_wait = 0 then
                freg_write <= '1';
                freg_write_data <= fpu_out;
                exec_state <= 13;
                op_block_complete <= '1';
              else
                fpu_wait <= fpu_wait - 1;
              end if;
            when 13 =>
              op_block_complete <= '0';
              freg_write <= '0';
              exec_state <= 0;

            -- load from blockRAM
            when 14 =>
              exec_state <= 15;
            when 15 =>
              if op_block_data(5 downto 0) = "100100" then
                reg_write_data_io <= blkram_r_data;
              else
                freg_write <= '1';
                freg_write_data_io <= blkram_r_data;
              end if;
              exec_state <= 16;
              blkram_read2 <= '0';
              op_block_complete <= '1';
            when 16 =>
              op_block_complete <= '0';
              freg_write <= '0';
              exec_state <= 0;

            -- synth
            when 17 =>
              synth_data <= op_block_data;
              op_block_complete <= '1';
              exec_state <= 18;
            when 18 =>
              op_block_complete <= '0';
              exec_state <= 0;

            when others =>
              null;
          end case;
        when others =>
      end case;
    end if;
  end process;
end Behavioral;

