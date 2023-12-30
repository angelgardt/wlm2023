#!/bin/bash

function restore() {
	
	## exit with a non-sero status
  set -e
	
  printf "${GREEN}\n=====\nRUN RESTORER\n=====\n\n${NC}"
	
	if [ ! -d deploy/backup ]; then
			printf "${RED}\n=====\n${NC}"
			printf "${RED}RESTORE FAILED\n${NC}"
			printf "${RED}No ${GRAY}docs_backup ${RED}folder\n${NC}"
			printf "${RED}=====\n\n${NC}"
			exit
	fi
	
	
	if [ -d docs ]; then
			rm -rf docs
			echo -e "${BLUE}old ${GRAY}docs${BLUE} directory removed\n${NC}"
	fi
	
	mkdir docs
	
	echo -e "${GRAY}docs${BLUE} directory created\n${NC}"
	
  cp -r deploy/backup/* docs
  
	echo -e "${BLUE}files copied\n${NC}"
	
	rm -rf deploy/backup
	
	echo -e "${GRAY}backup${BLUE} folder removed\n${NC}"
	
	echo -e "${GREEN}\n=====\nRESTORE COMPLETED\n=====\n${NC}"
	
}
