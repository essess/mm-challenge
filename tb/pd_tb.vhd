---
 -- Copyright (c) 2019 Sean Stasiak. All rights reserved.
 -- Developed by: Sean Stasiak <sstasiak@protonmail.com>
 -- Refer to license terms in license.txt; In the absence of such a file,
 -- contact me at the above email address and I can provide you with one.
---

library ieee;
use ieee.std_logic_1164.all,
    ieee.numeric_std.all;

entity pd_tb is
  generic( tclk : time := 10 ns;
           TPD  : time := 1  ns;
           CLKIN_RATE    : natural := 100E6;
           SAMPLENB_RATE : natural := 2E6 );
end entity;

architecture dfault of pd_tb is

  component pd is
    generic( CLKIN_RATE : positive;       --< clk_in rate
             ENB_RATE   : positive;       --< samplenb_in rate
             TPD        : time := 0 ns );
    port( clk_in       : in  std_logic;
          srst_in      : in  std_logic;
          samplenb_in  : in  std_logic;   --< data stream sample clk/enb
          data_in      : in  std_logic;   --< preamble data stream
          start_in     : in  std_logic;   --< begin detection of sequence
          detected_out : out std_logic;   --< sequence detected flag
          ip_out       : out std_logic ); --< sequence detection in-progress flag
  end component;

  constant WAITCLK : integer := 2;
  signal   clkcnt  : natural := 0;
  signal   enbcnt  : natural := 0;
  signal   clk     : std_logic;

  signal srst : std_logic;
  signal enb, data, start, detected, ip : std_logic;

begin

  dut : pd
    generic map( CLKIN_RATE => CLKIN_RATE,
                 ENB_RATE   => SAMPLENB_RATE,
                 TPD        => TPD )
    port map( clk_in       => clk,
              srst_in      => srst,
              samplenb_in  => enb,
              data_in      => data,
              start_in     => start,
              detected_out => detected,
              ip_out       => ip );

  tb : process
  begin

    wait for 1*tclk;
    srst <= '1';
    data <= '0';
    start <= '0';
    wait until clk = '1';
    wait for (1*tclk)/4;
    srst <= '0';

    ---------------------------------------

    wait until enbcnt = 4;
    wait until clk = '1';
    wait for (1*tclk)/4;
    start <= '1';

    -- start is a special case of the state machine where
    -- we immediately assert ip_out on next clk_in edge ....
    -- after all, we are 'starting' our preamble search
    -- RIGHT NOW

    wait for 4*tclk;
    assert ip report "pd did not start!" severity failure;

  -- start best case sequence and test for detect

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until detected;

    assert enbcnt = 22 report "nothing detected!" severity failure;

    -- we never deasserted start either, so we
    -- should have stayed 'in progress' also
    assert ip report "not in progress!" severity failure;

    start <= '0';
    data <= '0';

    wait for 10*tclk;

    ---------------------------------------
    -- exception 1  -   1010101010.... in first 'chunk'

    wait until enb = '1';
    wait for 10*tclk;
    srst <= '1';
    data <= '0';
    wait for 2*tclk;
    srst <= '0';
    start <= '1';


    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';


    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until detected;

    assert enbcnt = 47 report "nothing detected!" severity failure;

    ---------------------------------------
    -- exception 2  -   1010101010.... in 2nd 'chunk' - reset from start ?

    wait until enb = '1';
    wait for 10*tclk;
    srst <= '1';
    data <= '0';
    wait for 2*tclk;
    srst <= '0';
    start <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until detected;
    assert enbcnt = 83 report "nothing detected!" severity failure;

    ---------------------------------------
    -- exception 3  - repeated 2nd chunk, but doesn't unnecessarily restart
    --                at 1st chunk

    wait until enb = '1';
    wait for 10*tclk;
    srst <= '1';
    data <= '0';
    wait for 2*tclk;
    srst <= '0';
    start <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '0';

    wait until enb = '1';
    wait for 10*tclk;
    data <= '1';

    wait until detected;

    assert enbcnt = 116 report "nothing detected!" severity failure;

    ---------------------------------------

--  takes a LONG time to run ~100E6 tclk's -> about
--  4hrs if 100E3 tclk's take 15s
--
--  the wave.vcd file is ~13G 18 minutes in .. will
--  run out of disk space anyways ...
--
--  check that hold state is 10s:
--  wait until enbcnt =  (10*SAMPLENB_RATE) +enbcnt;

    -- move to real hardware to test HOLD state

    wait for 10*tclk;
    report "DONE"; std.env.stop;
  end process;

  sysclk : process
  begin
    wait for WAITCLK*tclk;
    loop
      clk <= '0'; wait for tclk/2;
      clk <= '1'; clkcnt <= clkcnt +1;
                  wait for tclk/2;
    end loop;
  end process;

  enbclk : process
  begin
    enb <= '0';
    loop
      wait for ((CLKIN_RATE/SAMPLENB_RATE)-2)*tclk;
      wait until clk = '1'; wait for (1*tclk)/10;
      enb <= not(enb); enbcnt <= enbcnt +1;
      wait for 1*tclk;
      enb <= not(enb);
    end loop;
  end process;

end architecture;
