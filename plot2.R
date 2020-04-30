dest = "./powerconsumption.zip"
if( !file.exists( dest))
{
  fileurl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file( fileurl, destfile = dest)
  unzip( dest )
}
#find out memory consumption
file = "household_power_consumption.txt"
df = read.csv( file=file, nrows = 100 )
object.size(df )
#100 regel = 20000 bytes; 
#internet suggests to use sqldf
if (!require("sqldf"))
{
  install.packages("sqldf")
}
library( sqldf )
df = read.csv.sql( file=file, 
                   "select * from file where Date = '1/2/2007' or Date = '2/2/2007' ", 
                   sep=";",
                   stringsAsFactors=F )
#set Dates to desired format
df$Date <- as.Date(df$Date, format="%d/%m/%Y")
datetime <- paste(as.Date(df$Date), df$Time)
df$Datetime <- as.POSIXct(datetime)

## Plot 2
with(df, {
  plot(Global_active_power~Datetime, type="l",
       ylab="Global Active Power (kilowatts)", xlab="")
})
dev.copy( png, "plot2.png")

dev.off()       #close the copy
dev.off()       #close the plot
rm(df)            #en weer opruimen

