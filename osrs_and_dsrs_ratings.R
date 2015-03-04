# Load Data
matches <- read.csv("Data/sample_submission.csv", header = TRUE, stringsAsFactors = FALSE)
matches$year <- sapply(matches$id, FUN=function(x) {strsplit(x, split='[_]')[[1]][1]})
matches$lowId <- sapply(matches$id, FUN=function(x) {strsplit(x, split='[_]')[[1]][2]})
matches$highId <- sapply(matches$id, FUN=function(x) {strsplit(x, split='[_]')[[1]][3]})
teams <- read.csv("Data/teams.csv", header = TRUE, stringsAsFactors = FALSE)
teams$team_fullname <- teams$team_name

srs_2011 <- read.csv("Data/cbb_seasons_2011_ratings.csv", header = TRUE, stringsAsFactors = FALSE)
srs_2012 <- read.csv("Data/cbb_seasons_2012_ratings.csv", header = TRUE, stringsAsFactors = FALSE)
srs_2013 <- read.csv("Data/cbb_seasons_2013_ratings.csv", header = TRUE, stringsAsFactors = FALSE)
srs_2014 <- read.csv("Data/cbb_seasons_2014_ratings.csv", header = TRUE, stringsAsFactors = FALSE)
srs_2011$year <- 2011
srs_2012$year <- 2012
srs_2013$year <- 2013
srs_2014$year <- 2014

srs_ratings <- rbind(srs_2011, srs_2012, srs_2013, srs_2014)
merged <- merge(srs_ratings, teams, by.x=c("School"), by.y=c("team_fullname"))
merged2 <- merge(matches, merged, by.x=c("year","lowId"), by.y=c("year","team_id"))
matches <- cbind(matches, merged2["OSRS"])
colnames(matches)[6] <- "lowIdOSRS"
matches <- cbind(matches, merged2["DSRS"])
colnames(matches)[7] <- "lowIdDSRS"

merged3 <- merge(matches, merged, by.x=c("year","highId"), by.y=c("year","team_id"))
merged3 <- merged3[order(merged3$id), ]
matches <- cbind(matches, merged3["OSRS"])
colnames(matches)[8] <- "highIdOSRS"
matches <- cbind(matches, merged3["DSRS"])
colnames(matches)[9] <- "highIdDSRS"

matches$calculated <- 0.50 + (matches$lowIdOSRS - matches$highIdOSRS)*0.018 + (matches$lowIdDSRS - matches$highIdDSRS)*0.025
matches$calculated[matches$calculated > 1] <- 1
matches$calculated[matches$calculated < 0] <- 0


submit <- data.frame(id = matches$id, pred = matches$calculated)
write.csv(submit, file = "Output/osrs_and_dsrs_ratings_9.csv", row.names = FALSE, quote=FALSE)
