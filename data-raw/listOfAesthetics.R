## code to prepare `listOfaesthetics` dataset goes here
library(data.table)

listOfAesthetics <- fread(file = file.path("data-raw", "listOfAesthetics.csv"))

# add all possible aesthtics
listOfAesthetics <-
  rbind(listOfAesthetics,
    data.table(
      aesthetic = setdiff(ggplot2:::.all_aesthetics, listOfAesthetics$aesthetic),
      source = "ggplot2"
    ),
    fill = TRUE
  )


usethis::use_data(listOfAesthetics, overwrite = TRUE, internal = TRUE)
