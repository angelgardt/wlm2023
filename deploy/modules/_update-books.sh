#!/bin/bash

function update_books() {

  ## exit with a non-sero status
  set -e
	
	printf "${GREEN}\n=====\nRUN BOOKS UPDATER\n=====\n\n${NC}"
  
	## read dirs
	deploy_dirs=( $(cut -d ":" -f1 deploy/current-dirs.txt) )
	deploy_names=( $(cut -d ":" -f2 deploy/current-dirs.txt) )
	
  {
    # try
    cp other/redirect_index.html docs/index.html
  } || {
    # catch
    printf "${RED}\n=====\n${NC}"
    printf "${RED}DEPLOYMENT NOT COMPLETED\n${NC}"
    printf "${RED}redirecting index.html copying error\n${NC}"
    printf "${RED}=====\n\n${NC}"
    exit
  }
  
  printf "${GRAY}redirecting index.html${BLUE} copied\n${NC}"
  
  ## print dirs to deploy
	printf "${BLUE}\nDirectories to be deployed:\n${NC}"
	
	for item in ${deploy_dirs[*]}
	do
	  printf "${GRAY}    %s\n${NC}" $item
	done
	printf "\n"
	
	## for each folder in directories list
  for index in ${!deploy_dirs[*]}
  do
    
    ## check if folder in docs exists
    ## create if not
    if [ ! -d docs/"${deploy_names[$index]}" ]
    then
      mkdir docs/"${deploy_names[$index]}"
      printf "${GRAY}docs/%s ${BLUE}created\n${NC}" "${deploy_names[$index]}"
    fi
    
    ## copy all files recursively
    { 
      # try
      cp -r `echo "${deploy_dirs[$index]}"/_book/*` `echo docs/"${deploy_names[$index]}"` 
    } || {
      
      # catch
      printf "${RED}\n=====\n${NC}"
      printf "${RED}DEPLOYMENT NOT COMPLETED\n${NC}"
			printf "${RED}File copying error\n${NC}"
			printf "${RED}=====\n\n${NC}"
			exit
    }
    
		printf "${GRAY}%s ${BLUE}copied\n${NC}" "${deploy_dirs[$index]}"
		
	done
			
	printf "${GREEN}\n=====\nBOOKS UPDATE COMPLETED\n=====\n\n${NC}"
  
}
