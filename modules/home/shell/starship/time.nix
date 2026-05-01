# modules/home/shell/starship/time.nix
# ====================================
#
# Copying
# -------
#
# Copyright (c) 2025 universe/config authors and contributors.
#
# This file is part of the *universe/config* project.
#
# *universe/config* is a free software project. You can redistribute it
# and/or modify it following the terms of the MIT License.
#
# This software project is distributed *as is*, WITHOUT WARRANTY OF ANY KIND;
# including but not limited to the WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE and NONINFRINGEMENT.
#
# You should have received a copy of the MIT License along with
# *universe/config*. If not, see <http://opensource.org/licenses/MIT>.
#
{
  # Flake's library as well as the libraries available from the flake's
  # inputs.
  lib,
  # An instance of input packages mixed with the flake's overlays and packages.
  pkgs,
  # Flake's inputs.
  inputs,
  # The namespace of the flake. See `snowfall.namespace`.
  namespace,
  # The system architecture for the system (eg. `x86_64-linux`).
  system,
  # The Snowfall Lib target for the system (eg. `x86_64-iso`).
  target,
  # A normalized name for the system target (eg. `iso`).
  format,
  # A boolean to determine whether this system is a virtual target using
  # nixos-generators.
  virtual,
  # An attribute map of other defined systems.
  systems,
  # Options coming from user of the module.
  config,
  ...
}:
with lib; let
  cfg = config.universe.home.shell.starship.time;

  ourSettings = filterAttrs (k: v: v != null) ({
      inherit (cfg) format style;

      disabled = !cfg.enable;

      time_format = cfg.timeFormat;
      time_range = cfg.timeRange;
      use_12hr = cfg.use12hr;
      utc_time_offset = cfg.utcTimeOffset;
    }
    // cfg.extraSettings);
in {
  options.universe.home.shell.starship.time = with types;
  with universe.nix; {
    enable = mkEnableOption "Shows the current local time.";

    extraSettings = mkOption {
      description = "Extra arbitrary configuration for the time module.";
      default = {};
      type = attrsOf anything;
    };

    format = mkOption {
      description = ''
        The format of the time module.
        See: https://starship.rs/config/#time
      '';
      default = "[$time]($style) ";
      type = str;
    };

    style = mkOption {
      description = ''
        The style for the module time.
      '';
      default = "yellow";
      type = str;
    };

    timeFormat = mkOption {
      description = ''
        The [chrono format string](https://docs.rs/chrono/0.4.7/chrono/format/strftime/index.html)
        used to format the time.
      '';
      default = null;
      type = nullOr str;
    };

    timeRange = mkOption {
      description = ''
        Sets the time range during which the module will be shown. Times must be
        specified in 24-hours format.
      '';
      default = "-";
      type = str;
    };

    use12hr = mkEnableOption ''
      Enables 12 hour formatting.

      When `true`, `time_format` defaults to `'%r'`. Otherwise, it defaults to
      '%T'.

      Manually setting `time_format` will override this option.
    '';

    utcTimeOffset = mkOption {
      description = ''
        Sets the UTC offset to use. Range from -24 < x < 24. Allows floats to
        accommodate 30/45 minute timezone offsets.
      '';
      default = null;
      type = nullOr (oneOf [float int str]);
      apply = x:
        if isFloat x || isInt x
        then toString x
        else x;
    };
  };

  config.universe.home.shell.starship.settings.time = mkIf cfg.enable ourSettings;
}
