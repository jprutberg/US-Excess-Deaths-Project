# Import Packages
library(ggplot2)
library(forecast)
library(urca)

# Import Data and Split into Training and Testing Data Sets
data <- read.csv("US_Weekly_Deaths.csv", as.is=T)
training_data <- as.ts(data[1:535,]) # Before COVID deaths
training_data <- ts(training_data, start = 2009.7665982, frequency = 52.17857)
testing_data <- as.ts(data[536:dim(data)[1],]) # Week 536 has first COVID death
testing_data <- ts(testing_data, start = 2020.03832991, frequency = 52.17857)

# Figure 1
# Plot of US Weekly Deaths (2009-2022)
ggplot(data, aes(x = Date, y = All.Deaths)) + 
  geom_point(col = "red") + 
  geom_line() +
  labs(x = "Year",
       y = "U.S. Weekly Deaths",
       title = "Figure 1: U.S. Weekly Deaths (2009-2022)") +
  scale_x_continuous(breaks = seq(2009, 2022, by = 1)) +
  scale_y_continuous(breaks = seq(45000, 85000, by = 5000)) +
  theme_bw() +
  theme(text = element_text(size = 12), 
        plot.title = element_text(hjust = 0.5))

# Time Series for All Deaths
Deaths <- training_data[,"All.Deaths"]
Year <- training_data[,"Year"]
Week <- training_data[,"Week"]

# Summary Statistics
summary(Deaths) # Summary of Weekly Deaths Pre-COVID (Training Dataset)
summary(testing_data[,"All.Deaths"]) # Summary of Weekly Deaths During COVID (Testing Dataset)

# Figure A1
# Autocorrelation
acf(Deaths, lag = 160, main = 'Figure A1: Autocorrelation') # acf

# Figure A2
# Partial Autocorrelation
Pacf(Deaths, lag = 160, main = 'Figure A2: Partial Autocorrelation') 

# Test for Stationarity Using Original Data from Training Set
# Kwiatkowski-Phillips-Schmidt-Shin (KPSS) test for Stationarity
summary(ur.kpss(Deaths)) # reject null (NOT stationary)

# Take Seasonal Difference of Weekly Deaths for Training Data Set
SD_Deaths <- diff(Deaths, lag = 52, differences = 1)

# Test for Stationarity Using Seasonally-Differenced Data from Training Set
summary(ur.kpss(SD_Deaths)) # stationary

# Figure A3
# Seasonal Difference of U.S. Weekly Deaths
SD_deaths_data <- data.frame(Year = training_data[53:length(Deaths),"Date"], SD_Deaths)

ggplot(SD_deaths_data, aes(x = Year, y = SD_Deaths)) + 
  geom_point(col = "orange") + 
  geom_line() +
  labs(x = "Year",
       y = "Seasonal Difference of U.S. Weekly Deaths",
       title = "Figure A3: Seasonal Difference of U.S. Weekly Deaths (Training Data)") +
  scale_x_continuous(breaks = seq(2009, 2020, by = 1)) +
  scale_y_continuous(breaks = seq(-15000, 15000, by = 3000)) +
  theme_bw() +
  theme(text = element_text(size = 12), 
        plot.title = element_text(hjust = 0.5),
        title = element_text(size = 8))

# Model Selection
# Seasonal Component (0, 1, 0)
M000 <- arima(Deaths, order = c(0,0,0), seasonal = list(order = c(0,1,0), period = 52))
M001 <- arima(Deaths, order = c(1,0,0), seasonal = list(order = c(0,1,0), period = 52))
M002 <- arima(Deaths, order = c(0,0,1), seasonal = list(order = c(0,1,0), period = 52))
M003 <- arima(Deaths, order = c(1,0,1), seasonal = list(order = c(0,1,0), period = 52))
M004 <- arima(Deaths, order = c(2,0,0), seasonal = list(order = c(0,1,0), period = 52))
M005 <- arima(Deaths, order = c(0,0,2), seasonal = list(order = c(0,1,0), period = 52))
M006 <- arima(Deaths, order = c(2,0,1), seasonal = list(order = c(0,1,0), period = 52))
M007 <- arima(Deaths, order = c(1,0,2), seasonal = list(order = c(0,1,0), period = 52))
M008 <- arima(Deaths, order = c(2,0,2), seasonal = list(order = c(0,1,0), period = 52))
M009 <- arima(Deaths, order = c(3,0,0), seasonal = list(order = c(0,1,0), period = 52))
M010 <- arima(Deaths, order = c(0,0,3), seasonal = list(order = c(0,1,0), period = 52))
M011 <- arima(Deaths, order = c(3,0,1), seasonal = list(order = c(0,1,0), period = 52))
M012 <- arima(Deaths, order = c(1,0,3), seasonal = list(order = c(0,1,0), period = 52))
M013 <- arima(Deaths, order = c(3,0,2), seasonal = list(order = c(0,1,0), period = 52))
M014 <- arima(Deaths, order = c(2,0,3), seasonal = list(order = c(0,1,0), period = 52))
M015 <- arima(Deaths, order = c(3,0,3), seasonal = list(order = c(0,1,0), period = 52))

# Seasonal Component (1, 1, 0)
M100 <- arima(Deaths, order = c(0,0,0), seasonal = list(order = c(1,1,0), period = 52))
M101 <- arima(Deaths, order = c(1,0,0), seasonal = list(order = c(1,1,0), period = 52))
M102 <- arima(Deaths, order = c(0,0,1), seasonal = list(order = c(1,1,0), period = 52))
M103 <- arima(Deaths, order = c(1,0,1), seasonal = list(order = c(1,1,0), period = 52))
M104 <- arima(Deaths, order = c(2,0,0), seasonal = list(order = c(1,1,0), period = 52))
M105 <- arima(Deaths, order = c(0,0,2), seasonal = list(order = c(1,1,0), period = 52))
M106 <- arima(Deaths, order = c(2,0,1), seasonal = list(order = c(1,1,0), period = 52))
M107 <- arima(Deaths, order = c(1,0,2), seasonal = list(order = c(1,1,0), period = 52))
M108 <- arima(Deaths, order = c(2,0,2), seasonal = list(order = c(1,1,0), period = 52))
M109 <- arima(Deaths, order = c(3,0,0), seasonal = list(order = c(1,1,0), period = 52))
M110 <- arima(Deaths, order = c(0,0,3), seasonal = list(order = c(1,1,0), period = 52))
M111 <- arima(Deaths, order = c(3,0,1), seasonal = list(order = c(1,1,0), period = 52))
M112 <- arima(Deaths, order = c(1,0,3), seasonal = list(order = c(1,1,0), period = 52))
M113 <- arima(Deaths, order = c(3,0,2), seasonal = list(order = c(1,1,0), period = 52))
M114 <- arima(Deaths, order = c(2,0,3), seasonal = list(order = c(1,1,0), period = 52))
M115 <- arima(Deaths, order = c(3,0,3), seasonal = list(order = c(1,1,0), period = 52))

# Seasonal Component (0, 1, 1)
M200 <- arima(Deaths, order = c(0,0,0), seasonal = list(order = c(0,1,1), period = 52))
M201 <- arima(Deaths, order = c(1,0,0), seasonal = list(order = c(0,1,1), period = 52))
M202 <- arima(Deaths, order = c(0,0,1), seasonal = list(order = c(0,1,1), period = 52))
M203 <- arima(Deaths, order = c(1,0,1), seasonal = list(order = c(0,1,1), period = 52))
M204 <- arima(Deaths, order = c(2,0,0), seasonal = list(order = c(0,1,1), period = 52))
M205 <- arima(Deaths, order = c(0,0,2), seasonal = list(order = c(0,1,1), period = 52))
M206 <- arima(Deaths, order = c(2,0,1), seasonal = list(order = c(0,1,1), period = 52))
M207 <- arima(Deaths, order = c(1,0,2), seasonal = list(order = c(0,1,1), period = 52))
M208 <- arima(Deaths, order = c(2,0,2), seasonal = list(order = c(0,1,1), period = 52))
M209 <- arima(Deaths, order = c(3,0,0), seasonal = list(order = c(0,1,1), period = 52))
M210 <- arima(Deaths, order = c(0,0,3), seasonal = list(order = c(0,1,1), period = 52))
M211 <- arima(Deaths, order = c(3,0,1), seasonal = list(order = c(0,1,1), period = 52))
M212 <- arima(Deaths, order = c(1,0,3), seasonal = list(order = c(0,1,1), period = 52))
M213 <- arima(Deaths, order = c(3,0,2), seasonal = list(order = c(0,1,1), period = 52))
M214 <- arima(Deaths, order = c(2,0,3), seasonal = list(order = c(0,1,1), period = 52))
M215 <- arima(Deaths, order = c(3,0,3), seasonal = list(order = c(0,1,1), period = 52))

# Seasonal Component (1, 1, 1)
M300 <- arima(Deaths, order = c(0,0,0), seasonal = list(order = c(1,1,1), period = 52))
M301 <- arima(Deaths, order = c(1,0,0), seasonal = list(order = c(1,1,1), period = 52))
M302 <- arima(Deaths, order = c(0,0,1), seasonal = list(order = c(1,1,1), period = 52))
M303 <- arima(Deaths, order = c(1,0,1), seasonal = list(order = c(1,1,1), period = 52))
M304 <- arima(Deaths, order = c(2,0,0), seasonal = list(order = c(1,1,1), period = 52))
M305 <- arima(Deaths, order = c(0,0,2), seasonal = list(order = c(1,1,1), period = 52))
M306 <- arima(Deaths, order = c(2,0,1), seasonal = list(order = c(1,1,1), period = 52))
M307 <- arima(Deaths, order = c(1,0,2), seasonal = list(order = c(1,1,1), period = 52))
M308 <- arima(Deaths, order = c(2,0,2), seasonal = list(order = c(1,1,1), period = 52))
M309 <- arima(Deaths, order = c(3,0,0), seasonal = list(order = c(1,1,1), period = 52))
M310 <- arima(Deaths, order = c(0,0,3), seasonal = list(order = c(1,1,1), period = 52))
M311 <- arima(Deaths, order = c(3,0,1), seasonal = list(order = c(1,1,1), period = 52))
M312 <- arima(Deaths, order = c(1,0,3), seasonal = list(order = c(1,1,1), period = 52))
M313 <- arima(Deaths, order = c(3,0,2), seasonal = list(order = c(1,1,1), period = 52))
M314 <- arima(Deaths, order = c(2,0,3), seasonal = list(order = c(1,1,1), period = 52))
M315 <- arima(Deaths, order = c(3,0,3), seasonal = list(order = c(1,1,1), period = 52))

# Seasonal Component (2, 1, 0)
M400 <- arima(Deaths, order = c(0,0,0), seasonal = list(order = c(2,1,0), period = 52))
M401 <- arima(Deaths, order = c(1,0,0), seasonal = list(order = c(2,1,0), period = 52))
M402 <- arima(Deaths, order = c(0,0,1), seasonal = list(order = c(2,1,0), period = 52))
M403 <- arima(Deaths, order = c(1,0,1), seasonal = list(order = c(2,1,0), period = 52))
M404 <- arima(Deaths, order = c(2,0,0), seasonal = list(order = c(2,1,0), period = 52))
M405 <- arima(Deaths, order = c(0,0,2), seasonal = list(order = c(2,1,0), period = 52))
M406 <- arima(Deaths, order = c(2,0,1), seasonal = list(order = c(2,1,0), period = 52))
M407 <- arima(Deaths, order = c(1,0,2), seasonal = list(order = c(2,1,0), period = 52))
M408 <- arima(Deaths, order = c(2,0,2), seasonal = list(order = c(2,1,0), period = 52))
M409 <- arima(Deaths, order = c(3,0,0), seasonal = list(order = c(2,1,0), period = 52))
M410 <- arima(Deaths, order = c(0,0,3), seasonal = list(order = c(2,1,0), period = 52))
M411 <- arima(Deaths, order = c(3,0,1), seasonal = list(order = c(2,1,0), period = 52))
M412 <- arima(Deaths, order = c(1,0,3), seasonal = list(order = c(2,1,0), period = 52))
M413 <- arima(Deaths, order = c(3,0,2), seasonal = list(order = c(2,1,0), period = 52))
M414 <- arima(Deaths, order = c(2,0,3), seasonal = list(order = c(2,1,0), period = 52))
M415 <- arima(Deaths, order = c(3,0,3), seasonal = list(order = c(2,1,0), period = 52))

# Seasonal Component (0, 1, 2)
M500 <- arima(Deaths, order = c(0,0,0), seasonal = list(order = c(0,1,2), period = 52))
M501 <- arima(Deaths, order = c(1,0,0), seasonal = list(order = c(0,1,2), period = 52))
M502 <- arima(Deaths, order = c(0,0,1), seasonal = list(order = c(0,1,2), period = 52))
M503 <- arima(Deaths, order = c(1,0,1), seasonal = list(order = c(0,1,2), period = 52))
M504 <- arima(Deaths, order = c(2,0,0), seasonal = list(order = c(0,1,2), period = 52))
M505 <- arima(Deaths, order = c(0,0,2), seasonal = list(order = c(0,1,2), period = 52))
M506 <- arima(Deaths, order = c(2,0,1), seasonal = list(order = c(0,1,2), period = 52))
M507 <- arima(Deaths, order = c(1,0,2), seasonal = list(order = c(0,1,2), period = 52))
M508 <- arima(Deaths, order = c(2,0,2), seasonal = list(order = c(0,1,2), period = 52))
M509 <- arima(Deaths, order = c(3,0,0), seasonal = list(order = c(0,1,2), period = 52))
M510 <- arima(Deaths, order = c(0,0,3), seasonal = list(order = c(0,1,2), period = 52))
M511 <- arima(Deaths, order = c(3,0,1), seasonal = list(order = c(0,1,2), period = 52))
M512 <- arima(Deaths, order = c(1,0,3), seasonal = list(order = c(0,1,2), period = 52))
M513 <- arima(Deaths, order = c(3,0,2), seasonal = list(order = c(0,1,2), period = 52))
M514 <- arima(Deaths, order = c(2,0,3), seasonal = list(order = c(0,1,2), period = 52))
M515 <- arima(Deaths, order = c(3,0,3), seasonal = list(order = c(0,1,2), period = 52))

# Seasonal Component (2, 1, 1)
M600 <- arima(Deaths, order = c(0,0,0), seasonal = list(order = c(2,1,1), period = 52))
M601 <- arima(Deaths, order = c(1,0,0), seasonal = list(order = c(2,1,1), period = 52))
M602 <- arima(Deaths, order = c(0,0,1), seasonal = list(order = c(2,1,1), period = 52))
M603 <- arima(Deaths, order = c(1,0,1), seasonal = list(order = c(2,1,1), period = 52))
M604 <- arima(Deaths, order = c(2,0,0), seasonal = list(order = c(2,1,1), period = 52))
M605 <- arima(Deaths, order = c(0,0,2), seasonal = list(order = c(2,1,1), period = 52))
M606 <- arima(Deaths, order = c(2,0,1), seasonal = list(order = c(2,1,1), period = 52))
M607 <- arima(Deaths, order = c(1,0,2), seasonal = list(order = c(2,1,1), period = 52))
M608 <- arima(Deaths, order = c(2,0,2), seasonal = list(order = c(2,1,1), period = 52))
M609 <- arima(Deaths, order = c(3,0,0), seasonal = list(order = c(2,1,1), period = 52))
M610 <- arima(Deaths, order = c(0,0,3), seasonal = list(order = c(2,1,1), period = 52))
M611 <- arima(Deaths, order = c(3,0,1), seasonal = list(order = c(2,1,1), period = 52))
M612 <- arima(Deaths, order = c(1,0,3), seasonal = list(order = c(2,1,1), period = 52))
M613 <- arima(Deaths, order = c(3,0,2), seasonal = list(order = c(2,1,1), period = 52))
M614 <- arima(Deaths, order = c(2,0,3), seasonal = list(order = c(2,1,1), period = 52))
M615 <- arima(Deaths, order = c(3,0,3), seasonal = list(order = c(2,1,1), period = 52))

# Seasonal Component (1, 1, 2)
M700 <- arima(Deaths, order = c(0,0,0), seasonal = list(order = c(1,1,2), period = 52))
M701 <- arima(Deaths, order = c(1,0,0), seasonal = list(order = c(1,1,2), period = 52))
M702 <- arima(Deaths, order = c(0,0,1), seasonal = list(order = c(1,1,2), period = 52))
M703 <- arima(Deaths, order = c(1,0,1), seasonal = list(order = c(1,1,2), period = 52))
M704 <- arima(Deaths, order = c(2,0,0), seasonal = list(order = c(1,1,2), period = 52))
M705 <- arima(Deaths, order = c(0,0,2), seasonal = list(order = c(1,1,2), period = 52))
M706 <- arima(Deaths, order = c(2,0,1), seasonal = list(order = c(1,1,2), period = 52))
M707 <- arima(Deaths, order = c(1,0,2), seasonal = list(order = c(1,1,2), period = 52))
M708 <- arima(Deaths, order = c(2,0,2), seasonal = list(order = c(1,1,2), period = 52))
M709 <- arima(Deaths, order = c(3,0,0), seasonal = list(order = c(1,1,2), period = 52))
M710 <- arima(Deaths, order = c(0,0,3), seasonal = list(order = c(1,1,2), period = 52))
M711 <- arima(Deaths, order = c(3,0,1), seasonal = list(order = c(1,1,2), period = 52))
M712 <- arima(Deaths, order = c(1,0,3), seasonal = list(order = c(1,1,2), period = 52))
M713 <- arima(Deaths, order = c(3,0,2), seasonal = list(order = c(1,1,2), period = 52))
M714 <- arima(Deaths, order = c(2,0,3), seasonal = list(order = c(1,1,2), period = 52))
M715 <- arima(Deaths, order = c(3,0,3), seasonal = list(order = c(1,1,2), period = 52))

# Seasonal Component (2, 1, 2)
M800 <- arima(Deaths, order = c(0,0,0), seasonal = list(order = c(2,1,2), period = 52))
M801 <- arima(Deaths, order = c(1,0,0), seasonal = list(order = c(2,1,2), period = 52))
M802 <- arima(Deaths, order = c(0,0,1), seasonal = list(order = c(2,1,2), period = 52))
M803 <- arima(Deaths, order = c(1,0,1), seasonal = list(order = c(2,1,2), period = 52))
M804 <- arima(Deaths, order = c(2,0,0), seasonal = list(order = c(2,1,2), period = 52))
M805 <- arima(Deaths, order = c(0,0,2), seasonal = list(order = c(2,1,2), period = 52))
M806 <- arima(Deaths, order = c(2,0,1), seasonal = list(order = c(2,1,2), period = 52))
M807 <- arima(Deaths, order = c(1,0,2), seasonal = list(order = c(2,1,2), period = 52))
M808 <- arima(Deaths, order = c(2,0,2), seasonal = list(order = c(2,1,2), period = 52))
M809 <- arima(Deaths, order = c(3,0,0), seasonal = list(order = c(2,1,2), period = 52))
M810 <- arima(Deaths, order = c(0,0,3), seasonal = list(order = c(2,1,2), period = 52))
M811 <- arima(Deaths, order = c(3,0,1), seasonal = list(order = c(2,1,2), period = 52))
M812 <- arima(Deaths, order = c(1,0,3), seasonal = list(order = c(2,1,2), period = 52))
M813 <- arima(Deaths, order = c(3,0,2), seasonal = list(order = c(2,1,2), period = 52))
M814 <- arima(Deaths, order = c(2,0,3), seasonal = list(order = c(2,1,2), period = 52))
M815 <- arima(Deaths, order = c(3,0,3), seasonal = list(order = c(2,1,2), period = 52))

# Compare Model AIC's
# Compare Models (choose one with lowest AIC)
AIC(M000, M001, M002, M003, M004, M005, M006, M007,
    M008, M009, M010, M011, M012, M013, M014, M015,
    M100, M101, M102, M103, M104, M105, M106, M107,
    M108, M109, M110, M111, M112, M113, M114, M115,
    M200, M201, M202, M203, M204, M205, M206, M207,
    M208, M209, M210, M211, M212, M213, M214, M215,
    M300, M301, M302, M303, M304, M305, M306, M307,
    M308, M309, M310, M311, M312, M313, M314, M315,
    M400, M401, M402, M403, M404, M405, M406, M407,
    M408, M409, M410, M411, M412, M413, M414, M415,
    M500, M501, M502, M503, M504, M505, M506, M507,
    M508, M509, M510, M511, M512, M513, M514, M515,
    M600, M601, M602, M603, M604, M605, M606, M607,
    M608, M609, M610, M611, M612, M613, M614, M615,
    M700, M701, M702, M703, M704, M705, M706, M707,
    M708, M709, M710, M711, M712, M713, M714, M715,
    M800, M801, M802, M803, M804, M805, M806, M807,
    M808, M809, M810, M811, M812, M813, M814, M815)

# Final Model: M513: ARIMA(3, 0, 2)(0, 1, 2) [52]
M513 <- arima(Deaths, order = c(3,0,2), seasonal = list(order = c(0,1,2), period = 52))
summary(M513)

# Figure A4
tsdisplay(residuals(M513), lag.max = 100, main='Figure A4: Model Residuals')

# Model Forecasting
forecast <- forecast(M513, h = 113) # 113 weeks in the testing data set

# Figure A5
plot(forecast, xlab = "Year", 
     ylab = "U.S. Weekly Deaths", 
     main = "Figure A5: Observed and Predicted U.S. Weekly Deaths",
     ylim = c(35000, 90000), cex.main = 0.85)
lines(testing_data[,"All.Deaths"], col = "red")
legend("topleft", legend = c("Observed Deaths (Pre-COVID)", "Observed Deaths (During COVID-19 Pandemic)", "Predicted Deaths Point Estimate (During COVID-19 Pandemic)", "Predicted Deaths 80% Prediction Interval", "Predicted Deaths 95% Prediction Interval"), 
       lty = 1, lwd = c(2, 2, 2, 10, 10), col = c("black", "red", "blue", "lightsteelblue4", "gray85"), cex = 0.5)

# Compute Excess Deaths
point_estimate <- forecast$mean
upper_bound <- forecast$upper[,2]
excess_deaths <- as.numeric(testing_data[,"All.Deaths"]) - as.numeric(upper_bound)
excess_deaths_data <- data.frame(Year = testing_data[,"Date"], COVID_deaths = testing_data[,"COVID.19.Deaths"], excess_deaths)

# Total Excess Deaths
sum(excess_deaths) # total number of excess deaths

# Total COVID-19 Deaths
sum(testing_data[,"COVID.19.Deaths"]) # total number of COVID deaths

# Correlation Between Excess Deaths and COVID-19 Deaths
round(cor(excess_deaths, testing_data[,"COVID.19.Deaths"]), 3)
cor.test(excess_deaths, testing_data[,"COVID.19.Deaths"])

# Figure 2
ggplot(excess_deaths_data, aes(x = Year, y = excess_deaths)) + 
  geom_point(data = excess_deaths_data, aes(x = Year, y = excess_deaths), color = "black") +
  geom_point(data = excess_deaths_data, aes(x = Year, y = COVID_deaths), color = "black") +
  geom_line(data = excess_deaths_data, aes(x = Year, y = excess_deaths, color = 'Excess Deaths')) +
  geom_line(data = excess_deaths_data, aes(x = Year, y = COVID_deaths, color = 'COVID-19 Deaths')) +
  labs(x = "Year",
       y = "U.S. Weekly Deaths",
       title = "Figure 2: U.S. Weekly Excess Deaths and COVID-19 Deaths (2020-2022)") +
  scale_x_continuous(breaks = seq(2020, 2022.5, by = 0.5)) +
  scale_y_continuous(breaks = seq(0, 30000, by = 5000)) +
  theme_bw() +
  theme(text = element_text(size = 7),
        plot.title = element_text(hjust = 0.5)) +
  scale_color_manual(name = 'Legend',
                     breaks=c("Excess Deaths", "COVID-19 Deaths"),
                     values=c("Excess Deaths" = "blue", "COVID-19 Deaths" = "red"))
