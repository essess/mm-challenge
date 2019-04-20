---
 -- Copyright (c) 2019 Sean Stasiak. All rights reserved.
 -- Developed by: Sean Stasiak <sstasiak@protonmail.com>
 -- Refer to license terms in license.txt; In the absence of such a file,
 -- contact me at the above email address and I can provide you with one.
---

library ieee;
use ieee.std_logic_1164.all,
    ieee.numeric_std.all;

entity sdb_tb is
  generic( tclk : time := 10 ns;
           TPD  : time := 1  ns;
           CLKIN_RATE    : natural := 100E6;
           SAMPLENB_RATE : natural := 2E3 );
end entity;

architecture dfault of sdb_tb is

  component sdb is
    generic( TPD : time := 0 ns );
    port( clk_in    : in  std_logic;
          srst_in   : in  std_logic;
          enb_in    : in  std_logic;
          sig_in    : in  std_logic;  --< '0'-> 0deg, '1'-> 90deg
          drive_out : out std_logic );
  end component;

  constant WAITCLK : integer := 2;
  signal   clkcnt  : natural := 0;
  signal   enbcnt  : natural := 0;
  signal   clk     : std_logic;

  signal srst : std_logic;
  signal sig, drive : std_logic;
  signal enb : std_logic;

begin

  dut : sdb
    generic map( TPD => TPD )
    port map( clk_in    => clk,
              srst_in   => srst,
              enb_in    => enb,
              sig_in    => sig,
              drive_out => drive );

  tb : process
  begin

    wait for 1*tclk;
    srst <= '1';
    sig  <= '0';
    wait until clk = '1';
    wait for (1*tclk)/4;
    srst <= '0';
    -- perform simple inspection
    wait until enbcnt = 79;
    sig <= '1';

    wait until enbcnt = 128;
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
      wait for (CLKIN_RATE/SAMPLENB_RATE-2)*tclk;
      wait until clk = '1'; wait for (1*tclk)/10;
      enb <= not(enb); enbcnt <= enbcnt +1;
      wait for 1*tclk;
      enb <= not(enb);
    end loop;
  end process;

end architecture;
