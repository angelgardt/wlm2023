#!/bin/bash

function deployer {

	set -e
	
	RED='\033[0;31m'
	BLUE='\033[0;34m'
	GREEN='\033[0;32m'
	GRAY='\033[0;37m'
	NC='\033[0m' # No Color

	# pass inline args to vars
	mode="${1:-update}"
	slides="${2:-no}"

	# check deploy_dirs.txt exists
	# abort function if not
	if [ ! -f deploy_dirs.txt ]; then
		
		echo -e "${RED}=====${NC}"
		echo -e "${RED}Deploy not completed${NC}"
		echo -e "${RED}File deploy_dirs.txt does not exists${NC}"
		echo -e "Create a deploy_dirs.txt file with a list of direstories (each on a new line) that have to be deployed"
		echo -e "Format of each line: ${GRAY}<original_dir_name>:<deployed_dir_name>${NC}"
		echo -e "${RED}=====${NC}"
		exit
	
	# check slides mode
	# abort function if not valid
	elif [ "$slides" != "slides" ] && [ "$slides" != "no" ]; then
		
		echo -e "${RED}=====${NC}"
		echo -e "${RED}Deploy not completed${NC}"
		echo -e "${RED}Unknown second inline argument${NC}"
		echo -e "Valid options are ${GRAY}no${NC} (default) or ${GRAY}slides${NC}"
		echo -e "${RED}=====${NC}"
		exit
	
	# check slides mode and slides folder exists
	# abort function if folder not exists
	elif [ "$slides" == "slides" ] && [ ! -d slides ]; then
			
		echo -e "${RED}=====${NC}"
		echo -e "${RED}Deploy not completed${NC}"
		echo -e "${RED}slides mode is set but slides directory does not exists${NC}"
		echo -e "${RED}=====${NC}"
		exit
	
	# check mode
	# abort function if not valid
	elif [ "$mode" != "update" ] && [ "$mode" != "reset" ] && [ "$mode" != "render" ]; then
		
		echo -e "${RED}=====${NC}"
		echo -e "${RED}Deploy not completed${NC}"
		echo -e "${RED}Unknown first inline argument${NC}"
		echo -e "Valid options are ${GRAY}update${NC} (default), ${GRAY}render${NC} or ${GRAY}reset${NC}"
		echo -e "${RED}=====${NC}"
		exit
	
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
			# if reset or render
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
				echo -e "-----"
			
				for index in ${!deploy_dirs[*]}
				do
					# remove old _book dirs
					rm -rf `echo "${deploy_dirs[$index]}"/_book/`
					echo -e "-----"
					echo -e ${GRAY}${deploy_dirs[$index]}/_book/ ${BLUE}removed${NC}
					echo -e "-----"
		     	 
					# render dirs
					{
						# try
						quarto render ${deploy_dirs[$index]} --to html
					} || {
						# catch
						echo -e "${RED}=====${NC}"
						echo -e "${RED}Deploy not completed${NC}"
						echo -e "${RED}File rendering error${NC}"
						echo -e "${RED}=====${NC}"
						exit
					}

					# print dir render success
					echo -e "-----"
					echo -e "${GRAY}${deploy_dirs[$index]} ${BLUE}rendered${NC}"
					echo -e "-----"
				done
				
				# check slides mode
				# if slides save qmd paths for rendering
				if ["$slides" == "slides" ]; then

					echo -e "${BLUE}Following slides found${NC}"
					
					i=0
					while read line
					do
						slides_qmds[ $i ]="$line"
						printf "${GRAY}    %s\n${NC}" $line
						(( i++ ))
					done < <(find slides -name *.qmd)
					
					for slide in ${slides_qmds[*]}
					do
						
						# render slides
						{
							# try
							quarto render $slide
						} || {
							#catch
							echo -e "${RED}=====${NC}"
							echo -e "${RED}Deploy not completed${NC}"
							echo -e "${RED}Slides rendering error${NC}"
							echo -e "${RED}=====${NC}"
							exit
						}
					done
				
				fi
				
				# print render success
				echo -e "${GREEN}=====${NC}"
				echo -e "${GREEN}Render completed${NC}"
				echo -e "${GREEN}=====${NC}"
				
			fi

			{
				#try
				cp index.html docs/index.html
			} || {
				#catch
				echo -e "-----"
				echo -e ${RED}Deploy not completed${NC}
				echo -e ${RED}redirecting index.html copying error${NC}
				echo -e "-----"
				exit
			}

			echo -e "-----"
			echo -e ${GRAY}redirecting index.html${BLUE}copied${NC}
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
				if [ ! -d docs/"${deploy_names[$index]}" ]; then
					mkdir docs/"${deploy_names[$index]}"
					echo -e "-----"
					echo -e ${GRAY}docs/"${deploy_names[$index]}" ${BLUE}created${NC}
					echo -e "-----"
				fi
    		
				{ 
					# try
					cp -R `echo "${deploy_dirs[$index]}"/_book/*` `echo docs/"${deploy_names[$index]}"` 
				} || {
					# catch
					echo -e "${RED}=====${NC}"
					echo -e "${RED}Deploy not completed${NC}"
					echo -e "${RED}File copying error${NC}"
					echo -e "${RED}=====${NC}"
					exit
				}
				
				echo -e "-----"
				echo -e ${GRAY}"${deploy_dirs[$index]}" ${BLUE}copied${NC}
				echo -e "-----"
			done
			
			# check slides mode
			# run copying files if slides
			if [ "$slides" == "slides" ]; then
				
				if [ ! -d docs/slides ]; then
					mkdir docs/slides
					echo -e "-----"
					echo -e ${GRAY} docs/slides ${BLUE}created${NC}
					echo -e "-----"
				fi
				
				
				echo -e "${BLUE}Following slides found${NC}"
				
				i=0
				while read line
				do
					slides_htmls[ $i ]="$line"
					printf "${GRAY}    %s\n${NC}" $line
					(( i++ ))
				done < <(find slides -name *.html)
					
				for slide in ${slides_htmls[*]}
				do
						
					# copy slides
					{
						# try
						cp $slide `echo docs/"$slide"`
					} || {
						#catch
						echo -e "${RED}=====${NC}"
						echo -e "${RED}Deploy not completed${NC}"
						echo -e "${RED}Slides copying error${NC}"
						echo -e "${RED}=====${NC}"
						exit
					}
				done
				
				echo -e "${BLUE}Following slides files found${NC}"
				
				i=0
				while read line
				do
					slides_files[ $i ]="$line"
					printf "${GRAY}    %s\n${NC}" $line
					(( i++ ))
				done < <(find slides -name *_files)
				
				for files in ${slides_files[*]}
				do
					
					# copy slides files
					{
						# try
						cp -R `echo "$files"/*` `echo docs/"$files"`
					} || {
						# catch
						echo -e "${RED}=====${NC}"
						echo -e "${RED}Deploy not completed${NC}"
						echo -e "${RED}Slides files copying error${NC}"
						echo -e "${RED}=====${NC}"
						exit
					}
				done
			fi
			
			# print list of docs files
			ls -Ral docs
			
			# print deploy success
			echo -e "${GREEN}=====${NC}"
			echo -e "${GREEN}Deploy completed${NC}"
			echo -e "${GREEN}=====${NC}"
		fi
	fi

	# reset text color
	echo -e "${NC}"
}

deployer $1 $2
