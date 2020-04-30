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

## Plot 4
par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
with(df, {
  plot(Global_active_power~Datetime, 
       type="l", 
       ylab="Global Active Power", 
       xlab="")
  plot(Voltage~Datetime, 
       type="l", 
       ylab="Voltage (volt)", 
       xlab="datetime")
  plot(Sub_metering_1~Datetime, 
       type="l", 
       ylab="Energy sub metering", 
       xlab="")
  lines(Sub_metering_2~Datetime,col='Red')
  lines(Sub_metering_3~Datetime,col='Blue')
  legend("topright", 
         col=c("black", "red", "blue"), 
         lty=1, 
         lwd=2, 
         bty="n",
         legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  plot(Global_reactive_power~Datetime, 
       type="l", 
       ylab="Global Reactive Power",
       xlab="datetime")
})
dev.copy( png, "plot4.png", width=480, height = 480)
dev.off()
dev.off()
rm(df)            #en weer opruimen
