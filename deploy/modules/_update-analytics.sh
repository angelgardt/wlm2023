#!/bin/bash

function update_analytics() {
  
  ## exit wuth a non-zero status
  set -e
  
  printf "${GREEN}\n=====\nRUN ANALYTICS UPDATER\n=====\n\n"
  
  ## check if folder in docs exists
  ## create if not
  if [ ! -d docs/analytics ]
  then
    mkdir docs/analytics
    printf "${GRAY}docs/analytics ${BLUE}created\n${NC}"
  fi
  
  ## copy html file
  cp analytics/index.html docs/analytics
  printf "${GRAY}index.html${BLUE}copied\n${NC}"
  
  ## copy index_files folder
  cp -r analytics/index_files docs/analytics
  printf "${GRAY}_files${BLUE}folder copied\n${NC}"
  
  ## copy pics folder
  cp -r analytics/pics docs/analytics
  printf "${GRAY}pics${BLUE}folder copied\n${NC}"
  
  printf "${GREEN}\n=====\nANALYTICS UPDATE COMPLETED\n=====\n\n${NC}"
  
}
