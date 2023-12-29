#!/bin/bash

function restorer {
	
	## exit with a non-sero status
  set -e
	
	## set colors
	RED='\033[0;31m'
	BLUE='\033[0;34m'
	GREEN='\033[0;32m'
	GRAY='\033[0;37m'
	NC='\033[0m' # no color
	
  echo -e "====="
  echo -e "${GREEN}RUN RESTORER${NC}"
  echo -e "====="
	
	if [ ! -d deploy/docs_backup ]; then
			echo -e "====="
			echo -e "${RED}RESTORE FAILED${NC}"
			echo -e "${RED}No ${GRAY}docs_backup ${RED}folder${NC}"
			echo -e "====="
			exit
	fi
	
	
	if [ -d docs ]; then
			rm -rf docs
			echo -e "-----"
			echo -e "${BLUE}old docs directory removed${NC}"
			echo -e "-----"
	fi
	
	mkdir docs
	
	echo -e "-----"
	echo -e "${BLUE}docs directory created${NC}"
	echo -e "-----"
	
  cp -r deploy/docs_backup/* docs
  
  echo -e "-----"
	echo -e "${BLUE}files copied${NC}"
	echo -e "-----"
	
	rm -rf deploy/docs_backup
	
	echo -e "-----"
	echo -e "${BLUE}backup folder removed${NC}"
	echo -e "-----"
	
	echo -e "${GREEN}=====${NC}"
  echo -e "${GREEN}RESTORE COMPLETED${NC}"
  echo -e "${GREEN}=====${NC}"
  echo
	
}

restorer
