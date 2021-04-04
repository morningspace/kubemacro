#!/bin/bash

# MIT License
# 
# Copyright (c) 2021 MorningSpace
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

VERSION="0.1.0"

WORKDIR=~/.kubemacro
mkdir -p $WORKDIR
MACRO_SHASUM_URL=https://raw.githubusercontent.com/morningspace/kubemacro-hub/main/macros/macros.sha256

GLOBAL_OPTIONS_HELP=(
  "-h, --help: Print the help information."
  "    --version: Print the version information."
)

# Load macros
for file in `ls $WORKDIR/*.sh 2>/dev/null`; do . $file; done

function parse_common_args {
  ARG_HELP=''
  ARG_VERSION=''
  POSITIONAL=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -h|--help)
      ARG_HELP=1; shift ;;
    -v|--version)
      ARG_VERSION=1; shift ;;
    *)
      POSITIONAL+=("$1"); shift ;;
    esac
  done
}

function kubectl {
  command kubectl $@
}

function list_macros {
  echo "KubeMacro - the kubectl plugin to wrap a set of kubectl calls into one command that can run many times."
  echo
  echo "  Find more information at: https://morningspace.github.io/kubemacro/docs/"
  echo

  echo -e "Installed macros:\n"

  local lines
  for file in `ls $WORKDIR/*.sh 2>/dev/null`; do
    lines+="`list_macros_in "$file"`\n"
  done

  if [[ -n $lines ]]; then
    echo -e "$lines"
  else
    echo -e "  Oops! You haven't installed any macro yet.\n"
  fi

  echo "Explore and install awesome macros at: https://morningspace.github.io/kubemacro-hub/."
  echo "Use \"kubectl macro <macro> --help\" for more information about a given macro."
}

function list_macros_in {
  local macros=(`cat $1 | grep '^#[[:space:]]*@Name:' | sed -n 's/^#[[:space:]]*@Name://p'`)

  for name in "${macros[@]}"; do
    local comment="`sed -n -e "/^#[[:space:]]*@Name:[[:space:]]*$name$/,/^##$/p" $1 | sed -e '1d;$d'`"
    local summary="`echo "$comment" | grep '^#[[:space:]]*@Description:[[:space:]]*' | sed -n 's/^#[[:space:]]*@Description:[[:space:]]*//p'`"
    printf "  %-36s %s\n" "$name" "$summary"
  done
}

function show_macro_help {
  for file in $0 `ls $WORKDIR/*.sh 2>/dev/null`; do
    local macros=(`cat $file | grep '^#[[:space:]]*@Name:' | sed -n 's/^#[[:space:]]*@Name://p'`)
    if [[ ' '${macros[@]}' ' =~ [[:space:]]+$1[[:space:]]+ ]]; then
      show_macro_help_in $1 $file
      break
    fi
  done
}

function show_macro_help_in {
  local name=$1
  local file=$2
  local comment="`sed -n -e "/^#[[:space:]]*@Name:[[:space:]]*$name$/,/^##$/p" $file | sed -e '1d;$d'`"
  local summary="`echo "$comment" | grep '^#[[:space:]]*@Description:[[:space:]]*' | sed -n 's/^#[[:space:]]*@Description:[[:space:]]*//p'`"
  local usage="`echo "$comment" | grep '^#[[:space:]]*@Usage:[[:space:]]*' | sed -n 's/^#[[:space:]]*@Usage:[[:space:]]*//p'`"
  local options=""
  local examples=""
  local parsing

  while IFS= read -r line; do
    [[ $line =~ ^#[[:space:]]*@Options:[[:space:]]*$ ]] && parsing=Options && continue
    [[ $line =~ ^#[[:space:]]*@Examples:[[:space:]]*$ ]] && parsing=Examples && continue

    if [[ $parsing == Options ]] && [[ ! $line =~ ^#$ ]]; then
      if [[ $line =~ '${GLOBAL_OPTIONS}' ]]; then
        options+="${GLOBAL_OPTIONS_HELP[@]}\n"
      else
        options+="`echo "$line" | sed -n 's/^#[[:space:]]//p'`\n"
      fi
    fi
    
    if [[ $parsing == Examples ]] && [[ ! $line =~ ^#$ && ! $line =~ ^#[[:space:]]*@ ]]; then
      examples+="`echo "$line" | sed -n 's/^#[[:space:]]//p'`\n"
    fi
  done <<< "$comment"

  [[ -n $summary ]] && echo "$name: $summary" || echo "$name"
  [[ -n $usage ]] && echo -e "\nUsage: $usage"

  if [[ -n $options ]]; then
    echo -e "\nOptions:"
    echo -e -n "$options"
  fi

  if [[ -n $examples ]]; then
    echo -e "\nExamples:"
    echo -e -n "$examples"
  fi
}

function check_dependencies {
  local macro=$1
  local dependencies="`cat $WORKDIR/$macro.sh | grep '^#[[:space:]]*@Dependencies:[[:space:]]*' | sed -n 's/^#[[:space:]]*@Dependencies:[[:space:]]*//p'`"
  IFS=',' read -r -a deps <<< "$dependencies"
  for dep in ${deps[@]}; do
    if ! type $dep &>/dev/null ; then
      echo "The dependency $dep is required by $macro but is not found."
      echo "Please install $dep first before you run $macro."
      return 1
    fi
  done
}

function run_macro {
  parse_common_args $@

  local what=${POSITIONAL[0]}
  if [[ -n $what ]]; then
    if type $what &>/dev/null ; then
      # Check dependencies if defined in the macro and
      # fail the execution if dependencies not found
      check_dependencies $what || return 1

      if [[ $ARG_HELP == 1 ]]; then
        # Display help information for the macro
        show_macro_help $what
      else
        # Run the macro
        set -- ${POSITIONAL[@]}
        $what ${@:2}
      fi

      # Check updates for the macro
      check_updates $what
    else
      # The macro not found
      echo 'Unknown macro "'$what'".' && return 1
    fi
  else
    if [[ $ARG_VERSION == 1 ]]; then
      # Display version information
      echo "kubectl-macro version $VERSION"
    else
      # List all installed macros
      list_macros
    fi
  fi
}

function confirm {
  local input
  local value=${2:-Y}
  while true; do
    [[ $value == Y ]] && echo -n "$1 [Y/n] " || echo -n "$1 [y/N] "

    read -r input
    input=${input:-$value}

    case $input in
      [yY][eE][sS]|[yY])
        return 0
        ;;
      [nN][oO]|[nN])
        return 1
        ;;
      *)
        echo "Invalid input..."
        ;;
    esac
  done
}

function get_shasum {
  if command -v shasum >/dev/null 2>&1 ; then
    command shasum -a 256 $@
  elif command -v sha256sum >/dev/null 2>&1 ; then
    command sha256sum $@
  fi
}

function check_updates {
  command -v curl >/dev/null 2>&1 || return 0

  local macro=$1

  curl -s $MACRO_SHASUM_URL -o $WORKDIR/macros.sha256 >/dev/null &

  if [[ -f $WORKDIR/macros.sha256 ]]; then
    local entry=($(cat $WORKDIR/macros.sha256 | grep $macro))
    local shasum_remote=${entry[0]}
    local shasum_local=`get_shasum $WORKDIR/$macro.sh | awk '{print $1}'`
    if [[ -n $shasum_remote && -n $shasum_local && $shasum_remote != $shasum_local ]]; then
      echo >&2
      echo -e "\033[0;33mWarning:\033[0m It appears the macro $macro has been updated by its author." >&2
      echo -e "To get the latest copy, go to check: https://morningspace.github.io/kubemacro-hub/macros/#/docs/$macro." >&2
      echo >&2
    fi
  fi
}

run_macro "$@"
