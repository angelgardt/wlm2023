#/bin/bash

function backup() {
  
  ## exit with a non-sero status
  set -e
	
  echo -e "${GREEN}\n=====\nRUN BACKUPER\n=====\n${NC}"
  
  ## make backup
  ### remove old backup
  if [ -d deploy/backup ]
  then
    rm -rf deploy/backup
  fi
  
  echo -e "${BLUE}old backup removed${NC}"
  
  ### make new backup
  mkdir deploy/backup
  cp -r docs/* deploy/backup 
  
  echo -e "${BLUE}new backup done${NC}"
  
  echo -e "${GREEN}\n=====\nBACKUP COMPLETED\n=====\n${NC}"
  
}
