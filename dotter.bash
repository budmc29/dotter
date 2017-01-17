#!/bin/bash

# Backup all the specified files to version control,
#   or update the files on this machine with the ones available online.
BASE_PATH="$(cd; pwd)/"

BUFFER_FOLDER="${BASE_PATH}ubuntu-dotfiles"

SELECTED_FILES=(
  ".hgrc"
  ".vimrc"
  ".hgrc"
  ".gvimrc"
  ".zshrc"
  ".i3"
  ".i3status.conf"
  ".aliases"
  "vimwiki"
  ".profile"
  ".Xdefaults"
)

function main()
{
  parse_params "$@"
  usage
}

function parse_params()
{
  while
    (( $# > 0 ))
  do
    PARAM="$1"
    shift
    case "$PARAM" in
      (--backup|backup|-b)
        dotter_backup
        exit 0
        ;;
      (--update|update|-u)
        dotter_update
        exit 0
        ;;
      (help|--help|-h)
        usage
        exit 0
        ;;
      (*)
        usage
        exit 1
        ;;
    esac
  done
}

function dotter_backup()
{
  check_buffer_folder
  # check version control for the updates and notify the user
  for FILE in "${SELECTED_FILES[@]}"; do
    cp $BASE_PATH$FILE -r $BUFFER_FOLDER
  done

  version_control_commit

  echo "All files copied successfully"
  exit 0
}

function update()
{
  echo "[wip] update"
}

function check_buffer_folder()
{
  if [[ ! -a "$BUFFER_FOLDER" ]]; then
    mkdir $BUFFER_FOLDER
  fi
}

function version_control_commit()
{
  cd $BUFFER_FOLDER

  git add -A
  git commit
  git push
}

function usage()
{
  printf "%b" "

Usage:

  dotter [options]

Options

  [[--]backup|-b]

  Backup the files on this machine to versino control.

  [[--]update|-u]

    Update the files on this machine with the files from version control.

"
}

main "$@"
