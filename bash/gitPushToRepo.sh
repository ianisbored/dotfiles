#!/bin/bash
default="y"
datetime="$(date +"%m-%d-%Y @ %I:%M %p")"
defBranch="main"
read -p "Is this the correct folder? [Y/n] " conf

conf=${conf:-$default}

# branchName
branchName () {
  read -p "What's your branch name? [defaults to main]" branch
    if [[ -z $branch ]]; then
      git push origin $defBranch > /dev/null 2>&1
      echo "Your local files are now pushed to $defBranch!"
    else 
      git push origin $branch > /dev/null 2>&1
      echo "Your local files are now pushed to $branch!"
    fi
}

# commit message 
commitMesg () {
  read -p "What's your commit message? " commit
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
  read -p "Input files to stage: "
    if [[ "$conf" =~ ^[Yy]$ ]]; then
      git add . > /dev/null 2>&1
      commitMesg
    else 
      read -p "Input all files needed: " files
      git add $files > /dev/null 2>&1
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

