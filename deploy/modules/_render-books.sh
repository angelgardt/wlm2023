#!/bin/bash

function render_books() {
  
  ## exit with a non-sero status
  set -e
	
	printf "${GREEN}\n=====\nRUN BOOKS UPDATER\n=====\n\n${NC}"
  
	## read dirs
	deploy_dirs=( $(cut -d ":" -f1 deploy/current-dirs.txt) )
	deploy_names=( $(cut -d ":" -f2 deploy/current-dirs.txt) )
	
	# print dirs to render
	printf "${BLUE}\nDirectories to render:\n${NC}"
	
	for item in ${deploy_dirs[*]}
	do
	  printf "${GRAY}    %s\n${NC}" $item
	done
	printf "\n"
	
	## for each folder in directories list
	for index in ${!deploy_dirs[*]}
	do
	  
	  # remove old _book dir
	  rm -r `echo "${deploy_dirs[$index]}"/_book/`
	  printf "${GRAY}%s/_book/ ${BLUE}removed${NC}\n" "${deploy_dirs[$index]}"
		
		# render dir
		{
		  # try
			quarto render ${deploy_dirs[$index]} --to html
		} || {
		  # catch
		  return 1
		}
		
		# print dir render success
		printf "${GRAY}%s ${BLUE}rendered${NC}\n" "${deploy_dirs[$index]}"
		
	done
	
	printf "${GREEN}\n=====\nBOOKS RENDER COMPLETED\n=====\n\n${NC}"
  
}
