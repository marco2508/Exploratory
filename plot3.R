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

## Plot 3
with(df, {
  plot( Sub_metering_1~Datetime, 
        type="l",
        ylab="Global Active Power (kilowatts)", 
        xlab="")
        lines(Sub_metering_2~Datetime,col='Red')
        lines(Sub_metering_3~Datetime,col='Blue')
}
)
legend( "topright", 
        col=c("black", "red", "blue"), 
        lty=1, 
        lwd=2, 
        legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
        )
#default is 480 by 480 according docs; that does not show up OK
dev.copy( png, "plot3b.png", width=680, height = 480)
dev.off()       #close the copy
dev.copy( png, "plot3.png")
dev.off()       #close the plot
dev.copy( png, "plot3a.png", width=580, height = 480)
dev.off()       #close the plot

rm(df)            #en weer opruimen
