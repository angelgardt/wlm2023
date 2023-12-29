#!/bin/bash

## import functions and colors
source deploy/modules/_set-colors.sh
source deploy/modules/_deploy.sh
source deploy/modules/_restore.sh

## make modes array
modes=( "update" "render" "reset" "custom" "restore" )

## assign inline arg to var, if no --- assign update
mode="${1:-${modes[0]}}"

## check mode
## abort function if not valid
mode_check="\<${mode}\>" # extract a regex that matches the exact value of the argument

if [[ ! ${modes[@]} =~ $mode_check ]]
then
	
	echo -e "${RED}\n=====\n=====${NC}"
	echo -e "${RED}RUN FAILED${NC}"
	echo -e "${RED}Unknown first inline argument${NC}"
	echo -e "Valid options are ${GRAY}${modes[@]}${NC} (first is default)"
	echo -e "${RED}=====\n=====\n${NC}"
	exit
	
fi


if [ "$1" = "restore" ]
then
  
  restore
  
else
  
  deploy "$mode"
  
fi
