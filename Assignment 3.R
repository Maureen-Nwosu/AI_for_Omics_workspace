### 0. Install and Load Required Packages ####

if (!requireNamespace("BiocManager", quietly = TRUE)) 
  install.packages("BiocManager")

# Install Bioconductor packages
BiocManager::install(c("GEOquery","affy","arrayQualityMetrics"))

# Install CRAN packages for data manipulation
install.packages("dplyr")

# Load Required Libraries
library(GEOquery)             # Download GEO datasets (series matrix, raw CEL files)
library(affy)                 # Pre-processing of Affymetrix microarray data (RMA normalization)
library(arrayQualityMetrics)  # QC reports for microarray data
library(dplyr)                # Data manipulation


gse_data <- getGEO("GSE53441", GSEMatrix = TRUE)
# Extract expression data matrix (genes/probes × samples)
expression_data <- exprs(gse_data$GSE53441_series_matrix.txt.gz)
# Extract feature (probe annotation) data
feature_data <-  fData(gse_data$GSE53441_series_matrix.txt.gz)
# Extract phenotype (sample metadata) data
phenotype_data <-  pData(gse_data$GSE53441_series_matrix.txt.gz)

# Check missing values in sample annotation
sum(is.na(phenotype_data$source_name_ch1))

# Untar CEL files if compressed as .tar
untar("C:/Users/mimee/OneDrive/Desktop/AI for Omics internship 2025/Assignment 3/GSE53441_RAW.tar",
      exdir = "C:/Users/mimee/OneDrive/Desktop/AI for Omics internship 2025/Assignment 3/CEL_Files")
# Read CEL files into R as an AffyBatch object
raw_data <- ReadAffy(celfile.path = "C:/Users/mimee/OneDrive/Desktop/AI for Omics internship 2025/Assignment 3/CEL_Files")
raw_data
class(raw_data)
#### Quality Control (QC) Before Pre-processing ####
arrayQualityMetrics(expressionset = raw_data, outdir = "C:/Users/mimee/OneDrive/Desktop/AI for Omics internship 2025/Assignment 3/Results/QC_raw",force = TRUE,do.logtransform = TRUE)
normalized_data <- rma(raw_data)
arrayQualityMetrics(expressionset = normalized_data,
                    outdir = "C:/Users/mimee/OneDrive/Desktop/AI for Omics internship 2025/Assignment 3/QC_normalized",
                    force = TRUE)

processed_data <- as.data.frame(exprs(normalized_data))
dim(processed_data) 
### Filter Low-Variance Transcripts (“soft” intensity based filtering) ####


# Calculate median intensity per probe across samples
row_median <- rowMedians(as.matrix(processed_data))

# Visualize distribution of probe median intensities
hist(row_median,
     breaks = 100,
     freq = FALSE,
     main = "Median Intensity Distribution")

# Set a threshold to remove low variance probes (dataset-specific, adjust accordingly)
threshold <- 3.5 
abline(v = threshold, col = "black", lwd = 2) 

# Select probes above threshold
indx <- row_median > threshold 
filtered_data <- processed_data[indx, ] 
cat("Number of transcripts remaining after filtering:", nrow(filtered_data), "\n")

# Rename filtered expression data with sample metadata
colnames(filtered_data) <- rownames(phenotype_data)


# Overwrite processed data with filtered dataset
processed_data <- filtered_data 
#### Phenotype Data Preparation ####
class(phenotype_data$source_name_ch1) 
groups <- factor(phenotype_data$characteristics_ch1,
                 levels = c("diagnosis: sickle cell anemia (SCA)", "diagnosis: normal"),
                 label = c("SCA", "normal"))
class(groups)
levels(groups)
