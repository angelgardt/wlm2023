#!/bin/bash

function render_slides() {
  
  ## exit wuth a non-zero status
  set -e
  
  printf "${GREEN}\n=====\nRUN SLIDES RENDERER\n=====\n\n${NC}"
  
  ## remove all html files
  find slides -maxdepth 1 -name "*html" -exec rm {} \;
  printf "${GRAY}html ${BLUE}files copied\n${NC}"
  
  ## remove all slides_files
  find slides -maxdepth 1 -name "*_files" -exec rm -r {} \;
  printf "${GRAY}_files ${BLUE}folders copied\n${NC}"
  
  ## remove all slides_cache
  find slides -maxdepth 1 -name "_cache" -exec rm -r {} \;
  printf "${GRAY}pics ${BLUE}folder copied\n${NC}"
  
  ## render all slides
  {
    find slides -maxdepth 1 -name "*qmd" -exec quarto render {} --to revealjs \;
  } || {
    return 1
  }
  
  printf "${GREEN}\n=====\nSLIDES RENDER COMPLETED\n=====\n\n${NC}"
  
}
