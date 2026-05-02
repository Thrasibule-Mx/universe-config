# modules/home/shell/starship/directory.nix
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
  cfg = config.universe.home.shell.starship.directory;

  ourSettings = filterAttrs (k: v: v != null) ({
      disabled = !cfg.enable;
      use_os_path_sep = cfg.useOsPathSep;

      format = cfg.format.path;
      repo_root_format = cfg.format.repoRoot;

      before_repo_root_style = cfg.style.beforeRepoRoot;
      read_only_style = cfg.style.readOnly;
      repo_root_style = cfg.style.repoRoot;
      style = cfg.style.path;

      home_symbol = cfg.symbol.home;
      read_only = cfg.symbol.readOnly;
      truncation_symbol = cfg.symbol.truncation;
      truncate_to_repo = cfg.truncation.toRepo;
      truncation_length = cfg.truncation.length;
    }
    // cfg.extraSettings);
in {
  options.universe.home.shell.starship.directory = with types;
  with universe.nix; {
    enable = mkEnabledOption ''
      Shows the path to your current directory, truncated to configured parent
      folders.

      See: https://starship.rs/config/#directory
    '';

    extraSettings = mkOption {
      description = "Extra arbitrary configuration for the directory module.";
      default = {};
      type = attrsOf anything;
    };

    format = {
      path = mkOption {
        description = ''
          The format of the path.
        '';
        default = "[$path]($style) [$read_only]($read_only_style) ";
        type = str;
      };

      repoRoot = mkOption {
        description = ''
          The format of a repository when `before_repo_root_style` and
            `repo_root_style` is defined.
        '';
        default = "[$before_root_path]($before_repo_root_style)[ $repo_root]($repo_root_style)[$path]($style) [$read_only]($read_only_style) ";
        type = str;
      };
    };

    style = {
      beforeRepoRoot = mkOption {
        description = ''
          The style for the path segment above the root of the repository.
        '';
        default = null;
        type = nullOr str;
      };

      path = mkOption {
        description = ''
          The style for the path.
        '';
        default = "bold cyan";
        type = str;
      };

      readOnly = mkOption {
        description = ''
          The style for the read only symbol.
        '';
        default = "red";
        type = str;
      };

      repoRoot = mkOption {
        description = ''
          The style for the root of the repository.
        '';
        default = "bold blue";
        type = nullOr str;
      };
    };

    symbol = {
      home = mkOption {
        description = ''
          The symbol indicating home directory.
        '';
        default = "~";
        type = str;
      };

      readOnly = mkOption {
        description = ''
          The symbol indicating current directory is read only.
        '';
        default = "🔒";
        type = str;
      };

      truncation = mkOption {
        description = ''
          The symbol to prefix to truncated paths.
        '';
        default = "";
        type = str;
      };
    };

    truncation = {
      length = mkOption {
        description = ''
          The number of parent folders that the current directory should be
          truncated to.
        '';
        default = 3;
        type = int;
      };

      toRepo = mkOption {
        description = ''
          Whether or not to truncate to the root of the repository that you're
          currently in.
        '';
        default = true;
        type = bool;
      };
    };

    useOsPathSep = mkEnabledOption ''
      Use the OS specific path separator instead of always using `/` (e.g. `\`
      on Windows).
    '';
  };

  config.universe.home.shell.starship.settings.directory = mkIf cfg.enable ourSettings;
}
