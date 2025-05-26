#!/bin/bash
green=$'\e[0;32m'
cyan=$'\e[0;36m'
reset=$'\e[0m'
default="y"
datetime="$(date +"%m-%d-%Y @ %I:%M %p")"
defBranch="main"
read -p "${green}?${reset} Is this the correct folder? ${cyan}[Y/n]${reset} " conf

conf=${conf:-$default}

# branch name
branchName () {
  read -p "${green}?${reset} What's your branch name? ${cyan}[defaults to main]${reset} " branch
    if [[ -z $branch ]]; then
      git push origin $defBranch > /dev/null 2>&1
      echo "${green}!${reset} Your local files are now pushed to $defBranch!"
    else 
      git push origin $branch > /dev/null 2>&1
      echo "${green}!${reset} Your local files are now pushed to $branch!"
    fi
}

# commit message 
commitMesg () {
  read -p "${green}?${reset} What's your commit message? ${cyan}[defaults to current date and time]${reset} " commit
    if [[ -z $commit ]]; then
      git commit -m "commit on $datetime" > /dev/null 2>&1
      branchName
    else
      git commit -m "$commit" > /dev/null 2>&1
      branchName
    fi
}

# add files for staging
addFiles () {
  read -p "${green}?${reset} What files are you staging? ${cyan}[defaults to all]${reset} "
    if [[ "$conf" =~ ^[Yy]$ ]]; then
      git add .
      commitMesg
    else 
      read -p "Input all files needed: " files
      git add $files
      commitMesg
    fi
}

# directory confirmation
folderConf () {
  if [[ "$conf" =~ ^[Yy]$ ]]; then
    addFiles
  else
    exit
  fi
}

# main code executed
if [[ "$conf" =~ ^[Yy]$ ]]; then
  folderConf
else
  exit
fi
