# modules/home/shell/eza/default.nix
# ==================================
#
# Copying
# -------
#
# Copyright (c) 2026 universe/config authors and contributors.
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
  cfg = config.universe.home.shell.eza;

  ezaOptions = cfg.options |> naturalSort |> universe.strings.concatSpace;

  defaultAliases = {
    "eza" = "eza ${ezaOptions}";
  };

  ezaAliases = {
    "eZ" = "eza ${ezaOptions} --context --long";
    "ez" = "eza ${ezaOptions}";
    "ezA" = "eza ${ezaOptions} --all";
    "ezl" = "eza ${ezaOptions} --long";
    "ezlA" = "eza ${ezaOptions} --all --long";
    "ezx" = "eza ${ezaOptions} --extended --long";
  };

  lsAliases = {
    "l" = "eza ${ezaOptions}";
    "la" = "eza ${ezaOptions} --all";
    "ll" = "eza ${ezaOptions} --long";
    "lla" = "eza ${ezaOptions} --all --long";
    "ls" = "eza ${ezaOptions}";
    "lx" = "eza ${ezaOptions} --extended --long";
    "lZ" = "eza ${ezaOptions} --context --long";
  };

  cfgEnabled =
    (
      if cfg.aliases.enable
      then ezaAliases
      else {}
    )
    // (
      if cfg.aliases.enable && cfg.aliases.asLs
      then lsAliases
      else {}
    );

  cfgAliases = defaultAliases // cfgEnabled // cfg.aliases.extra;
  shellAliases = removeAttrs cfgAliases cfg.aliases.exclude;
in {
  imports = universe.fs.import-directory ./.;

  options.universe.home.shell.eza = with types;
  with universe.nix; {
    enable = mkEnableOption "Enable Eza, a modern alternative to ls.";

    aliases = {
      enable = mkEnableOption "Create aliases for eza.";
      asLs = mkEnableOption "Alias eza as the `ls` command.";

      extra = mkOption {
        description = "A set of eza aliases to join along with the default ones.";
        default = {};
        example = {
          "ezo" = "eza --long --octal-permissions";
        };
        type = attrsOf str;
      };

      exclude = mkOption {
        description = "A list of eza aliases to exclude from the final result.";
        default = [];
        example = ["ezA" "ezl"];
        type = listOf str;
      };
    };

    options = mkOption {
      description = "Default options to provide to eza.";
      default = [
        "--color=auto"
        "--git-repos-no-status"
        "--git"
        "--group-directories-first"
        "--group"
        "--hyperlink"
        "--icons=auto"
        "--sort=extension"
      ];
      type = listOf str;
    };
  };

  config = mkIf cfg.enable {
    home = {
      inherit shellAliases;

      packages = with pkgs; [
        eza
      ];
    };
  };
}
