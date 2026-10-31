{ lib, machine, ... }:
let
  isPersonal = machine.username == "dan";
in
{
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";
    onActivation.upgrade = true;
    brews = [
      "dos2unix"
    ]
    ++ lib.optionals isPersonal [
      # QMK toolchain
      # "osx-cross/arm/arm-gcc-bin"
      # "arm-none-eabi-gcc"
      # QMK nice to have (for other QMK boards and to silence warnings)
      # "osx-cross/avr/avr-gcc"
      "avrdude"
      "dfu-programmer"
      "dfu-util"
    ]
    ++ lib.optionals (!isPersonal) [
      "snyk-cli"
    ];
    casks = [
      # everywhere
      "1password"
      "alfred"
      "cardhop"
      "copilot-cli"
      "deskpad"
      "fantastical"
      "firefox"
      "marked-app"
      "moom"
      "steermouse"
    ]
    ++ lib.optionals isPersonal [
      "claude-code"
      "discord"
      "ungoogled-chromium"
    ]
    ++ lib.optionals (!isPersonal) [
      # work only
    ];
    taps = [
      "nrlquaker/createzap"
      "osx-cross/avr"
    ];
  };
}
