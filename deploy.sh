#!/bin/bash

function deployer {

	set -e
	
	RED='\033[0;31m'
	BLUE='\033[0;34m'
	GREEN='\033[0;32m'
	GRAY='\033[0;37m'
	NC='\033[0m' # No Color
  
  # pass inline arg to var
  mode="${1:-update}"
  # check deploy_dirs.txt exists
  # abort function if not
	if [ ! -f deploy_dirs.txt ]; then
		
		echo -e "${RED}=====${NC}"
		echo -e "${RED}Deploy not completed${NC}"
		echo -e "${RED}File deploy_dirs.txt does not exists${NC}"
		echo -e "Create a deploy_dirs.txt file with a list of direstories (each on a new line) that have to be deployed"
		echo -e "Format of each line: ${GRAY}<original_dir_name>:<deployed_dir_name>${NC}"
		echo -e "${RED}=====${NC}"
	
	# check mode
	# abort function if not valid
	elif [ "$mode" != "update" ] && [ "$PHONE_TYPE" != "reset" ] && [ "$PHONE_TYPE" != "render" ]; then
		
		echo -e "${RED}=====${NC}"
		echo -e "${RED}Deploy not completed${NC}"
		echo -e "${RED}Uknown inline argument${NC}"
		echo -e "Valid options are ${GRAY}update${NC} (default), ${GRAY}render${NC} or ${GRAY}reset${NC}"
		echo -e "${RED}=====${NC}"
	
	else
	  
		# read deploy_dirs.txt
		deploy_dirs=( $(cut -d ":" -f1 deploy_dirs.txt) )
		deploy_names=( $(cut -d ":" -f2 deploy_dirs.txt) )
		
		# check docs dir exists
		# create if not
		if [ ! -d docs ]; then
			mkdir docs
			touch docs/README.md
			echo -e "-----"
			echo -e "${BLUE}docs directory created${NC}"
			echo -e "-----"
		fi

    # check mode
    if [ "$mode" != "update" ]; then
      # if reset or update
      rm -rf docs
			echo -e "-----"
			echo -e "${BLUE}docs directory removed${NC}"
			echo -e "-----"
			mkdir docs
			touch docs/README.md
			echo -e "-----"
			echo -e "${BLUE}docs directory created${NC}"
			echo -e "-----"
		fi
			
		# check mode
		if [ "$mode" = "reset" ]; then
		  
		  # if reset
		  ls -Ral docs
		  echo -e "${GREEN}=====${NC}"
		  echo -e "${GREEN}Reset completed${NC}"
		  echo -e "Now your docs directory contains only empty README.md file"
		  echo -e "${GREEN}=====${NC}"
		  
		else
		  
		  # if update or render
		  # check mode
		  if [ "$mode" = "render" ]; then
		    
		    # if render
		    # print dirs to render
		    echo -e "-----"
  	    echo -e "${BLUE}Directories to be rendered:${NC}"
  	    for item in ${deploy_dirs[*]}
  	    do
  		    printf "${GRAY}    %s\n${NC}" $item
  	    done
  	    echo "-----"
  	    
		    for index in ${!deploy_dirs[*]}
		    do
		      # remove old _book dirs
		      rm -rf `echo "${deploy_dirs[$index]}"/_book/`
		      # render dirs
		      quatro render ${deploy_dirs[$index]} --to html
		      # print dir render success
		      echo -e "-----"
		      echo -e "${GRAY}${deploy_dirs[$index]} ${BLUE}rendered${NC}"
		      echo -e "-----"
		    done
		    
		    # print render success
		    echo -e "${GREEN}=====${NC}"
		    echo -e "${GREEN}Render completed${NC}"
		    echo -e "${GREEN}=====${NC}"
		    
		  fi
  	  
    	echo -e "-----"
    	echo -e "${BLUE}Directories to be deployed:${NC}"
    	for item in ${deploy_dirs[*]}
    	do
    		printf "${GRAY}    %s\n" $item
    	done
    	echo -e "-----"
    	
    	for index in ${!deploy_dirs[*]}
    	do
    		if [ ! -d docs/"${deploy_names[$index]}" ]; then
    			mkdir docs/"${deploy_names[$index]}"
    			echo -e "-----"
    			echo -e ${GRAY}docs/"${deploy_names[$index]}" ${BLUE}created${NC}
    			echo "-----"
    		fi
    		
    		cp -R `echo "${deploy_dirs[$index]}"/_book/*` `echo docs/"${deploy_names[$index]}"`
    		echo "-----"
    		echo ${GRAY}"${deploy_dirs[$index]}" ${BLUE}copied${NC}
    		echo "-----"
    	done
    
    fi
  	
  	# print list of docs files
  	ls -Ral docs
  	# print deploy success
  	echo "====="
  	echo "Deploy completed"
  	echo "====="
  
  fi
}

deployer $1