# Load Data
matches <- read.csv("Data/sample_submission.csv", header = TRUE, stringsAsFactors = FALSE)
spreads <- read.csv("Data/pointspreads.csv", header = TRUE, stringsAsFactors = FALSE)
spreads <- subset(spreads, season >= 2011)
