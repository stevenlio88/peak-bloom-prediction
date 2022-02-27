



library(tidyverse)
library(lubridate)


i = 2004
Vancouver <- read.csv(paste0("../data/GoogleTrend_BC/",i,".csv"),skip=2,col.names = c("Week","blossom_week"))

for (i in 2005:2021) {
  Vancouver <- bind_rows(Vancouver,read.csv(paste0("../data/GoogleTrend_BC/",i,".csv"),skip=2,col.names = c("Week","blossom_week")))
}


Vancouver_blossom <- Vancouver[Vancouver$blossom_week==max(Vancouver$blossom_week),]





#Queen Elizabeth Park
Vancouver_out <- tibble(location="vancouver",
                        lat=49.2237,
                        long=-123.1636,
                        alt=24,
                        year=year(Vancouver_blossom$Week),
                        bloom_date=Vancouver_blossom$Week,
                        bloom_doy=yday(Vancouver_blossom$Week))


#manual update:

Vancouver_out[which(Vancouver_out$year==2005),]$bloom_date <- "2005-04-07"
Vancouver_out[which(Vancouver_out$year==2005),]$bloom_doy <- yday("2005-04-07")

write.csv(Vancouver_out, "../data/vancouver.csv",row.names = FALSE)



