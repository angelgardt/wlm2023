#!/bin/bash

function deploy() {
  
  ## exit with a non-sero status
  set -e
	
	echo -e "====="
  echo -e "${GREEN}RUN DEPLOYER${NC}"
  echo -e "====="
  echo
	
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
		
		echo -e "-----"
		echo -e "${BLUE}new docs directory created${NC}"
		echo -e "-----"
		
	fi

	## make docs backup
	backup
	
	## remove old docs
	rm -rf docs
	echo -e "-----"
	echo -e "${BLUE}old ${GRAY}docs${BLUE} directory removed${NC}"
	echo -e "-----"
	
	mkdir docs
	touch docs/README.md
	
	echo -e "-----"
	echo -e "${BLUE}new ${GRAY}docs${BLUE} directory created${NC}"
	echo -e "-----"
	echo
	
	## if reset
	if [ "$mode" = "reset" ]
	then
	  
	  ## exit
		echo -e "${GREEN}=====${NC}"
		echo -e "${GREEN}RESET COMPLETED${NC}"
		echo -e "Now your docs directory contains only empty README.md file"
		echo -e "${GREEN}=====${NC}"
		echo
		exit
	
	## if custom
	elif [ "$mode" = "custom" ]
	then
	  
	  ## TODO
	  
	  ### read dirs and mode from line args
	  ### create current-dirs.txt to pass to _custom.sh
	  
	  ## run custom script
	  custom_deploy
  
  ## update or render all
  else
    
	  ## check dirs.txt exists
  	## abort function if not
  	if [ ! -f deploy/dirs.txt ]
  	then
  		
  		echo -e "${RED}=====${NC}"
  		echo -e "${RED}=====${NC}"
  		echo -e "${RED}DEPLOYMENT NOT COMPLETED${NC}"
  		echo -e "${RED}File ${GRAY}dirs.txt${RED} does not exists${NC}"
  		echo -e "Create a ${GRAY}dirs.txt${NC} file in ${GRAY}deploy${NC} folder with a list of directories (each on a new line) that have to be deployed"
  		echo -e "Format of each line: ${GRAY}<original_dir_name>:<deployed_dir_name>${NC}"
  		echo -e "${RED}=====${NC}"
  		echo -e "${RED}=====${NC}"
  		exit
  	
  	fi
		
		## make temporary current dirs file for updaters and renderers
		cp deploy/dirs.txt deploy/current-dirs.txt
		
	  ## if render
	  if [ "$mode" = "render" ]
	  then
	    
	    ## run render scripts with try-catch logic
	    {
	      render_books
	    } || {
	      echo -e "${RED}=====${NC}"
	      echo -e "${RED}=====${NC}"
	      echo -e "${RED}DEPLOYMENT NOT COMPLETED${NC}"
	      echo -e "${RED}Books render error${NC}"
	      echo -e "${RED}=====${NC}"
	      echo -e "${RED}=====${NC}"
	      echo
	      exit
	    }
	    
	    {
	      render_slides
	    } || {
	      echo -e "${RED}=====${NC}"
	      echo -e "${RED}=====${NC}"
	      echo -e "${RED}DEPLOYMENT NOT COMPLETED${NC}"
	      echo -e "${RED}Slides render error${NC}"
	      echo -e "${RED}=====${NC}"
	      echo -e "${RED}=====${NC}"
	      echo
	      exit
	    }
	    
	    {
	      render_analytics
	    } || {
  	    echo -e "${RED}=====${NC}"
  	    echo -e "${RED}=====${NC}"
  	    echo -e "${RED}DEPLOYMENT NOT COMPLETED${NC}"
  	    echo -e "${RED}Analytics render error${NC}"
  	    echo -e "${RED}=====${NC}"
  	    echo -e "${RED}=====${NC}"
  	    echo
  	    exit
	    }
	
	  fi
		
		## then update
	  ## run update scripts with try-catch logic
	  
	  {
	    update_books
	  } || {
	    echo -e "${RED}=====${NC}"
	    echo -e "${RED}=====${NC}"
	    echo -e "${RED}DEPLOYMENT NOT COMPLETED${NC}"
	    echo -e "${RED}Books update error${NC}"
	    echo -e "${RED}=====${NC}"
	    echo -e "${RED}=====${NC}"
	    echo
	    exit
	  }
	  
	  {
	    update_slides
	  } || {
	    echo -e "${RED}=====${NC}"
	    echo -e "${RED}=====${NC}"
	    echo -e "${RED}DEPLOYMENT NOT COMPLETED${NC}"
	    echo -e "${RED}Slides update error${NC}"
	    echo -e "${RED}=====${NC}"
	    echo -e "${RED}=====${NC}"
	    echo
	    exit
	  }
	  
	  {
	    update_analytics
	  } || {
	    echo -e "${RED}=====${NC}"
	    echo -e "${RED}=====${NC}"
	    echo -e "${RED}DEPLOYMENT NOT COMPLETED${NC}"
	    echo -e "${RED}Analytics update error${NC}"
	    echo -e "${RED}=====${NC}"
	    echo -e "${RED}=====${NC}"
	    echo
	    exit
	  }
	    
	  ## remove temporary current dirs file
	  rm deploy/current-dirs.txt
	  
	fi
	
	now=$(date +"%Y-%m-%d %H:%M")
	echo "Last deploy:" >> docs/README.md
	echo $now >> docs/README.md
	
	echo -e "${GREEN}==========${NC}"
	echo -e "${GREEN}==========${NC}"
	echo -e "${GREEN}DEPLOYMENT COMPLETED${NC}"
	echo -e "${GREEN}==========${NC}"
	echo -e "${GREEN}==========${NC}"
	echo -e "${GRAY}Commit and push changes to remote${NC}"
	echo
  
  # reset text color
	echo -e "${NC}"
	
}
