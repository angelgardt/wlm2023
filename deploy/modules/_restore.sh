#!/bin/bash

function restore() {
	
	## exit with a non-sero status
  set -e
	
  echo -e "====="
  echo -e "${GREEN}RUN RESTORER${NC}"
  echo -e "====="
  echo
	
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
