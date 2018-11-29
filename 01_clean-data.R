if (!require("tidyverse")) install.packages("tidyverse")

(
  temp_df <-
  list.files(
    path = "cnc_flora",
    pattern = "*.csv$",
    recursive = FALSE,
    full.names = TRUE
  )
)

all_df <-
  do.call(
    what = bind_rows,
    args = lapply(
      X = temp_df, 
      FUN = read_csv
      )
    )

write.csv(x = all_df, file = "all_data_from_cnc_flora.csv", row.names = FALSE)
