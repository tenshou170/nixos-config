{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Real-time configuration
  security.rtkit.enable = true;
  systemd.services.rtkit-daemon = {
    serviceConfig = {
      ExecStart = [
        ""
        "${pkgs.rtkit}/libexec/rtkit-daemon --no-canary"
      ];
    };
  };

  # PipeWire configuration
  services.pipewire = {
    enable = true;
    socketActivation = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Echo cancellation configuration
  services.pipewire.extraConfig.pipewire."60-echo-cancel" = {
    "context.modules" = [
      {
        name = "libpipewire-module-echo-cancel";
        args = {
          "monitor.mode" = "true";
          "capture.props" = {
            # "node.target" = "alsa_input.usb-UGREEN_Camera_UGREEN_Camera_SN0001-02.analog-stereo";
            "node.passive" = "true";
            # "node.force-quantum" = "256";
          };
          # "sink.props" = {
          #   "node.target" = "alsa_output.usb-UGREEN_Camera_UGREEN_Camera_SN0001-02.analog-stereo";
          # };
          "source.props" = {
            "node.name" = "source_ec";
            "node.description" = "Echo-cancelled source";
          };
          aec.args = {
            "webrtc.gain_control" = "true";
            "webrtc.extended_filter" = "false";
            "webrtc.experimental_agc" = "true";
            "webrtc.noise_suppression" = "true";
          };
        };
      }
    ];
  };

  # WirePlumber configuration for disabling audio device suspension
  services.pipewire.wireplumber.extraConfig."51-disable-suspension" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          {
            "node.name" = "~alsa_input.*";
          }
          {
            "node.name" = "~alsa_output.*";
          }
        ];
        actions = {
          update-props = {
            "session.suspend-timeout-seconds" = 0;
            "dither.method" = "wannamaker3";
            "dither.noise" = 2;
          };
        };
      }
    ];
    "monitor.bluez.rules" = [
      {
        matches = [
          {
            "node.name" = "~bluez_input.*";
          }
          {
            "node.name" = "~bluez_output.*";
          }
        ];
        actions = {
          update-props = {
            "session.suspend-timeout-seconds" = 0;
            "dither.method" = "wannamaker3";
            "dither.noise" = 2;
          };
        };
      }
    ];
  };
}
