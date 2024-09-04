# Create a character vector of all the CSV filepaths from the ./results directory
paths <- fs::dir_ls(path = "./results",
                    glob = "*.csv")

# Read in the CSV file for each filepath
# then merge them all into one data frame
df <-
  purrr::map(paths,
      ~data.table::fread(.x),
      .progress = TRUE) |>
  data.table::rbindlist()

# Write the final results to CSV
readr::write_csv(df, file = "sim_results.csv")
