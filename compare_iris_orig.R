# Of the two "iris" data sets available, which one comes standard with R?

# This is the "iris" data set that comes standard with R.
data(iris)

# Get the two alternative "iris" data sets and clean-up to match R's "iris".
base_URL <-
    "https://archive.ics.uci.edu/ml/machine-learning-databases/iris"

read_data <- function(URL) {
    df <- read.csv(URL, header = FALSE)
    names(df) = names(iris)
    levels(df$Species) <- tolower(gsub('^Iris-', '', levels(df$Species)))
    df
}

UCI_iris_1 <- read_data(paste(base_URL, "iris.data", sep = "/"))
UCI_iris_2 <- read_data(paste(base_URL, "bezdekIris.data", sep = "/"))

UCI_iris_2 <-
    read.csv(paste(base_URL, "bezdekIris.data", sep = "/"), header = FALSE)
names(UCI_iris_2) = names(iris)
levels(UCI_iris_2$Species) <-
    tolower(gsub('^Iris-', '', levels(UCI_iris_2$Species)))

#Compare the "iris" data sets.

#install.packages("compare")
library(compare)

if (!identical(UCI_iris_1, UCI_iris_2)) {
    is.equal <- do.call(rbind, lapply(1:nrow(UCI_iris_1), function(x) {
        res <- compareEqual(UCI_iris_1[x, ], UCI_iris_2[x, ])
        res.df <- as.data.frame(t(res$detailedResult))
        res.df$x <- x
        if (!res$result) return(res.df)
    }))
    print(is.equal)
    print(UCI_iris_1[is.equal$x, ])
    print(UCI_iris_2[is.equal$x, ])
}

identical(UCI_iris_1, iris)
identical(UCI_iris_2, iris)

