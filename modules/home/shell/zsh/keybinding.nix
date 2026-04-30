# modules/home/shell/zsh/keybinding.nix
# =====================================
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
  cfg = config.universe.home.shell.zsh.keybinding;

  keymap = {
    backspace = {
      zkbd = "Backspace";
      terminfo = "kbs";
      default = "backward-delete-char";
    };

    delete = {
      zkbd = "Delete";
      terminfo = "kdch1";
      default = "delete-char";
    };

    down = {
      zkbd = "Down";
      terminfo = "kcud1";
      default = "down-line-or-history";
    };

    end = {
      zkbd = "End";
      terminfo = "kend";
      default = "end-of-line";
    };

    home = {
      zkbd = "Home";
      terminfo = "khome";
      default = "beginning-of-line";
    };

    insert = {
      zkbd = "Insert";
      terminfo = "kich1";
      default = "overwrite-mode";
    };

    left = {
      zkbd = "Left";
      terminfo = "kcub1";
      default = "backward-char";
    };

    pageDown = {
      zkbd = "PageDown";
      terminfo = "knp";
      default = "end-of-buffer-or-history";
    };

    pageUp = {
      zkbd = "PageUp";
      terminfo = "kpp";
      default = "beginning-of-buffer-or-history";
    };

    right = {
      zkbd = "Right";
      terminfo = "kcuf1";
      default = "forward-char";
    };

    up = {
      zkbd = "Up";
      terminfo = "kcuu1";
      default = "up-line-or-history";
    };
  };

  keymapVars =
    mapAttrsToList
    (_: v: ''key[${v.zkbd}]="''${terminfo[${v.terminfo}]}"'')
    keymap;

  keyBindings =
    mapAttrsToList
    (k: v: ''[[ -n "''${key[${v.zkbd}]}" ]] && bindkey "''${key[${v.zkbd}]}" ${cfg.${k}}'')
    keymap;

  zleInit = ''
    if (( ''${+terminfo[smkx]} && ''${+terminfo[rmkx]} )); then
        autoload -Uz add-zle-hook-widget
        function zle_bindkey_start { echoti smkx }
        function zle_bindkey_stop { echoti rmkx }
        add-zle-hook-widget -Uz zle-line-init zle_bindkey_start
        add-zle-hook-widget -Uz zle-line-finish zle_bindkey_stop
    fi
  '';

  initContent = ''
    # ZSH key binding.
    typeset -g -A key
    ${concatLines keymapVars}
    ${concatLines keyBindings}
    ${zleInit}
  '';
in {
  options.universe.home.shell.zsh.keybinding = with types;
  with universe.nix;
    {
      enable = mkEnabledOption "Enable ZSH key binding.";
    }
    // mapAttrs (k: v:
      mkOption {
        inherit (v) default;

        description = "ZSH function called when the <${v.zkbd}> key is pressed.";
        type = str;
      })
    keymap;

  config = mkIf cfg.enable {
    programs.zsh = {
      inherit initContent;
    };
  };
}
