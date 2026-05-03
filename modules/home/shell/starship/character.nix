# modules/home/shell/starship/character.nix
# =========================================
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
  cfg = config.universe.home.shell.starship.character;

  ourSettings = filterAttrs (k: v: v != null) ({
      inherit (cfg) format;

      disabled = !cfg.enable;

      error_symbol = cfg.symbol.error;
      success_symbol = cfg.symbol.success;
      vimcmd_replace_one_symbol = cfg.symbol.vim.replace_one;
      vimcmd_replace_symbol = cfg.symbol.vim.replace;
      vimcmd_symbol = cfg.symbol.vim.normal;
      vimcmd_visual_symbol = cfg.symbol.vim.visual;
    }
    // cfg.extraSettings);
in {
  options.universe.home.shell.starship.character = with types;
  with universe.nix; {
    enable = mkEnabledOption ''
      Shows a character (usually an arrow) beside where the text is entered in
      your terminal.
    '';

    extraSettings = mkOption {
      description = "Extra arbitrary configuration for the character module.";
      default = {};
      type = attrsOf anything;
    };

    format = mkOption {
      description = ''
        The format of the chracter module.
        See: https://starship.rs/config/#character
      '';
      default = "$symbol ";
      type = str;
    };

    symbol = {
      error = mkOption {
        description = ''
          The format string used before the text input if the previous command
          failed.
        '';
        default = "[❯](bold red)";
        type = str;
      };

      success = mkOption {
        description = ''
          The format string used before the text input if the previous command
          succeeded.
        '';
        default = "[❯](bold green)";
        type = str;
      };

      vim = {
        normal = mkOption {
          description = ''
            The format string used before the text input if the shell is in vim
            normal mode.
          '';
          default = "[❮](bold green)";
          type = str;
        };

        replace = mkOption {
          description = ''
            The format string used before the text input if the shell is in vim
            replace mode.
          '';
          default = "[❮](bold purple)";
          type = str;
        };

        replace_one = mkOption {
          description = ''
            The format string used before the text input if the shell is in vim
            `replace_one` mode.
          '';
          default = "[❮](bold purple)";
          type = str;
        };

        visual = mkOption {
          description = ''
            The format string used before the text input if the shell is in vim
            visual mode.
          '';
          default = "[❮](bold yellow)";
          type = str;
        };
      };
    };
  };

  config.universe.home.shell.starship.settings.character = mkIf cfg.enable ourSettings;
}
