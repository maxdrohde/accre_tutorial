# Read in the arguments from the command line
args <- commandArgs(trailingOnly=TRUE)
# Take the first argument only
i <- as.integer(args[[1]])

# Define simulation settings
sim_settings <-
  expand.grid(mu1 = 0,
              mu2 = c(0,1,2,3),
              sd1 = c(1,2,3),
              sd2 = c(1,2,3),
              n1 = seq(10, 50, 10),
              n2 = seq(10, 50, 10))

# Select the simulation setting for this run
# by taking the ith row of `sim_settings`
params <- sim_settings[i,]

# Define main simulation function
run_t_test <- function(mu1, mu2, sd1, sd2, n1, n2, n_sim){
  
  arguments <- c(as.list(environment()))
  
  p <- numeric(n_sim)
  
  for (i in 1:n_sim) {
      y1 <- rnorm(n = n1, mean = mu1, sd = sd1)
      y2 <- rnorm(n = n2, mean = mu2, sd = sd2)
      p[i] <- t.test(y1, y2)$p.value
  }
  power <- mean(p < 0.05)
  
  results <- data.frame(power, arguments)
  results$datetime <- Sys.time()
  
  arguments_string <- paste(arguments, collapse = '_')
  datetime <- as.integer(Sys.time())
  filename <- glue::glue("{arguments_string}_{datetime}.csv")
  
  readr::write_csv(x = results, file = glue::glue("results/{filename}"))
}

# Run the simulation 1e4 times with the specified parameters
run_t_test(mu1 = params$mu1,
           mu2 = params$mu2,
           sd1 = params$sd1,
           sd2 = params$sd2,
           n1 = params$n1,
           n2 = params$n2,
           n_sim = 1e4)
