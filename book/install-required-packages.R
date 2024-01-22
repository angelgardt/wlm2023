pkgs <- readLines("../book/required-pkgs")
install.packages(pkgs[!(pkgs %in% installed.packages())])
