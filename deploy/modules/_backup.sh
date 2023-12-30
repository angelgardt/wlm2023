#/bin/bash

function backup() {
  
  ## exit with a non-sero status
  set -e
	
  printf "${GREEN}\n=====\nRUN BACKUPER\n=====\n\n${NC}"
  
  ## make backup
  ### remove old backup
  if [ -d deploy/backup ]
  then
    rm -rf deploy/backup
  fi
  
  printf "${BLUE}old ${GRAY}backup${BLUE} removed\n${NC}"
  
  ### make new backup
  mkdir deploy/backup
  cp -r docs/* deploy/backup 
  
  printf "${BLUE}new ${GRAY}backup${BLUE} done\n${NC}"
  
  printf "${GREEN}\n=====\nBACKUP COMPLETED\n=====\n\n${NC}"
  
}
