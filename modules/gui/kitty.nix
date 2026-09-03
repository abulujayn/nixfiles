{ username, ... }:

{
  home-manager.users.${username}.programs.kitty = {
    enable = true;
    themeFile = "Nord";

    settings = {
      scrollback_lines = -1;

      enable_audio_bell = false;
      confirm_os_window_close = 0;

      cursor_shape = "beam";
      cursor_blink_interval = 0;

      remember_window_size = true;
      initial_window_width = "120c";
      initial_window_height = "35c";
      window_padding_width = 8;

      update_check_interval = 0;
    };
  };
}
