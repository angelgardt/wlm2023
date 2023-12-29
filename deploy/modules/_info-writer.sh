#!/bin/bash

function info_writer() {
  
  ## title
  printf "# Last deployment info\n\n" >> docs/README.md
  ## write date
  now=$(LC_ALL=en_EN.utf8 date +"%a %Y-%m-%d %H:%M")
  printf "**Date:** %s\n\n" "$now" >> docs/README.md
  ## write mode
  printf "**Mode:** %s\n\n" "$mode" >> docs/README.md
  
  ## write structure of docs directory
  printf "## \`docs\` structure: \n\n" >> docs/README.md
  
  ## add backticks for code formating
  printf "\`\`\`\n" >> docs/README.md
  ## list all files recursively and sen to readme
  ls -Ral docs >> docs/README.md
  printf "\`\`\`\n" >> docs/README.md
  
  ## write log
  printf "## Log: \n\n" >> docs/README.md
  
  ## add backticks for code formating
  printf "\`\`\`\n" >> docs/README.md
  ## remove color codes from log and send to readme
  sed -e 's/\x1b\[[0-9;]*m//g' deploy/last.log >> docs/README.md
  printf "\`\`\`\n" >> docs/README.md
  
  ## remove log file
  rm deploy/last.log
  
}
