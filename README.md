# tmux-power-saver

A tmux plugin which detects if your computer runs on battery or AC power to adjust the `status-interval` time
accordingly. A higher `status-interval` can reduce power consumption if many scripts must to be run to redraw the status
line (for example when using [tmux-powerline](https://github.com/erikw/tmux-powerline)).

## Installation with TPM

1. Add

   ```tmux
   set -g @plugin 'IngoHeimbach/tmux-power-saver'
   ```

   to your `.tmux.conf`.

2. Restart `tmux` or reload `.tmux.conf` and press `<prefix>-I`.

## Configuration

- Set other status line intervals:

  ```tmux
  set -g @power-saver_battery_interval "<battery interval>"
  set -g @power-saver_ac_interval "<ac power interval>"
  ```

  By default, the `status-interval` will be set to 2 seconds for ac and 20 seconds for battery power.

## Usage

This plugin runs out-of-the-box, so just enjoy!
