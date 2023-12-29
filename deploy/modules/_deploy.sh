#!/bin/bash

function deploy() {
  
  ## exit with a non-sero status
  set -e
	
	echo -e "${GREEN}\n=====\nRUN DEPLOYER\n=====\n${NC}"
	
	## import functions
	source deploy/modules/_backup.sh
	source deploy/modules/_update-books.sh
	source deploy/modules/_update-slides.sh
	source deploy/modules/_update-analytics.sh
	source deploy/modules/_render-books.sh
	source deploy/modules/_render-slides.sh
	source deploy/modules/_render-analytics.sh
	source deploy/modules/_custom.sh
	
  ## check docs dir exists
	## create if not
	if [ ! -d docs ]
	then
	
		mkdir docs
		touch docs/README.md
		echo date >> docs/README.md
		
		echo -e "${BLUE}new ${GRAY}docs${BLUE} directory created${NC}"
		
	fi

	## make docs backup
	{
	  backup
	} || {
	  echo -e "${RED}\n=====\n=====${NC}"
		echo -e "${RED}DEPLOYMENT NOT COMPLETED${NC}"
		echo -e "${RED}Backup error${NC}"
		echo -e "${RED}=====\n=====\n${NC}"
		exit
	}
	
	## remove old docs
	rm -rf docs
	echo -e "${BLUE}old ${GRAY}docs${BLUE} directory removed${NC}"
	
	mkdir docs
	touch docs/README.md
	
	echo -e "${BLUE}new ${GRAY}docs${BLUE} directory created${NC}"
	echo
	
	## if reset
	if [ "$mode" = "reset" ]
	then
	  
	  ## exit
		echo -e "${GREEN}\n=====${NC}"
		echo -e "${GREEN}RESET COMPLETED${NC}"
		echo -e "Now your docs directory contains only empty README.md file"
		echo -e "${GREEN}=====\n${NC}"
		exit
	
	## if custom
	elif [ "$mode" = "custom" ]
	then
	  
	  ## TODO
	  
	  ### read dirs and mode from line args
	  ### create current-dirs.txt to pass to _custom.sh
	  
	  ## run custom script with try-catch logic
	  {
	    custom_deploy
	  } || {
	    echo -e "${RED}\n=====\n=====${NC}"
      echo -e "${RED}DEPLOYMENT NOT COMPLETED${NC}"
      echo -e "${RED}Custom deploy error${NC}"
      echo -e "${RED}=====\n=====\n${NC}"
      exit
	  }
  
  ## update or render all
  else
    
	  ## check dirs.txt exists
  	## abort function if not
  	if [ ! -f deploy/dirs.txt ]
  	then
  		
  		echo -e "${RED}\n=====\n=====${NC}"
  		echo -e "${RED}DEPLOYMENT NOT COMPLETED${NC}"
  		echo -e "${RED}File ${GRAY}dirs.txt${RED} does not exists${NC}"
  		echo -e "Create a ${GRAY}dirs.txt${NC} file in ${GRAY}deploy${NC} folder with a list of directories (each on a new line) that have to be deployed"
  		echo -e "Format of each line: ${GRAY}<original_dir_name>:<deployed_dir_name>${NC}"
  		echo -e "${RED}=====\n=====\n${NC}"
  		exit
  	
  	fi
		
		## make temporary current dirs file for updaters and renderers
		cp deploy/dirs.txt deploy/current-dirs.txt
		
	  ## if render
	  if [ "$mode" = "render" ]
	  then
	    
	    ## run render scripts with try-catch logic
	    ### render books
	    {
	      render_books
	    } || {
	      echo -e "${RED}=====\n=====${NC}"
	      echo -e "${RED}DEPLOYMENT NOT COMPLETED${NC}"
	      echo -e "${RED}Books render error${NC}"
	      echo -e "${RED}=====\n=====\n${NC}"
	      exit
	    }
	    
	    ### render slides
	    {
	      render_slides
	    } || {
	      echo -e "${RED}=====\n=====${NC}"
	      echo -e "${RED}DEPLOYMENT NOT COMPLETED${NC}"
	      echo -e "${RED}Slides render error${NC}"
	      echo -e "${RED}=====\n=====\n${NC}"
	      exit
	    }
	    
	    ### render analytics
	    {
	      render_analytics
	    } || {
  	    echo -e "${RED}=====\n=====${NC}"
  	    echo -e "${RED}DEPLOYMENT NOT COMPLETED${NC}"
  	    echo -e "${RED}Analytics render error${NC}"
  	    echo -e "${RED}=====\n=====\n${NC}"
  	    echo
  	    exit
	    }
	
	  fi
		
		## then update
	  ## run update scripts with try-catch logic
	  
	  ### update books
	  {
	    update_books
	  } || {
	    echo -e "${RED}=====\n=====${NC}"
	    echo -e "${RED}DEPLOYMENT NOT COMPLETED${NC}"
	    echo -e "${RED}Books update error${NC}"
	    echo -e "${RED}=====\n=====\n${NC}"
	    exit
	  }
	  
	  ### update slides
	  {
	    update_slides
	  } || {
	    echo -e "${RED}=====\n=====${NC}"
	    echo -e "${RED}DEPLOYMENT NOT COMPLETED${NC}"
	    echo -e "${RED}Slides update error${NC}"
	    echo -e "${RED}=====\n=====\n${NC}"
	    exit
	  }
	  
	  ### update analytics
	  {
	    update_analytics
	  } || {
	    echo -e "${RED}=====\n=====${NC}"
	    echo -e "${RED}DEPLOYMENT NOT COMPLETED${NC}"
	    echo -e "${RED}Analytics update error${NC}"
	    echo -e "${RED}=====\n=====\n${NC}"
	    exit
	  }
	  
	fi
	
	## remove temporary current dirs file
	if [ -f deploy/current-dirs.txt ]
	then
	  rm deploy/current-dirs.txt
	fi
	
	## add deployment info to docs/README.md
	now=$(date +"%Y-%m-%d %H:%M")
	printf "# Last deployment info\n\n" >> docs/README.md
	printf "Date: %s\n" "$now" >> docs/README.md
	printf "Mode: %s\n\n" "$mode" >> docs/README.md
	###### TODO
	###### add flag info for custom mode
	printf "## \`docs\` structure: \n" >> docs/README.md
	ls -Ral docs >> docs/README.md
	
	echo -e "${GREEN}\n==========\n==========${NC}"
	echo -e "${GREEN}DEPLOYMENT COMPLETED${NC}"
	echo -e "${GREEN}==========\n==========${NC}"
	echo -e "${GRAY}Commit and push changes to remote\n${NC}"
  
  # reset text color
	echo -e "${NC}"
	
}
