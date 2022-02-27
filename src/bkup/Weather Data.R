rm(list = ls())
cat("\014") 

library(rnoaa)
library(ggplot2)
library(tidyverse)
library(forecast)
library(tsibble)

get_station <- function (stationid) {
  ghcnd_search(stationid = stationid, var = "all", 
               date_min = "1950-01-01", date_max = Sys.Date())
}

station_id <- tibble(location=c("Washington DC","Liestal","Kyoto","Vancouver"),
                     id = c("USC00186350","GME00127786","JA000047759","CA001108395"))

weather_data <- tibble(id=as.character(),
                       location=as.character(),
                       var=as.character(),
                       value=as.numeric(),
                       date=as.Date(NA),
                       mflag=as.character(),
                       qflag=as.character(),
                       sflag=as.character()
                       )
get_data <- function(station_ids,verbose=FALSE)
for (s in 1:nrow(station_id)){
  if (verbose) {print(paste0("Fetching data for location: ",station_id[s,]$location))}
  a <- get_station(station_id[s,]$id)
  
  for (i in 1:length(a)){
    if (verbose) {
      print(paste0("Variable: ",colnames(a[[i]])[2]))
      print(paste0("Rows: ",nrow(a[[i]])))
    }
    
    weather_data <- weather_data %>%
      add_row(id = a[[i]]$id,
              location = rep(station_id[s,]$location,nrow(a[[i]])),
              var = colnames(a[[i]])[2],
              value = a[[i]][,colnames(a[[i]])[2]] %>% pull(),
              date = a[[i]]$date,
              mflag = a[[i]]$mflag,
              qflag = a[[i]]$qflag,
              sflag = a[[i]]$sflag)
    if (verbose) {
      print("")
    }
  }
}

if (exists("a")) {rm(a)}

#complete time series:

var_impute <- unique(weather_data %>% select(id, var))

weather_data_complete <- weather_data[0,]

for (i in 1:nrow(var_impute)){
  print(paste0("Complete sereis for ",var_impute[i,1] %>% pull(),", variable: ",var_impute[i,2]))
  ts_raw <- weather_data %>% 
    filter(id==var_impute[i,1] %>% pull(),
           var==var_impute[i,2] %>% pull())
  
  ts_complete_row <-  ts_raw %>%
    complete(date = seq.Date(min(date), max(date), by="day")) %>%
    mutate(id=ifelse(is.na(id),unique(na.omit(id)),id),
           location=ifelse(is.na(location),unique(na.omit(location)),location),
           var=ifelse(is.na(var),unique(na.omit(var)),var),
           value=ifelse(var %in% c("tmax","tmin","prcp","tobs","wesd","tavg","wsfg"),value/10,value),
           mflag = ifelse(is.na(mflag)," ",mflag),
           qflag = ifelse(is.na(qflag)," ",qflag),
           sflag = ifelse(is.na(sflag)," ",sflag)
    )
  
  weather_data_complete <- weather_data_complete %>%
    add_row(ts_complete_row)
  
  new_row <- weather_data_complete %>% 
    filter(id==var_impute[i,1] %>% pull(),
           var==var_impute[i,2] %>% pull()) %>%
    nrow()
  
  print(paste0("Original: ",nrow(ts_raw)," rows. New: ",new_row))
}


weather_data_complete_summary <- weather_data_complete %>%
  group_by(id, location, var) %>%
  summarise(dt.min = min(date),
            dt.max = max(date),
            missing_dt = n() - (max(date)-min(date)+1),
            cnt = n(),
            val.na = sum(is.na(value)),
            val.min = min(na.omit(value)),
            val.max = max(na.omit(value)),
            val.avg = mean(na.omit(value)),
            val.sd = sd(na.omit(value))
            )

if (weather_data_complete_summary %>% filter(missing_dt > 0) %>% nrow() > 0){
  print("Still have missing data")
}

weather_data_complete <- weather_data_complete %>%
  mutate(year = as.integer(format(date, "%Y")),
         month = as.integer(strftime(date, '%m')) %% 12,
         season = cut(month, breaks = c(0, 2, 5, 8, 11),
                      include.lowest = TRUE,
                      labels = c("Winter", "Spring", "Summer", "Fall")),
         year = if_else(month == 0, year + 1L, year))

#plot
weather_data_complete %>%
  mutate(value = ifelse(var=="tmax",value/10,value)) %>%
  filter(year>=1990 & var %in% c("tmax")) %>%
  select(location, var,value, date) %>%
  ggplot() + 
  aes(x = date, y = value, color=location) + 
  geom_line() +
  labs(x = "Year", y = "value") +
  theme(legend.position="top") +
  facet_wrap(.~str_to_title(location), ncol=1, scales = "free")



tmax <- weather_data %>%
  mutate(value = ifelse(var=="tmax",value/10,value)) %>%
  filter(var %in% c("tmax"), location == "Kyoto") %>%
  select(date,value) %>%
  as_tsibble(index=date)


























