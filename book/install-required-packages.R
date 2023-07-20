pkgs <- readLines("required-pkgs")
install.packages(pkgs[!(pkgs %in% installed.packages())])
