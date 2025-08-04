getwd()

# create subfolders

dir.create("data")
dir.create("scripts")
dir.create("results")

# loading patient data

data <- read.csv(file.choose())

# inspecting data structure

View(data)
str(data)

# checking all vectors(columns) of data

class(data$patient_id)
class(data$age)
class(data$gender)
# (change gender to categorical/factor data type)
class(data$diagnosis)
# (change diagnosis to categorical/factor data type)
class(data$bmi)
class(data$smoker)
# (change smoker to categorical/factor data type as a new variable)


# updating gender and diagnosis data type

data$gender <- as.factor(data$gender)
str(data)

data$diagnosis <- as.factor(data$diagnosis)
str(data)

# updating smoker column with a new column with numeric values
# convert to a factor first then numeric
data$smoker <- as.factor(data$smoker)
str(data)

#creating new vaiarble
data$smoker_num <- ifelse(data$smoker == "Yes", 1, 0)
class(data$smoker_num)

#saving clean data
write.csv(data, file = "data/patient_info_clean.csv")
