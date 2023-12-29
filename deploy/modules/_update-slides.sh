#!/bin/bash

function update_slides() {
  
  ## exit with a non-zero status
  set -e
  
  printf "${GREEN}\n=====\nRUN SLIDES UPDATER\n=====\n\n"
  
  ## check if folder in docs exists
  ## create if not
  if [ ! -d docs/slides ]
  then 
    mkdir docs/slides
    printf "${GRAY}docs/slides ${BLUE}created\n${NC}"
  fi
  
  ## copy all html files
  find slides -maxdepth 1 -name "*html" -exec cp {} docs/slides \;
  printf "${GRAY}html ${BLUE}files copied\n${NC}"
  
  ## copy all slides_files
  find slides -maxdepth 1 -name "*_files" -exec cp -r {} docs/slides \;
  printf "${GRAY}_files ${BLUE}folders copied\n${NC}"
  
  ## copy pics folder
  find slides -maxdepth 1 -name "pics" -exec cp -r {} docs/slides \;
  printf "${GRAY}pics ${BLUE}folder copied\n${NC}"
  
  printf "${GREEN}\n=====\nSLIDES UPDATE COMPLETED\n=====\n\n${NC}"
  
}
