---
 -- Copyright (c) 2019 Sean Stasiak. All rights reserved.
 -- Developed by: Sean Stasiak <sstasiak@protonmail.com>
 -- Refer to license terms in license.txt; In the absence of such a file,
 -- contact me at the above email address and I can provide you with one.
---

library ieee;
use ieee.std_logic_1164.all,
    ieee.numeric_std.all;

entity mm_tb is
  generic( tclk : time := 10 ns;
           TPD  : time := 1  ns );
end entity;

architecture dfault of mm_tb is

  component mm is
    generic( constant CLKIN_RATE : integer := 100E6 );
    port( clk_in    : in  std_logic;
          srst_in   : in  std_logic;
          data_line : in  std_logic;
          button    : in  std_logic;
          led       : out std_logic;
          servo     : out std_logic );
  end component;

  constant WAITCLK   : integer := 2;
  signal   clkcnt    : natural := 0;
  signal   dclkcnt   : natural := 0;
  signal   clk, dclk : std_logic;

  signal srst : std_logic;
  signal data_line, button, led, servo : std_logic;

begin

  dut : mm
    port map( clk_in    => clk,
              srst_in   => srst,
              data_line => data_line,
              button    => button,
              led       => led,
              servo     => servo );

  tb : process
  begin

    wait for 1*tclk;
    srst <= '1';
    wait until clk = '1';
    wait for (1*tclk)/4;
    srst <= '0';
    button <= '0';
    data_line <= '0';

    wait for 10*tclk;
    assert led = '0' report "FAIL0.0 : initial conditions";

    -- here: look to waveform to verify servo pwidth is 1ms

    wait until dclkcnt = 50*1000;
    wait for 10*tclk;
    button <= '1';                     --< start!


    wait until dclkcnt = 60*1000;      --< drive sequence
    wait for 10*tclk;
    data_line <= '1';

    wait until dclk = '1';
    wait for 10*tclk;
    data_line <= '0';

    wait until dclk = '1';
    wait for 10*tclk;
    data_line <= '1';

    wait until dclk = '1';
    wait for 10*tclk;
    data_line <= '0';

    wait until dclk = '1';
    wait for 10*tclk;
    data_line <= '0';

    wait until dclk = '1';
    wait for 10*tclk;
    data_line <= '0';

    wait until dclk = '1';
    wait for 10*tclk;
    data_line <= '0';

    wait until dclk = '1';
    wait for 10*tclk;
    data_line <= '1';

    wait until dclk = '1';
    wait for 10*tclk;
    data_line <= '0';

    wait until dclk = '1';
    wait for 10*tclk;
    data_line <= '1';

    wait until dclk = '1';
    wait for 10*tclk;
    data_line <= '0';

    wait until dclk = '1';
    wait for 10*tclk;
    data_line <= '0';

    wait until dclk = '1';
    wait for 10*tclk;
    data_line <= '0';

    wait until dclk = '1';
    wait for 10*tclk;
    data_line <= '0';

    wait until dclk = '1';
    wait for 10*tclk;
    data_line <= '0';

    wait until dclk = '1';
    wait for 10*tclk;
    data_line <= '0';

    wait until dclk = '1';
    wait for 10*tclk;
    data_line <= '1';

    -- here: look to waveform to verify servo pwidth is 1.5ms
    --       upon start of next 20ms period

    wait until dclkcnt = 128*1000;
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

  dataclk : process
  begin
    dclk <= '0';
    loop
      wait for ((100E6/2E6)-2)*tclk;
      wait until clk = '1'; wait for (1*tclk)/10;
      dclk <= not(dclk); dclkcnt <= dclkcnt +1;
      wait for 1*tclk;
      dclk <= not(dclk);
    end loop;
  end process;

end architecture;
