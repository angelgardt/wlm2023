#!/bin/bash

function deployer {
  
  # exit with a non-sero status
  set -e
	
	# set colors
	RED='\033[0;31m'
	BLUE='\033[0;34m'
	GREEN='\033[0;32m'
	GRAY='\033[0;37m'
	NC='\033[0m' # no color
	
	# make modes array
	modes=("update" "render" "reset" "custom")

	# assign inline arg to var, if no --- assign update
	mode="${1:-${modes[0]}}"
	
	# check mode
	# abort function if not valid
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
	
	## if reset
	if [ "$mode" = "reset" ]; then
	  
	  ## run reset script
	  bash deploy/_reset.sh
	  
	elif [ "$mode" = "update" ]; then
	  
	  bash deploy/_update.sh
	  
	elif [ "$mode" = "render" ]; then
	  
	  bash deploy/_render.sh
	
	elif [ "$mode" = "custom" ]; then
	  
	  bash deploy/_custom.sh
	  
	fi
	
	
	# check deploy_dirs.txt exists
	# abort function if not
	if [ ! -f deploy/dirs.txt ]
	then
		
		echo -e "${RED}=====${NC}"
		echo -e "${RED}Deploy not completed${NC}"
		echo -e "${RED}File deploy_dirs.txt does not exists${NC}"
		echo -e "Create a ${GRAY}dirs.txt${NC} file in ${GRAY}deploy${NC} folder with a list of directories (each on a new line) that have to be deployed"
		echo -e "Format of each line: ${GRAY}<original_dir_name>:<deployed_dir_name>${NC}"
		echo -e "${RED}=====${NC}"
		exit
	
	fi
	
  
}


deployer $@