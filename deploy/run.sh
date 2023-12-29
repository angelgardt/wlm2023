#!/bin/bash

function deployer {
  
  ## exit with a non-sero status
  set -e
	
	## set colors
	RED='\033[0;31m'
	BLUE='\033[0;34m'
	GREEN='\033[0;32m'
	GRAY='\033[0;37m'
	NC='\033[0m' # no color
	
	echo -e "====="
  echo -e "${GREEN}RUN DEPLOYER${NC}"
  echo -e "====="
  echo
  
	## make modes array
	modes=("update" "render" "reset" "custom")

	## assign inline arg to var, if no --- assign update
	mode="${1:-${modes[0]}}"
	
	## check mode
	## abort function if not valid
	if [[ ! ${modes[@]} =~ $mode ]]
	then
		
		echo -e "${RED}=====${NC}"
		echo -e "${RED}Deployment not completed${NC}"
		echo -e "${RED}Unknown first inline argument${NC}"
		echo -e "Valid options are ${GRAY}${modes[@]}${NC} (first is default)"
		echo -e "${RED}=====${NC}"
		echo
		exit
		
	fi
	
	  ## check docs dir exists
		## create if not
		if [ ! -d docs ]
		then
		
			mkdir docs
			touch docs/README.md
			echo date >> docs/README.md
			
			echo -e "-----"
			echo -e "${BLUE}new docs directory created${NC}"
			echo -e "-----"
			
	fi

	## make docs backup
	bash deploy/_backup.sh
	
	## remove old docs
	rm -rf docs
	echo -e "-----"
	echo -e "${BLUE}old ${GRAY}docs${BLUE} directory removed${NC}"
	echo -e "-----"
	
	mkdir docs
	touch docs/README.md
	now=$(date)
	echo $now >> docs/README.md
	
	echo -e "-----"
	echo -e "${BLUE}new ${GRAY}docs${BLUE} directory created${NC}"
	echo -e "-----"
	echo
	
	## if reset
	if [ "$mode" = "reset" ]
	then
	  
	  ## exit
	  ls -a docs
		echo -e "${GREEN}=====${NC}"
		echo -e "${GREEN}RESET COMPLETED${NC}"
		echo -e "Now your docs directory contains only empty README.md file"
		echo -e "${GREEN}=====${NC}"
		echo
		exit
	
	## if custom
	elif [ "$mode" = "custom" ]
	then
	  
	  ## TODO
	  
	  ### read dirs and mode from line args
	  ### create current-dirs.txt to pass to _custom.sh
	  
	  ## run custom script
	  bash deploy/_custom.sh
  
  ## update or render all
  else
    
	  ## check dirs.txt exists
  	## abort function if not
  	if [ ! -f deploy/dirs.txt ]
  	then
  		
  		echo -e "${RED}=====${NC}"
  		echo -e "${RED}Deployment not completed${NC}"
  		echo -e "${RED}File ${GRAY}dirs.txt${RED} does not exists${NC}"
  		echo -e "Create a ${GRAY}dirs.txt${NC} file in ${GRAY}deploy${NC} folder with a list of directories (each on a new line) that have to be deployed"
  		echo -e "Format of each line: ${GRAY}<original_dir_name>:<deployed_dir_name>${NC}"
  		echo -e "${RED}=====${NC}"
  		exit
  	
  	fi
		
		## make temporary current dirs file for updaters and renderers
		cp deploy/dirs.txt deploy/current-dirs.txt
		
	  ## if render
	  if [ "$mode" = "render" ]
	  then
	    
	    ## run render scripts
	    bash deploy/_render-books.sh
	    bash deploy/_render-analytics.sh
	    bash deploy/_render-slides.sh
	
	  fi
		
		## then update
		
	  ## run update scripts
	  bash deploy/_update-books.sh
	  bash deploy/_update-slides.sh
	  bash deploy/_update-analytics.sh
	    
	  ## remove temporary current dirs file
	  rm deploy/current-dirs.txt
	  
	fi
  
}


deployer $@
