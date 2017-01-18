## Find the time zone name for a given location and find the time zone offset
## for a given location and date.

## Preliminaries
packages <- c("sp","rgeos","rgdal","raster","foreign","data.table","readr","iotools","maptools","ggplot2")
lapply(packages, library, character.only = TRUE)

## Load the time zone shapefile once, since it is rather slow
tz_dir <- paste0('~/Dropbox/research/data/timezone/')
tz <- shapefile(paste0(tz_dir,"tz_world.shp"))
tz_usa_dir <- paste0('~/Dropbox/research/data/maps/usa/time_zone/tz_us/')
tz_usa <- shapefile(paste0(tz_usa_dir,"tz_us.shp"))
 
## Find time zone name for a given location. This will be the most recent
## time zone name, but beware that these timezones can change over time.
##
## The points dataset should include variables "lon" and "lat"
## The usa logical determines whether only the USA time zones should be
## searched. The code runs in nearly constant time over
find_tz <- function(data,lon_var="lon",lat_var="lat",usa=FALSE){
    if(usa==FALSE){
        sp <- SpatialPoints(cbind(data[[lon_var]],data[[lat_var]]), proj4string=tz@proj4string)
        spdata <- SpatialPointsDataFrame(sp, data)
        tzid <- over(spdata, tz)
    } else {
        sp <- SpatialPoints(cbind(data[[lon_var]],data[[lat_var]]), proj4string=tz_usa@proj4string)
        spdata <- SpatialPointsDataFrame(sp, data)
        tzid <- over(spdata, tz_usa)
    }
    names(tzid) <- "tzid"
    data_out <- data.table(cbind(data,tzid))
}

## Find offset given location and date.
##
## The data needs to have the fields date, and tzid
##
## This code currently fails nicely but silently. If you don't
## include the date, for instance, it will just return NA but won't
## warn you.
tz_offset <- function(data,date_var="date",tz_var="tzid"){
    ## You can only provide a single timezone to R datetime functions
    ## (why??) so you need to loop over unique time zones
    unique_tz <- as.character(unique(data[[tz_var]]))
    for(i in 1:length(unique_tz)){
        data_rows <- which(data[[tz_var]]==unique_tz[i])
        data_sub <- data[data_rows,]
        datetime_local <- as.POSIXct(paste(as.character(data_sub[[date_var]]),"00:00:00"),format="%Y-%m-%d %H:%M:%S",tz=unique_tz[i])
        datetime_utc <- as.POSIXct(paste(as.character(data_sub[[date_var]]),"00:00:00"),format="%Y-%m-%d %H:%M:%S",tz='UTC')
        data[data_rows,'tzoffset'] <- -as.numeric(difftime(datetime_local,datetime_utc))
    }
    data
}

## Testing
test_tz <- function(){
    ## Correct time zones are
    test_tz <- c('America/Phoenix', 'America/Los_Angeles', 'America/Indiana/Vevay',
      'America/Chicago', 'America/Denver', 'America/Chicago', 'Europe/Madrid',
      'Europe/Bucharest')
    st_known <- data.table(lat=c(32.719996,32.722658,38.901289,43.7333,40.5268,38.132821,39.078102,45.326302),lon=c(-114.716169,-114.722905,-85.171180,-96.633,-105.1113,-87.697710,-2.560996,25.889361))
    
    ## Random lat lons to test code speed
    st_rand_small <- data.table(lat=c(runif(100,min=-80,max=80)),lon=c(runif(100,min=-159,max=159)))
    st_rand_big <- data.table(lat=c(runif(10000,min=-80,max=80)),lon=c(runif(10000,min=-159,max=159)))

    ## Known time zones returned
    ptm <- proc.time()
    st <- find_tz(st_known)
    if(mean(ifelse(st$tzid == test_tz,1,0))<1){
        stop("Incorrect time zone returned")
    }
    print(paste0('Known TZs took ',round((proc.time() - ptm)[3],1),' seconds with world.'))
    ## Known time zones returned with USA only 
    ptm <- proc.time()
    st <- find_tz(st_known,usa=TRUE)
        if(mean(ifelse(st$tzid == test_tz,1,0))<1){
        stop("Incorrect time zone returned")
    }
    print(paste0('Known TZs took ',round((proc.time() - ptm)[3],1),' seconds with USA.'))

    ## Speed test
    ptm <- proc.time()
    st <- find_tz(st_rand_small)
    print(paste0('Known TZs took ',round((proc.time() - ptm)[3],1),' seconds with world.'))
    ptm <- proc.time()
    st <- find_tz(st_rand_small,usa=TRUE)
    print(paste0('Known TZs took ',round((proc.time() - ptm)[3],1),' seconds with USA.'))
    ptm <- proc.time()
    st <- find_tz(st_rand_big)
    print(paste0('Known TZs took ',round((proc.time() - ptm)[3],1),' seconds with world.'))
    ptm <- proc.time()
    st <- find_tz(st_rand_big,usa=TRUE)
    print(paste0('Known TZs took ',round((proc.time() - ptm)[3],1),' seconds with USA.'))
}


