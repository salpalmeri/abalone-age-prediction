####################################### Load the data #######################################################
df <- read.table("abalone.data", sep = ",", header = FALSE)
names(df)<-c("Sex", "Length", "Diameter", "Height", "Whole", "Shucked", "Viscera", "Shell", "Rings")
df$Sex[df$Sex == "M"] <- 0
df$Sex[df$Sex == "F"] <- 1
df$Sex[df$Sex == "I"] <- 2
head(df)

####################################### Filter Data and Create Sample #######################################
sub_df <- subset(df, df$Sex != 2)
head(sub_df)
table(sub_df$Sex)

library(dplyr)
set.seed(123)
abalone <- sample_n(sub_df, 500)
head(abalone)
table(abalone$Sex)

####################################### Variables ###########################################################
Sex <- abalone$Sex
Length <- abalone$Length
Diameter <- abalone$Diameter
Height <- abalone$Height
Whole <- abalone$Whole
Shucked <- abalone$Shucked
Viscera <- abalone$Viscera
Shell <- abalone$Shell
Rings <- abalone$Rings
logRings <- log(Rings)

####################################### Summary Statistics ##################################################
library(lessR)
require(lattice)
SummaryStats(Length, data = abalone)
SummaryStats(Diameter, data = abalone)
SummaryStats(Height, data = abalone)
SummaryStats(Whole, data = abalone)
SummaryStats(Shucked, data = abalone)
SummaryStats(Viscera, data = abalone)
SummaryStats(Shell, data = abalone)
SummaryStats(Rings, data = abalone)

####################################### Box Plots ###########################################################
dev.new()
par(mfrow = c(2,4))
boxplot(Length,	main = "Length (mm)",col = "red")
boxplot(Diameter,	main = "Diameter (mm)",col = "green")
boxplot(Height,	main = "Height (mm)",col = "blue")
boxplot(Whole,	main = "Whole Weight (g)",col = "orange")
boxplot(Shucked,	main = "Shucked Weight (g)",col = "purple")
boxplot(Viscera,	main = "Viscera Weight (g)",col = "yellow")
boxplot(Shell,	main = "Shell Weight (g)",col = "pink")
boxplot(Rings,	main = "Rings",col = "brown")
dev.off()

#Boxplots by Sex
library("ggplot2")
library(gridExtra)
b1<-bwplot(Sex~Length, data = abalone)
b2<-bwplot(Sex~Diameter, data = abalone)
b3<-bwplot(Sex~Height, data = abalone)
b4<-bwplot(Sex~Whole, data = abalone)
b5<-bwplot(Sex~Shucked, data = abalone)
b6<-bwplot(Sex~Viscera, data = abalone)
b7<-bwplot(Sex~Shell, data = abalone)
b8<-bwplot(Sex~Rings, data = abalone)
dev.new()
grid.arrange(b1,b2,b3,b4,b5, b6, b7, b8,ncol=2)
dev.off()
####################################### Histograms ############################################################
h1 <- hist(Length, main = "Length Distribution", col = "lightblue", border = "blue")
h2 <- hist(Diameter, main = "Diameter Distribution", col = "lightblue", border = "blue")
h3 <- hist(Height, main = "Height Distribution", col = "lightblue", border = "blue")
h4 <- hist(Whole, main = "Whole Weight Distribution", col = "lightblue", border = "blue")
h5 <- hist(Shucked, main = "Shucked Weight Distribution", col = "lightblue", border = "blue")
h6 <- hist(Viscera, main = "Viscera Weight Distribution", col = "lightblue", border = "blue")
h7 <- hist(Shell, main = "Shell Weight Distribution", col = "lightblue", border = "blue")
h8 <- hist(Rings, main = "Rings Distribution", col = "lightblue", border = "blue")

####################################### Bar Plot ############################################################
dev.new()
barplot(table(Sex),
        main = "Abalone Count by Sex",
        ylab = "Count",
        xlab = "Sex",
        col = c("green", "blue"),
        legend.text = c("Male = 0", "Female = 1"),
        args.legend = list(x = "topright", inset = c(0, -0.1), xpd = TRUE))

####################################### Correlation and Scatter Plots #######################################
#excludes the sex variable
abalone2 <- abalone[, -which(colnames(abalone) == "Sex")]

#correlation heat map with bubbles showing strength of correlation
library(corrplot)
round(cor(abalone2),digits = 2)
mydata.cor = cor(abalone2)
dev.new()
corrplot(mydata.cor)
dev.off()

library(tidyverse)
library(knitr)
library(lavaan)
library(psych)
library(MBESS)

#correlation plot showing the scatter plots, histograms, and correlation value
dev.new()
abalone %>% 
  select(Length, Diameter, Height, Whole, Shucked, Viscera, Shell, Rings)%>% 
  pairs.panels()
dev.off()

#correlation plot showing scatterplots and correlation value with level of significance
library("PerformanceAnalytics")
dev.new()
chart.Correlation(abalone2, method = "pearson", histogram=FALSE, pch=16)
dev.off()

#correlation heat map with values
library(ggcorrplot)
corrN <- round(cor(abalone2), 2)
dev.new()
ggcorrplot(corrN, hc.order = TRUE, lab = TRUE, type = "lower",
           outline.col = "white",
           ggtheme = ggplot2::theme_gray,
           colors = c("#6D9EC1", "white", "#E46726"))
dev.off()

##correlation heat map with values
library(corrplot)
M<-cor(abalone2)
col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
dev.new()
corrplot(M, method="color", col=col(200),  
         type="upper", order="hclust", 
         addCoef.col = "black", # Add coefficient of correlation
         tl.col="black", tl.srt=45, #Text label color and rotation
         diag=FALSE 
)
dev.off()

#correlation heat map with values and ellipses showing correlation dirrection and strength
M1<-cor(abalone2)
dev.new()
corrplot.mixed(M1, lower = "number", upper = "ellipse",
               diag = "u",addgrid.col = "grey", bg = "white", 
               is.corr = TRUE, number.digits = 2)
dev.off()
####################################### Regression Models ###################################################
################ Model with Quantitative Variables ################
fit1 <- lm(Rings ~ Length+Diameter+Height+Whole+Shucked+Viscera+Shell)
summary(fit1)

dev.new()
layout(matrix(c(1,2,3,4),2,2)) 
plot(fit1)

################ Model with All Variables ################
fit2 <- lm(Rings ~ Length+Diameter+Height+Whole+Shucked+Viscera+Shell+Sex)
summary(fit2)

dev.new()
layout(matrix(c(1,2,3,4),2,2))
plot(fit2)

################ Model with Log of Rings ################
fit3 <- lm(logRings ~ Length+Diameter+Height+Whole+Shucked+Viscera+Shell+Sex)
summary(fit3)

dev.new()
layout(matrix(c(1,2,3,4),2,2))
plot(fit3)

hatvalues(fit3) #get the leverage values (hii)
cooks.distance(fit3) #get Cook's distance
dfbetas(fit3) #print all dfbetas
dfbetas(fit3)[4,1] #dfbeta for case 4, first coefficient (i.e., b_0)
dffits(fit3) [4] #dfits for case 4
influence(fit3) #various influence statistics, including hat values and dfbeta (not dfbetas) values
library(car) #load the package car
avPlots(fit3) #added variable plots
dev.new()
influencePlot(fit3)
inf <- influence.measures(fit3)

################ Transformed Model with Influential Observations Removed ################
# Logical vector: TRUE = influential on at least one measure
infl_rows <- apply(inf$is.inf, 1, any)

# Optional: see how many you're dropping
sum(infl_rows)
which(infl_rows)[1:10]  # peek at the first few indices
abalone_no_inf <- abalone[!infl_rows, ]
Rings2 <- abalone_no_inf$Rings
logRings2 <- log(Rings2)

fit4 <- lm(logRings2 ~ Length+Diameter+Height+Whole+Shucked+Viscera+Shell+Sex, data = abalone_no_inf)
summary(fit4)

dev.new()
layout(matrix(c(1,2,3,4),2,2))
plot(fit4)

################ QQ Plots ################
dev.new()
par(mfrow = c(1, 2))
# QQ for fit1
plot(fit2, which = 2, main = "QQ Plot without Transformation", col = "firebrick3", pch = 16, cex.main = 0.8)
# QQ for fit4
plot(fit4, which = 2, main = "QQ Plot with Log Transformation and Removed Influential Observations", 
     col = "darkseagreen", pch = 16, cex.main = 0.8)
