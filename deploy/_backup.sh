#/bin/bash

function backuper {
  
  ## exit with a non-sero status
  set -e
	
	## set colors
	RED='\033[0;31m'
	BLUE='\033[0;34m'
	GREEN='\033[0;32m'
	GRAY='\033[0;37m'
	NC='\033[0m' # no color
	
  echo -e "====="
  echo -e "${GREEN}RUN BACKUPER${NC}"
  echo -e "====="
  echo
  
  ## make backup
  ### remove old backup
  if [ -d deploy/docs_backup ]
  then
    rm -rf deploy/docs_backup
  fi
  
  echo -e "-----"
  echo -e "${BLUE}old backup removed${NC}"
  echo -e "-----"
  
  ### make new backup
  mkdir deploy/docs_backup
  cp -r docs/* deploy/docs_backup 
  
  echo -e "-----"
  echo -e "${BLUE}new backup done${NC}"
  echo -e "-----"
  
  echo -e "====="
  echo -e "${GREEN}BACKUP COMPLETED${NC}"
  echo -e "====="
  echo
  
}

backuper
