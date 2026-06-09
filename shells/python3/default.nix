# shells/python3/default.nix
# ==========================
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
  # Flake's inputs.
  inputs,
  # The namespace of the flake. See `snowfall.namespace`.
  namespace,
  # An instance of `pkgs` with the overlays and other packages.
  pkgs,
  mkShell,
  ...
}: let
  shell = builtins.baseNameOf (builtins.getEnv "SHELL");
  fastfetch_cfg = pkgs.writeText "fastfetch.jsonc" (
    lib.universe.shells.mkFastFetchConfig
    "A Python 3 development environment."
    [
      {
        name = "Python 3";
        description = "An interpreted, interactive, object-oriented programming language.";
      }
      {
        name = "Black";
        description = "A PEP 8 compliant uncompromising Python code formatter.";
      }
      {
        name = "Cookiecutter";
        description = "A cross-platform command-line utility that creates projects from templates.";
      }
      {
        name = "Git";
        description = "A distributed version control system that tracks versions of files.";
      }
      {
        name = "isort";
        description = "A Python utility to sort imports.";
      }
      {
        name = "Mypy";
        description = "A static type checker for Python.";
      }
      {
        name = "Poetry";
        description = "A tool for dependency management and packaging in Python.";
      }
      {
        name = "pyenv";
        description = "Lets you easily switch between multiple versions of Python.";
      }
      {
        name = "Ruff";
        description = "An extremely fast Python linter and code formatter.";
      }
      {
        name = "Sphinx";
        description = "A documentation generator.";
      }
      {
        name = "uv";
        description = "An extremely fast Python package and project manager.";
      }
    ]
  );
in
  mkShell {
    env =
      pkgs.python3.env
      // {
        PYTHON_CONFIGURE_OPTS = lib.universe.strings.concatSpace pkgs.python3.configureFlags;
      };

    inputsFrom = with pkgs; [
      python3
    ];

    nativeBuildInputs = with pkgs; [
      pkg-config
    ];

    packages = with pkgs;
      [
        black
        cookiecutter
        git
        isort
        mypy
        poetry
        pyenv
        ruff
        sphinx
        uv

        fastfetch
      ]
      ++ (lib.optional (shell != "") pkgs.${shell});

    name = "python3";
    shellHook = ''
      fastfetch --config "${fastfetch_cfg}"

      export PS1="[''${name}]$ "
      if [ "${shell}" ]
      then
        export SHELL="$(which ${shell})"
        exec ''${SHELL}
      fi
    '';
  }
