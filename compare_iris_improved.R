# ---------------------------------------------------------------------------
# Filename: compare_iris.R
# Description: Compares various versions of the "iris" dataset
# Author: Brian High, https://github.com/brianhigh
# License: Public Domain
# License text: https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt
# ---------------------------------------------------------------------------

# Of the two "iris" data sets available at UCI, which one comes standard with R?

# ----------------
# Define Functions
# ----------------

# Read "iris" dataset from a file, clean it up, and save as a CSV.
read_iris <- function(file_name) {
    df <- read.csv(paste(base_URL, file_name, sep = "/"), header = FALSE)
    names(df) <- names(iris)
    levels(df$Species) <- tolower(gsub('^Iris-', '', levels(df$Species)))
    write.csv(df, paste0(file_name, ".csv"), row.names = FALSE)
    return(df)
}

# Compare two data frames by row, and return differences, if any.
find_different_rows <- function(df1, df2, row_num) {
    res <- compareEqual(df1[row_num, ], UCI_iris_2[row_num, ])
    res.df <- as.data.frame(t(res$detailedResult))
    res.df$row_num <- row_num
    if (!res$result == TRUE) return(res.df)
}

# ------------
# Main Routine
# ------------

# This is the "iris" data set that comes standard with R.
#?iris
data(iris)

# Get the two alternative "iris" data sets and clean-up to match R's "iris".
base_URL <- "https://archive.ics.uci.edu/ml/machine-learning-databases/iris"

UCI_iris_1 <- read_iris(file_name = "iris.data")
UCI_iris_2 <- read_iris(file_name = "bezdekIris.data")

# Compare the "iris" data sets against the one that comes with R.

dim(UCI_iris_1)
dim(UCI_iris_2)

identical(UCI_iris_1, iris)
identical(UCI_iris_2, iris)

# Which rows are different?

if (!require(compare)) install.packages("compare")
library(compare)

# Note: This is more easily done in Bash with "diff", e.g.: $ diff file1 file2
if (!identical(UCI_iris_1, UCI_iris_2)) {
    is.equal <- do.call(rbind, lapply(1:nrow(UCI_iris_1), function(x) {
                        find_different_rows(UCI_iris_1, UCI_iris_2, x)}))
    print(is.equal)
    print(UCI_iris_1[is.equal$row_num, ])
    print(UCI_iris_2[is.equal$row_num, ])
}

# Homework: Do the same exercise in Python, comparing to "iris" in scikit-learn.
# See: https://github.com/scikit-learn/scikit-learn/issues/10550
