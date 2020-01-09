---
title: "Energy Consumption Analysis"
author: "Vanessa Trujillo"
date: "4/27/2019"
output: html_document
---

Introduction: This archive contains 566 measurements gathered in a house located in Sceaux (7km of Paris, France) between December 2006 and November 2010 (47 months). When I downloaded the data was in .xls format. I converted the file to .csv to ensure that R could read all the values correctly. 

NOTE: 0 values does not mean that no energy was consumed, it just signifies that less than 1 watts per hour or kilo-watts per hour were recorded

#Importing the data that we will analyze
```{r}
library(readr)
HousePower <- read_csv("HomeElect.csv",  na = "empty", 
    trim_ws = TRUE)
```

#Cleaning data & organizing data
``` {r}
#Setting imported data as a data-frame
str(HousePower)
summary(HousePower)
#Retrieving and gathering missing values from data-frame
missingValues <- which(is.na(HousePower), arr.ind=TRUE)
# Removing all the missing values from the dataframe
newdat <- na.omit(HousePower)
str(newdat)

#Turning each column of the data-frame into a vector with it's corresponding names
KitchenUsage <- newdat$Sub_metering_1 #(in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered). 
LaundryRoomUsage <- newdat$Sub_metering_2 #(in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light. 
TempAlterUsage <- newdat$Sub_metering_3 #(in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.
ActivePower<- newdat$Global_active_power #household global minute-averaged active power (in kilowatt) 
Voltage<- newdat$Voltage #minute-averaged voltage (in volt)
Intensity<-newdat$Global_intensity #household global minute-averaged current intensity (in ampere) 

#Providing a summary for each individual variables

namesrows <- c("KitchenUsage", "LaundryRoomUsage", "TempAlterUsage", "ActivePower", "Voltage", "Intensity")

variableDF <- cbind.data.frame(newdat$Sub_metering_1[0:566], newdat$Sub_metering_2[0:566],newdat$Sub_metering_3[0:566], newdat$Global_active_power[0:566], newdat$Voltage[0:566], newdat$Voltage[0:566])
names(variableDF) <- namesrows
str(variableDF)
summary(variableDF)
```


Here we can confirm that our data set did not have any missing variables since there are still 566 values. We can confirm that points which lie beyond the extremes of the whiskers for Kitchen Energy Usage is 38, 39 and 8 watt-hours, for Laundry room it is 36, 24, 26, 23, 37, 18, 31, 5, 16, 5, 3, and 4 watt-hours, for Temperature alteration Enery Usage it is 17, 16, 18, 19, and 3 watt-hour, for Active power it is 230.98 kilowatt, and for Intensity it is 25.4, 33.2, 30.6 ampere. All the lower and upper whiskers for the data were 0, except for Active Power which has a lower whisker of 0.210, and lower hinge of 0.374, median of 1.682, an upper hinge of 2.568, and the extreme upper whisker of 5.412 kilowatts, and from Intensity which has a lower whisker of 0.8, and lower hinge of 1.6, median of 7.2, an upper hinge of 10.8, and the extreme upper whisker of 23.2 kilowatts.

#Boxplot statistics
```{r}
#Stats: a vector of length 5, containing the extreme of the lower whisker, the lower ‘hinge’, the median, the upper ‘hinge’ and the extreme of the upper whisker.
#n: the number of non-NA observations in the sample.
#conf: the lower and upper extremes of the ‘notch’ 
#out:the values of any data points which lie beyond the extremes of the whiskers 
boxplot.stats(KitchenUsage)
boxplot.stats(LaundryRoomUsage)
boxplot.stats(TempAlterUsage)
boxplot.stats(Voltage)
boxplot.stats(ActivePower)
boxplot.stats(Intensity)

#Obtaining the Standard deviation for each varible
sd(KitchenUsage)
sd(LaundryRoomUsage)
sd(TempAlterUsage)
sd(ActivePower)
sd(Voltage)
sd(Intensity)
```

Histogram anlaysis:
For every variable except Voltage we see that 0 is a common value Volatage also looks to be symtrically distrubuted, with it's highest frequency is at value 240 volt. For Kitchen values 0 and appromixaletly 40, where 0 watt-hours is by far the most frequent. For Laundry room we see that it has the same pattern as Kitchen, with slightly more frequency at 40 watt-hours. For Temperture Alterations, we see that 0, and 15-20 are amongst the most frequent, with 0 watt-hours being the absolute most frequent. For household global minute-averaged active power, we see a negative trend per kw-hour, with 0 and 2 being amongst the most frequent values. For household global minute-averaged current intensity, we see that it follows a similar trend as active power, with 0 and 5 ampere being amongst the  most frequent values.


#Outliers visually; histograms 
```{r}
par(mfrow=c(2,3))
hist(KitchenUsage, main = "Histogram of Kitchen usage in watt-hour of active energy", col = "hotpink", xlab = "watt-hour",ylim=c(0,600))
hist(LaundryRoomUsage, main = "Histogram of Laundry Room usage in watt-hour of active energy", col = "violet", xlab = "watt-hour",ylim=c(0,600))
hist(TempAlterUsage, main = "Histogram of Temperture Alternations in usage in watt-hour of active energy", col = "purple", xlab = "watt-hour",ylim=c(0,600))
hist(Voltage, main = "Histogram of Voltage, minute-averaged voltage (in volt) ", col = "orange", xlab = "volt",ylim=c(0,600))
hist(ActivePower, main = "Histogram of household global minute-averaged active power (in kilowatt) ", col = "skyblue", xlab = "kwatt-hour",ylim=c(0,600))
hist(Intensity, main = "Histogram of household global minute-averaged current intensity (in ampere)", col = "yellow", xlab = "ampere", ylim=c(0,600))
```

It appears that there are mostly outlier within Temperature Alteration, and Laundry room. Active energy, and intensity also have some outliers but not the the extend of the varibles listed above, where Voltage has none. We can see the mean for Voltage, active energy is about 242.5, for intensity is nearly 2, and for Temperature approximatly 8 for this data set. 

#Outliers visually; boxplots
```{r}
par(mfrow=c(2,3))
boxplot(KitchenUsage,
        main = "Boxplot Showing Kitchen Energy Usage",
        xlab = "Calculated Column Data",
        col = "hotpink",
        horizontal = TRUE,
        notch = FALSE
)

boxplot(LaundryRoomUsage,
        main = "Boxplot Showing Laundry Enery Usage",
        xlab = "Calculated Column Data",
        col = "violet",
        horizontal = TRUE,
        notch = FALSE
)

boxplot(TempAlterUsage,
        main = "Boxplot Showing Temperture alteration Energy Usage",
        xlab = "Calculated Column Data",
        col = "purple",
        horizontal = TRUE,
        notch = FALSE
)

boxplot(Voltage,
        main = "Boxplot Showing minute-averaged voltage (in volt)",
        xlab = "Calculated Column Data",
        col = "orange",
        horizontal = TRUE,
        notch = FALSE
)

boxplot(ActivePower,
        main = "Boxplot Showing household global minute-averaged active power (in kilowatt) ",
        xlab = "Calculated Column Data",
        col = "skyblue",
        horizontal = TRUE,
        notch = FALSE
)

boxplot(Intensity,
        main = "Boxplot Showing household global minute-averaged current intensity (in ampere) ",
        xlab = "Calculated Column Data",
        col = "yellow",
        horizontal = TRUE,
        notch = FALSE
)
```

Below we study the outliers for each variable along with their corresponding ranges.

#Outlies programmatically; IQR
```{r}
#Provides number of outliers for each variable
IQR(KitchenUsage, na.rm = FALSE, type = 7)
IQR(LaundryRoomUsage, na.rm = FALSE, type = 7)
IQR(TempAlterUsage, na.rm = FALSE, type = 7)
IQR(Voltage, na.rm = FALSE, type = 7)
IQR(ActivePower, na.rm = FALSE, type = 7)
#Provides the ranges of values for each variable
range(KitchenUsage, finite = TRUE)
range(LaundryRoomUsage, finite = TRUE)
range(TempAlterUsage, finite = TRUE)
range(Voltage, finite = TRUE)
range(ActivePower, finite = TRUE)
```

Here we examine the Kitchen time series seems commonly at 0.0 Suggestion kitchen is not a common engery usage room. We see a variation in the time series plot for temperature, peaking positively at 2006-2008. Suggesting Temperture alterations are a common engery comsumption activities during this duration. We see a variation in the time series plot for Laundry room, peaking positively at 2008-2010. Suggesting laundry room energy usage is common comsumption activities during this duration. We see a variation in the time series plot for voltage, peaking positively at 2006-2007, 2008-2009, 2009-2010. Suggesting volatge are in ussage during this duration. We see a variation in the time series plot for active power, peaking positively at every year, seems to dip at the same season annually suggesting active power is in ussage during this duration. We see a variation in the time series plot for intensity, peaking positively at every year, seems to dip at the same season annually suggesting intensity is in ussage during this duration.

#Starting analysis; Analysis Time Series
```{r}
#Time series plots for variables: 
KitchenTS<- ts(KitchenUsage, start=c(2006,1 ), end=c(2010, 12), frequency=12)
plot(KitchenTS, main='Time Series Plot For Kitchen Usage', col='hotpink')
TempLaundTS<- ts(TempAlterUsage, start=c(2006,1 ), end=c(2010, 12), frequency=12)
plot(TempLaundTS, main='Time Series Plot For Temperture Alterations', col='violet')

LaundTS<- ts(LaundryRoomUsage, start=c(2006,1 ), end=c(2010, 12), frequency=12)
plot(LaundTS, main='Time Series Plot For Laundry Room', col='purple')

VolLg<-log(Voltage)
VolTS<- ts(VolLg, start=c(2006,1 ), end=c(2010, 12), frequency=12)
plot(VolTS, main='Time Series Plot For Voltage', col='orange')

AcLg <- log(ActivePower)
AcTS<- ts(AcLg, start=c(2006,1 ), end=c(2010, 12), frequency=12)
plot(AcTS, main='Time Series Plot For Active Power', col='skyblue')

InLg<-log(Intensity)
InTS<- ts(InLg, start=c(2006,1 ), end=c(2010, 12), frequency=12)
plot(InTS, main='Time Series Plot For Intensity', col='yellow')

```

In the following graphs we will see the time series plots for all 6 variables, the fitted time series plots and the seasonal time series plots.

Analyzing the time series plots we find: a constant trend of 0 watt-hour of active energy in the Kitchen, meaning not a lot of energy is used annually in the kitchen regradless of time, for Temperature Alteration energy use we see a trend in the model, as the year progresses temperature alteration usage increases, which make sense since winter is approaching; Less enegery is being used annually as well starting from the middle of 2008, for Laundry room we see a trend in the model, as the year progresses Laundry room usage seems to be used year around, which make sense since people need clean clothes; More people were washing in 2009-2010, Voltage follows the same seasonal trend annually, increasing more every year, Active power has the a decreasing trend, annually the acitve power pattern is the same, Intensity follows the exact same trend and annual pattern as Active Power, it makes sense since voltage is an element of power. 

In regards to the seaonal plots we ntice that Kitchen has a constant trend of 0 watt-hour of active energy, meaning not a lot of energy is used annually in the kitchen regradless of time, for Temperature Alterations as the year progresses temperature usage changes more often, which make sense since winter is approaching, usually between 16 and 18 watt-hour of active energy, in the Laundry room people tend to wash more from January-Feburary, and March-November, usually between 0 and 40 watt-hour of active energy, Voltage seems to follow a constant trend seasonally, usually between 5.445 and 5.475 minute-averaged voltage (in volt), Active power seasonally is between 0.8 and 2 minute-averaged active power (in kilowatt), Again Intensity follows Active power, with seasonality between 0.8 and 2 minute-averaged current intensity (in ampere).

#Plots & Decomposition of Time Series
```{R}

# Seasonal decomposition for Kitchen
fit1 <- stl(KitchenTS, s.window="period")
plot(fit1, main = 'Kitchen Plot', col='hotpink') 
# additional plots
library(forecast)
seasonplot(KitchenTS, col='hotpink') 

# Seasonal decomposition for Temperature Alterations 
fit2 <- stl(TempLaundTS, s.window="period")
plot(fit2, main = 'Temperature Alteration  Plot', col='purple') 
# additional plots
library(forecast)
seasonplot(TempLaundTS, col='purple') 

# Seasonal decomposition for Laundry Room
fit3 <- stl(LaundTS, s.window="period")
plot(fit3, main = 'Laundry Room  Plot', col='violet')
# additional plots
library(forecast)
seasonplot(LaundTS, col='violet') 

# Seasonal decomposition for Voltage
fit4 <- stl(VolTS, s.window="period")
plot(fit4, main = 'Volatage  Plot', col='orange') 
# additional plots
library(forecast)
seasonplot(VolTS, col='orange') 

# Seasonal decomposition for Active Power
fit5 <- stl(AcTS, s.window="period")
# additional plots
plot(fit5, main = 'Active Power  Plot', col='skyblue') 
library(forecast)
seasonplot(AcTS, col='skyblue') 

# Seasonal decomposition for Intensity
fit6 <- stl(InTS, s.window="period")
plot(fit6, main = 'Intensity  Plot', col='yellow') 
# additional plots
library(forecast)
seasonplot(InTS, col='yellow') 
```

Below we discover that there appears to be a positive correlation between Active Power and Kitchen usage, a negative correlation between Active Power and Temperture alterations usage, a positive correlation between Active Power and Laundry room usage, a positive correlation between Active Power and Voltage, a positive correlation between Active Power and Active Power, of course since it is itself, a positive correlation between Active Power and Intesity, again here we see it is almost a 100% correlation, which supports our time series trends and graphs.


#Correlation for Variables against Active Power
```{r}
cor(ActivePower, KitchenUsage) #There appears to be a positive correlation between Active Power and Kitchen usage
cor(ActivePower, TempAlterUsage) #There appears to be a negative correlation between Active Power and Temperture alterations usage
cor(ActivePower, LaundryRoomUsage) #There appears to be a positive correlation between Active Power and Laundry room usage
cor(ActivePower, Voltage) #There appears to be a positive correlation between Active Power and Voltage
cor(ActivePower, ActivePower) #There appears to be a positive correlation between Active Power and Active Power, of course since it is itself 
cor(ActivePower, Intensity) #There appears to be a positive correlation between Active Power and Intesity, again here we see it is almost a 100% correlation, which supports our time series trends and graphs

```

This model is against active power to see which variable effects it the most. We see that all variables are significant since their p-values are all very close to 0, so none of them need to be removed from our model.

#Multiple Linear Regression  
```{r}
# Stepwise Regression, Trying to see which variable consumes the most power
library(MASS)

fitt <- lm(ActivePower ~ KitchenUsage + TempAlterUsage + LaundryRoomUsage + Voltage + Intensity, data=newdat)
summary(fitt) # show results
step <- stepAIC(fitt, direction="both")
step$anova # display results

#Diagnostic plots provide checks for heteroscedasticity, normality, and influential observerations
#detailed scatterplots
# diagnostic plots 
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(fitt) #heteroscedasticity, normality, and influential observerations are met


```

Conclusion: From my analysis of the data from the 566 measurements gathered in a house located in Sceaux (7km of Paris, France) between December 2006 and November 2010 (47 months) we were able to determine that changing the tempertaure within a house (electric water-heater and an air-conditioner), is the variable that fluctuates the most seasonally. With energy consumption being the highest during the winter months. We were also able to determine that electric Intensity was almost absolutely correlated with Active power in the house. We also discovered the from the three rooms, the Laundry room was the one that consumed the most energy overall. For the linear regression, we found that all our variables were significant to our model, and that our model met the criteria for heteroscedasticity, and influential observerations checks, except for normality. This indicated that we might need to do a transform and rerun a regression to get more percise values for our regression. 