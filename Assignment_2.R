# install and load "downloader" package

install.packages("downloader")
library(downloader)

# store url and set name

url_DEGS_Data_1 <- "https://raw.githubusercontent.com/AI-Biotechnology-Bioinformatics/AI_and_Omics_Research_Internship_2025/refs/heads/main/DEGs_Data_1.csv"

url_DEGS_Data_2 <- "https://raw.githubusercontent.com/AI-Biotechnology-Bioinformatics/AI_and_Omics_Research_Internship_2025/refs/heads/main/DEGs_Data_2.csv"
file.names <- c("DEGs_Data_1.csv", "DEGs_Data_2.csv") 
files_url  <- c(url_DEGS_Data_1, url_DEGS_Data_2)

#Download 
for(i in seq_along(files_url)){
  download(files_url[i], file.names[i])
  }


#import
data1 <- read.csv("DEGs_Data_1.csv")
data2 <- read.csv("DEGs_Data_2.csv")

#input and output directories

input_dir <-  getwd()   
output_dir <- "Results"

# create output folder if not already exist

if(!dir.exists(output_dir)){
  dir.create(output_dir)
}

# List which files to process
files_to_process <- c("DEGs_Data_1.csv", "DEGs_Data_2.csv") 

# Prepare empty list to store results in R 
result_list <- list()

# Function defintion
classify_gene <- function(logFC,padj ) {
  # Perform comaprison
  if (logFC > 1 & padj < 0.05) {
    return("Upregulated")
  } else if (logFC < -1 & padj < 0.05) {
    return("Downregulated")
  } else {
    return("Not_Significant")
  }
}
  
  

for (file_names in files_to_process) {
  cat("\nProcessing:", file_names, "\n")
  
  input_file_path <- file.path(input_dir, file_names)
  
  # Import dataset
  data <- read.csv(input_file_path, header = TRUE)
  cat("File imported. Checking for missing values...\n")

 #  Replace missing padj values with 1
  data$padj[is.na(data$padj)] <- 1

 
 # calling function
  data$status <- mapply(classify_gene, data$logFC, data$padj)

  # Store in result_list
  
  result_list[[file_names]] <- data
 # save results in Results folder
 output_file_path <- file.path(output_dir, paste0("Results_", file_names))
 write.csv(data, output_file_path, row.names = FALSE)
 cat("Results saved to:", output_file_path, "\n")
 
 # Print summary counts
 cat("\nSummary for", file_names, ":\n")
 print(table(data$status))
 
}
  results_1 <- result_list[["DEGs_Data_1.csv"]] 
  results_2 <- result_list[["DEGs_Data_2.csv"]] 
  
  save.image(file = "Maureen_Nwosu_Class_2_Assignment.RData")
  