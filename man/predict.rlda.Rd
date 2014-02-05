\name{predict.rlda}
\alias{predict.rlda}
\title{Restricted Linear Discriminant Analysis. Multivariate Observations Classification}
\description{Classify multivariate observations with linear classification rules built with additional information in conjunction with \code{rlda}.
}
\usage{
\method{predict}{rlda}(object, newdata, prior = object$prior, 
        gamma = object$gamma, grouping = NULL, \dots)
}
\arguments{
  \item{object}{ An object of class \code{'rlda'}. }
  \item{newdata}{ A data frame of cases to be classified, containing the variables used on creating \code{object}. A vector will be interpreted as a row vector. }
  \item{prior}{ The prior probabilities of class membership. If unspecified, \code{object$prior} probabilities are used. If present, the probabilities must be specified in the order of the factor levels. }
  \item{gamma}{ A vector of values specifying which rules to take among the ones in \code{object}. If unspecified, all rules built with \code{object$gamma} will be used. If present, \code{gamma} must be contained in \code{object$gamma}. }
  \item{grouping}{ A numeric vector or factor with numeric levels specifying the class for each observation. If present, true error rate will be estimated from \code{newdata}. }
  \item{\dots}{ Arguments based from or to other methods. }
}
\details{
This function is a method for the generic function \code{predict()} for class \code{'rlda'}.
}
\value{
A list with components
  \item{call}{ The (matched) function call. }
  \item{class}{ Matrix with the classification for each rule (in columns). }
  \item{prior}{ The prior probabilities of the classes used. }
  \item{posterior}{ Array with the posterior probabilities of the classes for each rule. }
  \item{error.rate}{ True error rate estimation (when \code{grouping} specified) for each rule, based on \code{newdata}. }
}
\references{
Conde, D., Fernandez, M. A., Rueda, C., and Salvador, B. (2012). Classification of samples into two or more ordered populations with application to a cancer trial. \emph{Statistics in Medicine}, \bold{31}, 3773-3786.
}
\author{
David Conde
}
\note{
If there are missing values in \code{newdata}, corresponding observations will not be classified.

If there are missing values in \code{grouping}, corresponding observations will not be considered on calculating the true error rate.
}
\seealso{
\code{\link{rlda}}, \code{\link{err.est.rlda}}, \code{\link{rqda}}, \code{\link{predict.rqda}}, \code{\link{err.est.rqda}}
}
\examples{
data(Vehicle2)
levels(Vehicle2$Class)
## "bus" "opel" "saab" "van"

data <- Vehicle2
levels(data$Class) <- c(4, 1, 2, 3)  
## classes ordered by increasing size
## 
## according to variable definitions, we can consider
## the following restrictions on the mean vectors:
## mu11, mu21 <= mu31 <= mu41
## mu12, mu22 <= mu32 <= mu42
## mu13, mu23 >= mu33 >= mu43
A <- matrix(0, ncol = 12, nrow = 9)
A[t(matrix(c(1,1,2,4,3,7,4,2,5,5,6,8,7,9,8,9,9,12), nrow = 2))] <- 1
A[t(matrix(c(1,7,2,7,3,10,4,8,5,8,6,11,7,3,8,6,9,9), nrow = 2))] <- -1
set.seed(1725)
values <- runif(dim(data)[1])
trainsubset <- values < 0.25
testsubset <- values >= 0.25
obj <- rlda(Class ~ Pr.Axis.Ra + logSkew.Maxis + Holl.Ra, data, 
            subset = trainsubset, gamma = c(0, 0.5, 1), 
            resmatrix = A)
pred <- predict(obj, newdata = data[testsubset,], gamma = c(0.5, 1),
                grouping = data[testsubset, "Class"])

data <- Vehicle2[, c("Pr.Axis.Ra", "logSkew.Maxis")]
grouping <- Vehicle2$Class
levels(grouping) <- c(3, 1, 1, 2)  
## now we can consider the following restrictions:
## mu11 <= mu21 <= mu31
## mu12 <= mu22 <= mu32
set.seed(1652)
values <- runif(dim(data)[1])
trainsubset <- values < 0.25
testsubset <- values >= 0.25
obj <- rlda(data, grouping, subset = trainsubset, restext = "s<1,2")
pred <- predict(obj, data[testsubset,], prior = c(1/3, 1/3, 1/3))
}
\keyword{ multivariate }
\keyword{ classif }