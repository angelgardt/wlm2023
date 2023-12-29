#!/bin/bash

function update_books() {

  ## exit with a non-sero status
  set -e
	
	echo -e "====="
  echo -e "${GREEN}RUN BOOKS UPDATER${NC}"
  echo -e "====="
  echo
  
	## read dirs
	deploy_dirs=( $(cut -d ":" -f1 deploy/current-dirs.txt) )
	deploy_names=( $(cut -d ":" -f2 deploy/current-dirs.txt) )
	
  {
    
    #try
    cp index.html docs/index.html
    
  } || {
    
    #catch
    echo -e "-----"
    echo -e "${RED}Deploy not completed${NC}"
    echo -e "${RED}redirecting index.html copying error${NC}"
    echo -e "-----"
    exit
    
  }
  
  echo -e "-----"
  echo -e ${GRAY}redirecting index.html${BLUE} copied${NC}
	echo -e "-----"
		
	echo -e "-----"
	echo -e "${BLUE}Directories to be deployed:${NC}"
	
	for item in ${deploy_dirs[*]}
	do
	  printf "${GRAY}    %s\n${NC}" $item
	done
	echo -e "-----"
    			
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
      echo -e "${RED}=====${NC}"
      echo -e "${RED}Deploy not completed${NC}"
			echo -e "${RED}File copying error${NC}"
			echo -e "${RED}=====${NC}"
			exit
      
    }
    
    echo
		echo -e ${GRAY}"${deploy_dirs[$index]}" ${BLUE}copied${NC}
	done
			
	echo -e "====="
  echo -e "${GREEN}BOOKS UPDATER COMPLETED${NC}"
  echo -e "====="
  echo
  
}
