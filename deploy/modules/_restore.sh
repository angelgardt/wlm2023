#!/bin/bash

function restore() {
	
	## exit with a non-sero status
  set -e
	
  echo -e "${GREEN}\n=====\nRUN RESTORER\n=====\n${NC}"
	
	if [ ! -d deploy/docs_backup ]; then
			echo -e "${RED}=====${NC}"
			echo -e "${RED}RESTORE FAILED${NC}"
			echo -e "${RED}No ${GRAY}docs_backup ${RED}folder${NC}"
			echo -e "${RED}=====\n${NC}"
			exit
	fi
	
	
	if [ -d docs ]; then
			rm -rf docs
			echo -e "${BLUE}old docs directory removed${NC}"
	fi
	
	mkdir docs
	
	echo -e "${BLUE}docs directory created${NC}"
	
  cp -r deploy/docs_backup/* docs
  
	echo -e "${BLUE}files copied${NC}"
	
	rm -rf deploy/docs_backup
	
	echo -e "${BLUE}backup folder removed${NC}"
	
	echo -e "${GREEN}\n=====\nRESTORE COMPLETED\n=====\n${NC}"
	
}
