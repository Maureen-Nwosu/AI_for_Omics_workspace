gc()  # Clear memory to free up space before analysis
#### Install and Load Required Packages ####
# Check if BiocManager is installed; install if missing
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

# Install Bioconductor packages required for microarray analysis
BiocManager::install(c("limma", "AnnotationDbi", "hgu133plus2.db"))

# Install CRAN packages for data manipulation and visualization
install.packages(c("dplyr", "tibble", "ggplot2", "pheatmap"))

# Load Bioconductor packages
library(AnnotationDbi)   # Handles annotation and probe–gene mapping
library(hgu133plus2.db)  # Annotation database for Affymetrix HG-U133 Plus 2.0 array
library(limma)           # Performs linear modeling and differential expression
library(dplyr)           # Simplifies data manipulation tasks
library(tibble)          
library(ggplot2)         # Used for plotting and visualization
library(pheatmap)        # Generates heatmaps for gene expression data

# Load preprocessed expression and phenotype data
load("Maureen_Nwosu_Class_3_Assignment.RData")
