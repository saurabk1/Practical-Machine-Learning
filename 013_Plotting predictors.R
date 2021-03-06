library(ISLR)    # for the wage dataset
library(caret)   # to build models
library(ggplot2) # for plotting

data(spam)       # load the wage dataset
summary(spam)    # display a summary description of the variables

# Build the training/test sets
inTrain <- createDataPartition(y=Wage$wage, p=0.75, list=FALSE)

training <- Wage[inTrain, ]
testing <- Wage[-inTrain, ]
dim(training)
dim(testing)

# to look at the data: plot all features against each others 
featurePlot(x=training[,c("age", "education", "jobclass")], y = training$wage, plot="pairs")
# in the plot
#  - We can see a relationship between education and wage
#  - outcome y = 'wage', variables=[age, education, jobclass]
#  - all variables are drawn in the square columns

# look at specific relation, will find strange clusterisation
qplot(age, wage, data=training)
# color points by jobclass to find if it is the clustering cause
qplot(age, wage, colour=jobclass, data=training)

# plotting with another variable
qq <- qplot(age, wage, colour=education, data=training)
# add regression smoothers to plot a regression model for the differnet education class
qq + geom_smooth(method='lm', formula=y~x)

# cut2, making factors (Hmisc package)
install.packages("Hmisc")
library(Hmisc)
cutWage <- cut2(training$wage, g=3)
# all values of a varialble are assigned to one of the 3 groups
table(cutWage)
# We can use that to make different plots
# e.g. Boxplots with cut2: wage groups by age
p1 <- qplot(cutWage, age, data=training, fill=cutWage, geom=c("boxplot"))
p1

# add the points above the boxplot (as the latter may abstract too much)
# in case there is a lot of dots on a box that means the latter is representative of the dataset
install.packages("gridExtra")
library(gridExtra)
p2 <- qplot(cutWage, age, data=training, fill=cutWage, geom=c("boxplot", "jitter"))
grid.arrange(p1, p2, ncol=2)

# Tables for comparing variables
t1 <- table(cutWage, training$jobclass)
t1 # we can see there is a lot of industrial jobs for 1st group than information jobs, and the inverse for the 3rd group of wage

# to get the proportion on each group/column
prop.table(t1, 1) # 1 for columns, 2 for rows

# Density plots
qplot(wage, colour=education, data=training, geom="density")

# Further information
# Caret visualizations:
#   - http://caret.r-forge.r-project.org/visualizations.html
