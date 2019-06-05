# ---------------------------------------------------------------------------
# This is a sample script which needs to be cleaned up for readability, etc.
# ---------------------------------------------------------------------------

#Of the two "iris" data sets available at UCI, which one comes standard with R?

#This is the "iris" data set that comes standard with R.
#?iris
data(iris)

#Get the two alternative "iris" data sets and clean-up to match R's "iris".
base_URL<-"https://archive.ics.uci.edu/ml/machine-learning-databases/iris"
UCI_iris_1<-read.csv(paste(base_URL,"iris.data",sep="/"),header=FALSE)
names(UCI_iris_1)=names(iris)
levels(UCI_iris_1$Species) <- tolower(gsub('^Iris-', '', levels(UCI_iris_1$Species)))
write.csv(UCI_iris_1, "H:\\My Documents\\R Examples\\iris_compare\\iris_data.csv",row.names=FALSE)
UCI_iris_2<-read.csv(paste(base_URL,"bezdekIris.data",sep="/"),header=FALSE)
names(UCI_iris_2)=names(iris)
levels(UCI_iris_2$Species) <- tolower(gsub('^Iris-', '', levels(UCI_iris_2$Species)))
write.csv(UCI_iris_2, "H:\\My Documents\\R Examples\\iris_compare\\iris_data.csv",row.names=FALSE)

#Compare the "iris" data sets against the one that comes with R.
dim(UCI_iris_1)
dim(UCI_iris_2)
identical(UCI_iris_1, iris)
identical(UCI_iris_2, iris)

#Which rows are different?

#install.packages("compare")
library(compare)

if (!identical(UCI_iris_1, UCI_iris_2)) {
    is.equal <- do.call(rbind, lapply(1:nrow(UCI_iris_1), function(x) {
                    res <- compareEqual(UCI_iris_1[x, ], UCI_iris_2[x, ])
                    res.df <- as.data.frame(t(res$detailedResult))
                    res.df$x <- x
                    if (!res$result == TRUE) return(res.df)
                }))
    print(is.equal)
    print(UCI_iris_1[is.equal$x, ])
    print(UCI_iris_2[is.equal$x, ])
}


# Homework: Do the same exercise in Python, comparing to "iris" in scikit-learn.
# See: https://github.com/scikit-learn/scikit-learn/issues/10550
