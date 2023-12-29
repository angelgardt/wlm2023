#!/bin/bash

function info_writer() {
  
  printf "# Last deployment info\n\n" >> docs/README.md
  now=$(LC_ALL=en_EN.utf8 date +"%a %Y-%m-%d %H:%M")
  printf "**Date:** %s\n\n" "$now" >> docs/README.md
  printf "**Mode:** %s\n\n" "$mode" >> docs/README.md
  
  printf "## \`docs\` structure: \n\n" >> docs/README.md
  
  printf "\`\`\`\n" >> docs/README.md
  ls -Ral docs >> docs/README.md
  printf "\`\`\`\n" >> docs/README.md
  
  printf "## Log: \n\n" >> docs/README.md
  printf "\`\`\`\n" >> docs/README.md
  sed -e 's/\x1b\[[0-9;]*m//g' deploy/last.log >> docs/README.md
  printf "\`\`\`\n" >> docs/README.md
  
  rm deploy/last.log
  
}
