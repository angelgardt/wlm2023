#!/bin/bash

function update_books() {

  ## exit with a non-sero status
  set -e
	
	echo -e "${GREEN}=====\nRUN BOOKS UPDATER\n=====${NC}"
  echo
  
	## read dirs
	deploy_dirs=( $(cut -d ":" -f1 deploy/current-dirs.txt) )
	deploy_names=( $(cut -d ":" -f2 deploy/current-dirs.txt) )
	
  {
    
    #try
    cp index.html docs/index.html
    
  } || {
    
    #catch
    echo -e "${RED}=====${NC}"
    echo -e "${RED}DEPLOYMENT NOT COMPLETED{NC}"
    echo -e "${RED}redirecting index.html copying error${NC}"
    echo -e "${RED}=====\n${NC}"
    exit
    
  }
  
  echo -e "${GRAY}redirecting index.html${BLUE} copied${NC}\n"

	echo -e "${BLUE}Directories to be deployed:${NC}"
	
	for item in ${deploy_dirs[*]}
	do
	  printf "${GRAY}    %s\n${NC}" $item
	done
    			
  for index in ${!deploy_dirs[*]}
  do
    
    if [ ! -d docs/"${deploy_names[$index]}" ]
    then
      mkdir docs/"${deploy_names[$index]}"
      echo -e ${GRAY}docs/"${deploy_names[$index]}" ${BLUE}created${NC}
    fi
    
    { 
      
      # try
      cp -r `echo "${deploy_dirs[$index]}"/_book/*` `echo docs/"${deploy_names[$index]}"` 
      
    } || {
      
      # catch
      echo -e "${RED}\n=====${NC}"
      echo -e "${RED}DEPLOYMENT NOT COMPLETED${NC}"
			echo -e "${RED}File copying error${NC}"
			echo -e "${RED}=====\n${NC}"
			exit
      
    }
    
		echo -e ${GRAY}"${deploy_dirs[$index]}" ${BLUE}copied${NC}
	done
			
	echo -e "${GREEN}=====\nBOOKS UPDATE COMPLETED\n=====\n${NC}"
  
}
