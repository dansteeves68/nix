{ ... }:
{
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";
    onActivation.upgrade = true;
    brews = [
      "dos2unix"
      # QMK toolchain
      # "osx-cross/arm/arm-gcc-bin"
      # "arm-none-eabi-gcc"
      # QMK nice to have (for other QMK boards and to silence warnings)
      # "osx-cross/avr/avr-gcc"
      "avrdude"
      "dfu-programmer"
      "dfu-util"
    ];
    casks = [
      "1password"
      "alfred"
      "cardhop"
      "claude-code"
      "copilot-cli"
      "deskpad"
      "discord"
      "fantastical"
      "firefox"
      "marked-app"
      "moom"
      "steermouse"
      "ungoogled-chromium"
    ];
    taps = [
      "nrlquaker/createzap"
      "osx-cross/avr"
    ];
  };
}
