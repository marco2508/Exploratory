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
object.size(df )  #300K
dim( df )         #2880 rows

#eens kijken wat we er mee moeten
# https://github.com/marco2508/ExData_Plotting1   Fork gedaan

hist( df$Global_active_power, 
      col = "red", 
      main=  "Global Active Power", 
      xlab = "Global Active Power (kilowatts)"
      )

dev.copy( png, "plot1.png", width=480, height = 480)

dev.off()       #close the copy
dev.off()       #close the plot
rm(df)            #en weer opruimen
  