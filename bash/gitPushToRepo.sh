#!/bin/bash
default="y"
datetime="$(date +"%m-%d-%Y @ %I:%M %p")"
read -p "Is this the correct folder? [Y/n] " conf

conf=${conf:-$default}

# commit message 
commitMesg () {
  read -p "What's your commit message? " commit
    if [[ -z $commit ]]; then
      git commit -m "commit on $datetime"
    else
      git commit -m "$commit"
    fi
}

# add files for staging
addFiles () {
  read -p "Input files to stage: "
    if [[ "$conf" =~ ^[Yy]$ ]]; then
      git add .
      echo "Added all files for staging."
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

