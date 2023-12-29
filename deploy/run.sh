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
if [[ ! ${modes[@]} =~ $mode ]]
then
	
	echo -e "${RED}=====${NC}"
	echo -e "${RED}RUN FAILED${NC}"
	echo -e "${RED}Unknown first inline argument${NC}"
	echo -e "Valid options are ${GRAY}${modes[@]}${NC} (first is default)"
	echo -e "${RED}=====${NC}"
	echo
	exit
	
fi


if [ "$1" = "restore" ]
then
  
  restore
  
else
  
  deploy "$mode"
  
fi
