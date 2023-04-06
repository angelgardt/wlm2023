#!/bin/bash

function deployer {

	set -e
	
	RED='\033[0;31m'
	BLUE='\033[0;34m'
	GREEN='\033[0;32m'
	NC='\033[0m' # No Color

	if [ ! -f deploy_dirs.txt ]; then
		echo -e "${RED}=====${NC}"
		echo -e "${RED}Deploy not completed${NC}"
		echo -e "${RED}File deploy_dirs.txt does not exists${NC}"
		echo -e "Create a deploy_dirs.txt file with a list of direstories (each on a new line) that have to be deployed"
		echo -e "Format of each line: <original_dir_name>:<deployed_dir_name>"
		echo -e "${RED}=====${NC}"
	else
		mode="${1:-update}"
		deploy_dirs=( $(cut -d ":" -f1 deploy_dirs.txt) )
		deploy_names=( $(cut -d ":" -f2 deploy_dirs.txt) )
		
		if [ ! -d docs ]; then
			mkdir docs
			touch docs/README.md
			echo -e "-----"
			echo -e "${BLUE}docs directory created${NC}"
			echo -e "-----"
		fi

		if [ "$mode" = "reset" ]; then
			rm -rf docs
			echo -e "-----"
			echo -e "${BLUE}docs directory removed${NC}"
			echo -e "-----"
			mkdir docs
			touch docs/README.md
			echo "-----"
			echo "${BLUE}docs directory created${NC}"
			echo "-----"
		
		else
			mkdir tmp
			mv docs/README.md tmp
			rm -rf docs
			mkdir docs
			mv tmp/README.md docs
			rm -rf tmp
		fi
	
	echo "-----"
	echo "Number of directories in deploy_dirs.txt: ${#deploy_dirs[*]}"
	echo "-----"
	
	echo "-----"
	echo "Directories to be deployed:"
	for item in ${deploy_dirs[*]}
	do
		printf "    %s\n" $item
	done
	echo "-----"
	
	for index in ${!deploy_dirs[*]}
	do
		if [ ! -d docs/"${deploy_names[$index]}" ]; then
			mkdir docs/"${deploy_names[$index]}"
			echo "-----"
			echo docs/"${deploy_names[$index]}" created
			echo "-----"
		fi
		
		cp -R `echo "${deploy_dirs[$index]}"/_book/*` `echo docs/"${deploy_names[$index]}"`
		echo "-----"
		echo "${deploy_dirs[$index]}" copied
		echo "-----"
	done
	
	echo "====="
	echo "Deploy completed"
	echo "====="

	ls -Ral docs

fi
}

deployer $1

