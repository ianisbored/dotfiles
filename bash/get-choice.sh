#!/bin/bash

green=$'\e[0;32m'
red=$'\e[0;31m'
white=$'\e[0m'
menuStr=""
returnOrExit=""

function hideCursor {
  printf "\033[?25l"
  
  # capture CTRL+C so cursor can be reset
  trap "showCursor && echo '' && ${returnOrExit} 0" SIGINT
}

function showCursor {
  printf "\033[?25h"
  trap - SIGINT
}

function clearLastMenu {
  local msgLineCount=$(printf "$menuStr" | wc -l)
  # moves the cursor up N lines so the output overwrites it
  echo -en "\033[${msgLineCount}A"

  # clear to end of screen to ensure there's no text left behind from previous input
  [ $1 ] && tput ed
}

function renderMenu {
  local start=0
  local selector=""
  local instruction="$1"
  local selectedIndex=$2
  local listLength=$itemsLength
  local longest=0
  local spaces=""
  menuStr="\n $instruction"$'\n'

  # Get the longest item from the list so that we know how many spaces to add
  # to ensure there's no overlap from longer items when a list is scrolling up or down.
  for (( i=0; i<$itemsLength; i++ )); do
    if (( ${#menuItems[i]} > longest )); then
      longest=${#menuItems[i]}
    fi
  done
  spaces=$(printf ' %.0s' $(eval "echo {1.."$(($longest))"}"))

  if [ $3 -ne 0 ]; then
    listLength=$3

    if [ $selectedIndex -ge $listLength ]; then
      start=$(($selectedIndex+1-$listLength))
      listLength=$(($selectedIndex+1))
    fi
  fi

  for (( i=$start; i<$listLength; i++ )); do
    local currItem="${menuItems[i]}"
    currItemLength=${#currItem}

    if [[ $i = $selectedIndex ]]; then
      currentSelection="${currItem}"
      selector="${green}>${white}"
      currItem="${green}${currItem}${white}"
    else
      selector=" "
    fi

    currItem="${spaces:0:0}${currItem}${spaces:currItemLength}"

    menuStr="${menuStr}"$'\n'" ${selector} ${currItem}"
  done

  menuStr="${menuStr}\n"

  # whether or not to overwrite the previous menu output
  [ $4 ] && clearLastMenu

  printf "${menuStr}"
}

function renderHelp {
  echo;
  echo "Usage: getChoice [OPTION]..."
  echo "Renders a keyboard navigable menu with a visual indicator of what's selected."
  echo;
  echo "  -h, --help               Displays this message"
  echo "  -i, --index              The initially selected index for the options"
  echo "  -m, --max                Limit how many options are displayed"
  echo "  -o, --options            An Array of options for a user to choose from"
  echo "  -q, --query              Question or statement presented to the user"
  echo "  -v, --selectionVariable  Variable the selected choice will be saved to. Defaults to the 'selectedChoice' variable."
  echo;
  echo "Example:"
  echo "  foodOptions=(\"pizza\" \"burgers\" \"chinese\" \"sushi\" \"thai\" \"italian\" \"shit\")"
  echo;
  echo "  getChoice -q \"What do you feel like eating?\" -o foodOptions -i 6 -m 4 -v \"firstChoice\""
  echo "  printf \"\\n First choice is '\${firstChoice}'\\n\""
  echo;
  echo "  getChoice -q \"Select another option in case the first isn't available\" -o foodOptions"
  echo "  printf \"\\n Second choice is '\${selectedChoice}'\\n\""
  echo;
}

function getChoice {
  local KEY__ARROW_UP=$(echo -e "\033[A")
  local KEY__ARROW_DOWN=$(echo -e "\033[B")
  local KEY__ENTER=$(echo -e "\n")
  local captureInput=true
  local displayHelp=false
  local maxViewable=0
  local instruction="Select an item from the list:"
  local selectedIndex=0
  
  unset selectedChoice
  unset selectionVariable
  
  if [[ "${PS1}" == "" ]]; then
    # running via script
    returnOrExit="exit"
  else
    # running via CLI
    returnOrExit="return"
  fi
  
  if [[ "${BASH}" == "" ]]; then
    printf "\n ${red}[ERROR] This function utilizes Bash expansion, but your current shell is \"${SHELL}\"${white}\n"
    $returnOrExit 1
  elif [[ $# == 0 ]]; then
    printf "\n ${red}[ERROR] No arguments provided${white}\n"
    renderHelp
    $returnOrExit 1
  fi
  
  local remainingArgs=()
  while [[ $# -gt 0 ]]; do
    local key="$1"

    case $key in
      -h|--help)
        displayHelp=true
        shift
        ;;
      -i|--index)
        selectedIndex=$2
        shift 2
        ;;
      -m|--max)
        maxViewable=$2
        shift 2
        ;;
      -o|--options)
        menuItems=$2[@]
        menuItems=("${!menuItems}")
        shift 2
        ;;
      -q|--query)
        instruction="$2"
        shift 2
        ;;
      -v|--selectionVariable)
        selectionVariable="$2"
        shift 2
        ;;
      *)
        remainingArgs+=("$1")
        shift
        ;;
    esac
  done

  # just display help
  if $displayHelp; then
    renderHelp
    $returnOrExit 0
  fi

  set -- "${remainingArgs[@]}"
  local itemsLength=${#menuItems[@]}
  
  # no menu items, at least 1 required
  if [[ $itemsLength -lt 1 ]]; then
    printf "\n ${red}[ERROR] No menu items provided${white}\n"
    renderHelp
    $returnOrExit 1
  fi

  renderMenu "$instruction" $selectedIndex $maxViewable
  hideCursor

  while $captureInput; do
    read -rsn3 key # `3` captures the escape (\033'), bracket ([), & type (A) characters.

    case "$key" in
      "$KEY__ARROW_UP")
        selectedIndex=$((selectedIndex-1))
        (( $selectedIndex < 0 )) && selectedIndex=$((itemsLength-1))

        renderMenu "$instruction" $selectedIndex $maxViewable true
        ;;

      "$KEY__ARROW_DOWN")
        selectedIndex=$((selectedIndex+1))
        (( $selectedIndex == $itemsLength )) && selectedIndex=0

        renderMenu "$instruction" $selectedIndex $maxViewable true
        ;;

      "$KEY__ENTER")
        clearLastMenu true
        showCursor
        captureInput=false
        
        if [[ "${selectionVariable}" != "" ]]; then
          printf -v "${selectionVariable}" "${currentSelection}"
        else
          selectedChoice="${currentSelection}"
        fi
        ;;
    esac
  done
}
