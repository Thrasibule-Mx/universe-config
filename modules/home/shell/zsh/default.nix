# modules/home/shell/zsh/default.nix
# ==================================
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
  cfg = config.universe.home.shell.zsh;

  zshOptions = {
    alwaysLastPrompt = {
      name = "ALWAYS_LAST_PROMPT";
      default = true;
      description = ''
        If unset, key functions that list completions try to return to the last
        prompt if given a numeric argument. If set these functions try to
        return to the last prompt if given no numeric argument.
      '';
    };

    alwaysToEnd = {
      name = "ALWAYS_TO_END";
      default = true;
      description = ''
        If a completion is performed with the cursor within a word, and a full
        completion is inserted, the cursor is moved to the end of the word. That
        is, the cursor is moved to the end of the word if either a single match
        is inserted or menu completion is performed.
      '';
    };

    autoCd = {
      name = "AUTO_CD";
      default = null;
      description = ''
        If a command is issued that can't be executed as a normal command, and
        the command is the name of a directory, perform the `cd` command to that
        directory.
      '';
    };

    autoMenu = {
      name = "AUTO_MENU";
      default = true;
      description = ''
        Automatically use menu completion after the second consecutive request
        for completion, for example by pressing the tab key repeatedly. This
        option is overridden by `MENU_COMPLETE`.
      '';
    };

    autoParamSlash = {
      name = "AUTO_PARAM_SLASH";
      default = true;
      description = ''
        If a parameter is completed whose content is the name of a directory,
        then add a trailing slash instead of a space.
      '';
    };

    autoPushd = {
      name = "AUTO_PUSHD";
      default = true;
      description = ''
        Make `cd` push the old directory onto the directory stack.
      '';
    };

    autoRemoveSlash = {
      name = "AUTO_REMOVE_SLASH";
      default = false;
      description = ''
        When the last character resulting from a completion is a slash and the
        next character typed is a word delimiter, a slash, or a character that
        ends a command (such as a semicolon or an ampersand), remove the slash.
      '';
    };

    beep = {
      name = "BEEP";
      default = false;
      description = ''
        Beep on error in ZLE.
      '';
    };

    cdAbleVars = {
      name = "CDABLE_VARS";
      default = null;
      description = ''
        If the argument to a `cd` command (or an implied `cd` with the `AUTO_CD`
        option set) is not a directory, and does not begin with a slash, try to
        expand the expression as if it were preceded by a `~`.
      '';
    };

    correct = {
      name = "CORRECT";
      default = true;
      description = ''
        Try to correct the spelling of commands.
      '';
    };

    completeInWord = {
      name = "COMPLETE_IN_WORD";
      default = true;
      description = ''
        If unset, the cursor is set to the end of the word if completion is
        started. Otherwise it stays there and completion is done from both ends.
      '';
    };

    extendedGlob = {
      name = "EXTENDED_GLOB";
      default = null;
      description = ''
        Treat the `#`, `~` and `^` characters as part of patterns for filename
        generation. An initial unquoted `~` always produces named directory
        expansion.
      '';
    };

    glob = {
      name = "GLOB";
      default = true;
      description = ''
        Perform filename generation (globbing).
      '';
    };

    globDots = {
      name = "GLOB_DOTS";
      default = false;
      description = ''
        Do not require a leading `.` in a filename to be matched explicitly.
      '';
    };

    histReduceBlanks = {
      name = "HIST_REDUCE_BLANKS";
      default = true;
      description = ''
        Remove superfluous blanks from each command line being added to the
        history list.
      '';
    };

    histVerify = {
      name = "HIST_VERIFY";
      default = true;
      description = ''
        Whenever the user enters a line with history expansion, don't execute
        the line immediately; instead, perform history expansion and reload the
        line into the editing buffer.
      '';
    };

    markDirs = {
      name = "MARK_DIRS";
      default = null;
      description = ''
        Append a trailing `/` to all directory names resulting from filename
        generation.
      '';
    };

    menuComplete = {
      name = "MENU_COMPLETE";
      default = null;
      description = ''
        On an ambiguous completion, instead of listing possibilities or beeping,
        insert the first match immediately. Then when completion is requested
        again, remove the first match and insert the second match, etc. When
        there are no more matches, go back to the first one again.
      '';
    };

    noMatch = {
      name = "NOMATCH";
      default = false;
      description = ''
        If a pattern for filename generation has no matches, print an error,
        instead of leaving it unchanged in the argument list.
      '';
    };

    numericGlobSort = {
      name = "NUMERIC_GLOB_SORT";
      default = true;
      description = ''
        If numeric filenames are matched by a filename generation pattern,
        sort the filenames numerically rather than lexicographically.
      '';
    };

    pushdIgnoreDups = {
      name = "PUSHD_IGNORE_DUPS";
      default = true;
      description = ''
        Don't push multiple copies of the same directory onto the directory
        stack.
      '';
    };

    pushdMinus = {
      name = "PUSHD_MINUS";
      default = true;
      description = ''
        Exchanges the meanings of `+` and `-` when used with a number to specify
        a directory in the stack.
      '';
    };

    pushdSilent = {
      name = "PUSHD_SILENT";
      default = true;
      description = ''
        Do not print the directory stack after `pushd` or `popd`.
      '';
    };

    pushdToHome = {
      name = "PUSHD_TO_HOME";
      default = true;
      description = ''
        Have `pushd` with no arguments act like `pushd $HOME`.
      '';
    };

    interactiveComments = {
      name = "INTERACTIVE_COMMENTS";
      default = true;
      description = ''
        Allow comments even in interactive shells.
      '';
    };

    transientRprompt = {
      name = "TRANSIENT_RPROMPT";
      default = null;
      description = ''
        Remove any right prompt from display when accepting a command line.
      '';
    };
  };

  setOptions =
    zshOptions
    |> mapAttrsToList (
      k: v:
        if cfg.config.${k} == null
        then null
        else if cfg.config.${k}
        then v.name
        else "NO_${v.name}"
    )
    |> filter (v: v != null)
    |> naturalSort;
in {
  imports = universe.fs.import-directory ./.;

  options.universe.home.shell.zsh = with types;
  with universe.nix; {
    enable = mkEnableOption "universe.home.shell.zsh";

    config =
      {
        directory = mkOption {
          description = ''
            Directory where the zsh configuration and more should be located.
          '';
          default = "${config.xdg.configHome}/zsh";
          type = str;
        };
      }
      // mapAttrs (k: v: mkTriStateOption v.default v.description) zshOptions;

    highlighting = {
      enable = mkEnabledOption "Enable ZSH syntax highlighting.";
      styles = mkOption {
        description = ''
          A set of custom styles to use for syntax highlighting.
          See the [zsh-syntax-highlighting documentation](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md)
          for the available styles.
        '';
        default = {};
        type = attrsOf str;
      };
    };

    history = {
      append = mkEnableOption ''
        If set, zsh sessions will append their history list to the history
        file, rather than replace it. Thus, multiple parallel zsh sessions
        will all have the new entries from their history lists added to the
        history file, in the order that they exit.
      '';

      ignoreDups = mkEnabledOption ''
        If set, zsh will not add a command to the history list if it is
        identical to the last command in the history list.
      '';

      ignoreSpace = mkEnabledOption ''
        If set, zsh will not add a command to the history list if it begins
        with a space.
      '';

      share = mkEnabledOption ''
        Share command history between ZSH sessions.
      '';
    };

    keymap = mkOption {
      description = ''
        The base keymap to use. Can either be Emacs or Vi mode.
      '';
      default = null;
      type = nullOr (enum [
        "emacs"
        "vicmd"
        "viins"
      ]);
    };

    suggestion = {
      enable = mkEnabledOption ''
        Suggest commands as you type based on history and completions.
      '';

      strategy = mkOption {
        description = ''
          Specifies how suggestions should be generated.

          * `history`: Chooses the most recent match from history.
          * `completion`: Chooses a suggestion based on what tab-completion
            would suggest.
        '';
        default = ["history" "completion"];
        type = listOf (enum [
          "history"
          "completion"
        ]);
      };
    };
  };

  config = mkIf cfg.enable {
    home.shell.enableZshIntegration = cfg.enable;

    programs.zsh = {
      inherit setOptions;
      inherit (cfg) enable;

      autosuggestion = {
        inherit (cfg.suggestion) enable strategy;
      };

      defaultKeymap = cfg.keymap;
      dotDir = cfg.config.directory;

      enableCompletion = true;
      enableVteIntegration = true;

      history = {
        inherit (cfg.history) append ignoreDups ignoreSpace share;

        extended = true;
        findNoDups = true;
        path = "${config.xdg.dataHome}/zsh/history";
      };

      syntaxHighlighting = {
        inherit (cfg.highlighting) enable styles;
      };
    };
  };
}
