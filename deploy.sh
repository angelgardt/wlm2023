#!/bin/bash

set -e

if [ ! -f deploy_dirs.txt ]; then
	echo "====="
	echo "File deploy_dirs.txt does not exists"
	echo "Create a deploy_dirs.txt file with a list of direstories that have to be deployed"
	echo "Format of each line: <original_dir_name>:<deployed_dir_name>"
	echo "====="
else
	mode="${1:-update}"
	
	if [ ! -d docs ]; then
		mkdir docs
		touch docs/README.md
		echo "-----"
		echo "docs directory created"
		echo "-----"
	fi

	if [ "$mode" = "reset" ]; then
		rm -rf docs
		echo "docs directory removed"
		mkdir docs
		touch docs/README.md
		echo "-----"
		echo "docs directory created"
		echo "-----"
		
	else
		mkdir tmp
		mv docs/README.md tmp
		rm -rf docs
		mkdir docs
		mv tmp/README.md docs
		rm -rf tmp
	fi
	
	deploy_dirs=( $(cut -d ":" -f1 deploy_dirs.txt) )
	deploy_names=( $(cut -d ":" -f2 deploy_dirs.txt) )
	
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

