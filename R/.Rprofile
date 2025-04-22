# The .First function is called after everything else in .Rprofile is executed
.First <- function() {
  # Print a welcome message
  message("Welcome back ", Sys.getenv("USER"),"!\n","Working directory is: ", getwd())
}

# Penalty applied to inhibit the use of scientific notation
options(scipen=999)

# wider continue
options(continue="... ")

# from the arch wiki
local({
    # Detect the number of cores available for use in parallelisation
    n <- max(parallel::detectCores() - 2L, 1L)
    # Compile the different sources of a single package in parallel
    Sys.setenv(MAKEFLAGS = paste0("-j",n))
    # Install different packages passed to a single install.packages() call in parallel
    options(Ncpus = n)
    # Parallel apply-type functions via 'parallel' package
    options(mc.cores =  n)
})

local({r <- getOption("repos")
      r["CRAN"] <- "https://repo.miserver.it.umich.edu/cran/"
      options(repos=r)})

options(
    radian.escape_key_map = list(
        list(key = "-", value = " <- ")),
    radian.escape_key_map = list(
        list(key = "m", value = " |> ")
    )
)

options(radian.editing_mode = "vi")

# enable various emacs bindings in vi insert mode
options(radian.emacs_bindings_in_vi_insert_mode = FALSE)

# show vi mode state when radian.editing_mode is `vi`
options(radian.show_vi_mode_prompt = TRUE)
options(radian.vi_mode_prompt = "\033[0;34m[{}]\033[0m ")

# highlight matching bracket
options(radian.highlight_matching_bracket = TRUE)
