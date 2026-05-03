# modules/home/shell/aliases.nix
# ==============================
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
  cfg = config.universe.home.shell.aliases;

  utilArgs = let
    args =
      (optionals cfg.enable [
        {
          "name" = "chgrp";
          "args" = ["--preserve-root"];
        }
        {
          "name" = "chmod";
          "args" = ["--preserve-root"];
        }
        {
          "name" = "chown";
          "args" = ["--preserve-root"];
        }
        {
          "name" = "cp";
          "args" = ["--one-file-system"];
        }
        {
          "name" = "mkdir";
          "args" = ["--parents"];
        }
        {
          "name" = "rm";
          "args" = ["--one-file-system" "--preserve-root=all"];
        }
      ])
      ++ (optionals cfg.grep.enable (
        forEach
        [
          "egrep"
          "fgrep"
          "grep"
          "xzegrep"
          "xzfgrep"
          "xzgrep"
          "zegrep"
          "zfgrep"
          "zgrep"
        ]
        (x: {
          "name" = x;
          "args" = cfg.grep.options;
        })
      ))
      ++ (optionals cfg.interactive.enable [
        {
          "name" = "cp";
          "args" = ["--interactive"];
        }
        {
          "name" = "ln";
          "args" = ["--interactive"];
        }
        {
          "name" = "mv";
          "args" = ["--interactive"];
        }
        {
          "name" = "rm";
          "args" = ["--interactive=once"];
        }
      ])
      ++ (optionals cfg.ls.enable [
        {
          "name" = "ls";
          "args" = cfg.ls.options;
        }
      ]);
  in
    zipAttrsWith
    (name: values: (values |> flatten |> naturalSort |> universe.strings.concatSpace))
    (map (x: {${x.name} = x.args;}) args);

  utilAliases = mapAttrs (k: v: "${k} ${v}") utilArgs;

  defaultAliases = {};

  lsOptions = universe.strings.concatSpace cfg.ls.options;
  lsAliases = {
    "l" = "ls ${utilArgs.ls}";
    "la" = "ls ${utilArgs.ls} --almost-all";
    "ll" = "ls ${utilArgs.ls} -l";
    "lla" = "ls ${utilArgs.ls} --almost-all -l";
  };

  navigationAliases = {
    "-" = "popd";
    "?" = "dirs";
    ".." = "cd ..";
    "/" = "cd";
    "+" = "pushd";
    "~" = "cd ~";
  };

  opensslAliases = {
    "rand" = "openssl rand -base64";
    "req" = "openssl req -noout -text -in";
    "s_client" = "openssl s_client -showcerts -connect";
    "x509" = "openssl x509 -noout -text -in";
  };

  cfgEnabled =
    (
      if cfg.enable
      then defaultAliases
      else {}
    )
    // (
      if cfg.ls.enable
      then lsAliases
      else {}
    )
    // (
      if cfg.navigation.enable
      then navigationAliases
      else {}
    )
    // (
      if cfg.openssl.enable
      then opensslAliases
      else {}
    );

  cfgAliases = utilAliases // cfgEnabled // cfg.extraAliases;
  shellAliases = removeAttrs cfgAliases cfg.excludeAliases;
in {
  options.universe.home.shell.aliases = with types;
  with universe.nix; {
    enable = mkEnabledOption "Whether to enable.universe.home.shell.aliases";

    grep = {
      enable = mkEnabledOption "Enable grep aliases.";

      options = mkOption {
        description = "Options to provide to the `grep` command.";
        default = [
          "--color=auto"
          "--extended-regexp"
          "--no-messages"
        ];
        type = listOf str;
      };
    };

    interactive.enable = mkEnabledOption "Enable confirmation request on some commmands";

    ls = {
      enable = mkEnabledOption "Enable aliases for the `ls` command.";

      options = mkOption {
        description = "Options to provide to the `ls` command.";
        default = [
          "--color=auto"
          "--group-directories-first"
          "--human-readable"
          "--sort=extension"
        ];
        type = listOf str;
      };
    };

    navigation.enable = mkEnabledOption "Enable direction navigation aliases.";
    openssl.enable = mkEnableOption "Enable openssl related aliases";

    extraAliases = mkOption {
      description = "A set of shell aliases to join along with the default ones.";
      default = {};
      example = {
        ".." = "cd ..";
        "ll" = "ls -l";
      };
      type = attrsOf str;
    };

    excludeAliases = mkOption {
      description = "A list of shell aliases to exclude from the final result.";
      default = [];
      example = [".." "ll"];
      type = listOf str;
    };
  };

  config = mkIf cfg.enable {
    home = {
      inherit shellAliases;
    };
  };
}
