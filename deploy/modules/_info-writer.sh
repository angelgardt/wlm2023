#!/bin/bash

function info_writer() {
  
  printf "# Last deployment info\n\n" >> docs/README.md
  now=$(LC_ALL=en_EN.utf8 date +"%a %Y-%m-%d %H:%M")
  printf "**Date:** %s\n\n" "$now" >> docs/README.md
  printf "**Mode:** %s\n\n" "$mode" >> docs/README.md
  
  printf "## \`docs\` structure: \n\n" >> docs/README.md
  
  ls -Ral docs >> structure.txt
  
  input="structure.txt"
  
  printf "\`\`\`\n" >> docs/README.md
  
  while IFS= read -r line
  do
    printf "%s<br>\n" "$line" >> docs/README.md
  done < "$input"
  
  printf "\`\`\`\n" >> docs/README.md
  
}
