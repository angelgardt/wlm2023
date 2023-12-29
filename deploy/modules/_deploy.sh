#!/bin/bash

function deploy() {
  
  ## exit with a non-sero status
  set -e
	
	printf "${GREEN}\n=====\nRUN DEPLOYER\n=====\n\n${NC}"
	
	## import functions
	source deploy/modules/_backup.sh
	source deploy/modules/_update-books.sh
	source deploy/modules/_update-slides.sh
	source deploy/modules/_update-analytics.sh
	source deploy/modules/_render-books.sh
	source deploy/modules/_render-slides.sh
	source deploy/modules/_render-analytics.sh
	source deploy/modules/_custom.sh
	source deploy/modules/_info-writer.sh
	
  ## check docs dir exists
	## create if not
	if [ ! -d docs ]
	then
	
		mkdir docs
		touch docs/README.md
		
		printf "${BLUE}new ${GRAY}docs${BLUE} directory created\n${NC}"
		
	fi

	## make docs backup
	{
	  backup
	} || {
	  printf "${RED}\n=====\n=====\n${NC}"
		printf "${RED}DEPLOYMENT NOT COMPLETED\n${NC}"
		printf "${RED}Backup error\n${NC}"
		printf "${RED}=====\n=====\n\n${NC}"
		exit
	}
	
	## remove old docs
	rm -rf docs
	printf "${BLUE}old ${GRAY}docs${BLUE} directory removed\n${NC}"
	
	mkdir docs
	touch docs/README.md
	
	printf "${BLUE}new ${GRAY}docs${BLUE} directory created\n\n${NC}"
	
	## if reset
	if [ "$mode" = "reset" ]
	then
	  
	  ## exit
		printf "${GREEN}\n=====\n${NC}"
		printf "${GREEN}RESET COMPLETED\n${NC}"
		printf "Now your docs directory contains only empty README.md file\n"
		printf "${GREEN}=====\n\n${NC}"
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
	    printf "${RED}\n=====\n=====\n${NC}"
      printf "${RED}DEPLOYMENT NOT COMPLETED\n${NC}"
      printf "${RED}Custom deploy error\n${NC}"
      printf "${RED}=====\n=====\n\n${NC}"
      exit
	  }
  
  ## update or render all
  else
    
	  ## check dirs.txt exists
  	## abort function if not
  	if [ ! -f deploy/dirs.txt ]
  	then
  		
  		printf "${RED}\n=====\n=====\n${NC}"
  		printf "${RED}DEPLOYMENT NOT COMPLETED\n${NC}"
  		printf "${RED}File ${GRAY}dirs.txt${RED} does not exists\n${NC}"
  		printf "Create a ${GRAY}dirs.txt${NC} file in ${GRAY}deploy${NC} folder with a list of directories (each on a new line) that have to be deployed\n"
  		printf "Format of each line: ${GRAY}<original_dir_name>:<deployed_dir_name>\n${NC}"
  		printf "${RED}=====\n=====\n\n${NC}"
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
	      printf "${RED}=====\n=====\n${NC}"
	      printf "${RED}DEPLOYMENT NOT COMPLETED\n${NC}"
	      printf "${RED}Books render error\n${NC}"
	      printf "${RED}=====\n=====\n\n${NC}"
	      exit
	    }
	    
	    ### render slides
	    {
	      render_slides
	    } || {
	      printf "${RED}=====\n=====\n${NC}"
	      printf "${RED}DEPLOYMENT NOT COMPLETED\n${NC}"
	      printf "${RED}Slides render error\n${NC}"
	      printf "${RED}=====\n=====\n\n${NC}"
	      exit
	    }
	    
	    ### render analytics
	    {
	      render_analytics
	    } || {
  	    printf "${RED}=====\n=====\n${NC}"
  	    printf "${RED}DEPLOYMENT NOT COMPLETED\n${NC}"
  	    printf "${RED}Analytics render error\n${NC}"
  	    printf "${RED}=====\n=====\n\n${NC}"
  	    exit
	    }
	
	  fi
		
		## then update
	  ## run update scripts with try-catch logic
	  
	  ### update books
	  {
	    update_books
	  } || {
	    printf "${RED}=====\n=====\n${NC}"
	    printf "${RED}DEPLOYMENT NOT COMPLETED\n${NC}"
	    printf "${RED}Books update error\n${NC}"
	    printf "${RED}=====\n=====\n\n${NC}"
	    exit
	  }
	  
	  ### update slides
	  {
	    update_slides
	  } || {
	    printf "${RED}=====\n=====\n${NC}"
	    printf "${RED}DEPLOYMENT NOT COMPLETED\n${NC}"
	    printf "${RED}Slides update error\n${NC}"
	    printf "${RED}=====\n=====\n\n${NC}"
	    exit
	  }
	  
	  ### update analytics
	  {
	    update_analytics
	  } || {
	    printf "${RED}=====\n=====\n${NC}"
	    printf "${RED}DEPLOYMENT NOT COMPLETED\n${NC}"
	    printf "${RED}Analytics update error\n${NC}"
	    printf "${RED}=====\n=====\n\n${NC}"
	    exit
	  }
	  
	fi
	
	## remove temporary current dirs file
	if [ -f deploy/current-dirs.txt ]
	then
	  rm deploy/current-dirs.txt
	fi
	
	## add deployment info to docs/README.md
	
	info_writer $mode
	
	## message deploy success
	printf "${GREEN}\n==========\n==========\n${NC}"
	printf "${GREEN}DEPLOYMENT COMPLETED\n${NC}"
	printf "${GREEN}==========\n==========\n${NC}"
	printf "${GRAY}Commit and push changes to remote\n\n\n${NC}"
	
}
