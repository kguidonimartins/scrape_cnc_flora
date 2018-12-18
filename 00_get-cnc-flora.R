############################################################
#                                                          #
#                      load packages                       #
#                                                          #
############################################################
# ipak function: install and load multiple R packages.
# Check to see if packages are installed. 
# Install them if they are not, then load them into the R session.
# Forked from: https://gist.github.com/stevenworthington/3178163
ipak <- function(pkg) {
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)){
    install.packages(new.pkg, dependencies = TRUE)
  }
  suppressPackageStartupMessages(sapply(pkg, require, character.only = TRUE))
}

ipak(c("tidyverse", "rvest", "beepr"))


############################################################
#                                                          #
#                      create folder                       #
#                                                          #
############################################################

folder <- "cnc_flora"

if(!dir.exists(folder)){
  dir.create(folder)
}

############################################################
#                                                          #
#                     get family names                     #
#                                                          #
############################################################

url <- "http://cncflora.jbrj.gov.br/portal/pt-br/listavermelha"

sink("texto.md")
url %>% 
  read_html() %>% 
  html_node(css = ".col-lg-9 div") %>% 
  html_text(trim = TRUE) %>% 
  cat()
sink()

familiy <- 
  url %>% 
  read_html() %>% 
  html_nodes(".name") %>% 
  html_text("a")

############################################################
#                                                          #
#                    loop for families                     #
#                                                          #
############################################################
cc <- system.time(
  
for (i in seq_along(familiy)){
  
  # change url
  url_family <- paste0(url, "/", familiy[i])
  
  # get species names
  species <-
    url_family %>%
    read_html() %>%
    html_nodes(".spp") %>%
    html_text("a") %>%
    unlist() %>%
    {
      trimws(gsub(
        pattern = "\n",
        replacement = "",
        x = .
      ))
    } %>%
    word(string = .,
         start = 1,
         end = 2)
  
  # get categories
  category <-
    url_family %>%
    read_html() %>%
    html_nodes(".spp") %>%
    html_node(css = ".category") %>%
    html_text()
  
  # create a new df
  family_name <- rep(familiy[i], length(species))
  
  df_fsc <- cbind(family_name, species, category)
  
  # save info
  write.csv(
    x = df_fsc,
    file = paste0(folder, "/", familiy[i], ".csv"),
    row.names = FALSE
  )
  
  message(paste("Saving data for", familiy[i]))
  beep(sound = 2)
}
)


############################################################
#                                                          #
#               How much time does it take?                #
#                                                          #
############################################################

cat("Time for computation =", round(cc[3]/60), "minutes\n")
