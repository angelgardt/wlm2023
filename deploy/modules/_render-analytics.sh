#!/bin/bash

function render_analytics() {
  
  ## exit with a non-sero status
  set -e
  
  printf "${GREEN}\n=====\nRUN ANALYTICS RENDERER\n=====\n\n${NC}"
  
  ## remove old files, try-catch
  {
    rm -r analytics/index_files &&
      printf "${GRAY}_files${BLUE}folder removed\n${NC}"
  } || {
    printf "${GRAY}_files${BLUE}folder remove warning\n${NC}"
  }
  
  {
    rm -r analytics/index_cache &&
      printf "${GRAY}_cache${BLUE}folder removed\n${NC}"
  } || {
    printf "${GRAY}_cache${BLUE}folder warning\n${NC}"
  }
  
  {
    rm -r analytics/index.html && 
      printf "${GRAY}index.html${BLUE} removed\n${NC}"
  } || {
    printf "${GRAY}index.html${RED} remove warning\n${NC}"
  }
  
  ## render dashboard, try-catch
  {
    quarto render analytics/index.qmd --to html
  } || {
    return 1
  }
  
  printf "${GREEN}\n=====\nANALYTICS RENDER COMPLETED\n=====\n\n${NC}"
  
}
