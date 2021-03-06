\name{predict.rqda}
\alias{predict.rqda}
\title{Restricted Quadratic Discriminant Analysis. Multivariate Observations Classification}
\description{Classify multivariate observations with quadratic classification rules built with additional information in conjunction with \code{rqda}.}
\usage{
\method{predict}{rqda}(object, newdata, prior = object$prior,
        gamma = object$gamma, grouping = NULL, \dots)
}
\arguments{
  \item{object}{ An object of class \code{'rqda'}. }
  \item{newdata}{ A data frame of cases to be classified, containing the variables used on creating \code{object}. A vector will be interpreted as a row vector. }
  \item{prior}{ The prior probabilities of class membership. If unspecified, \code{object$prior} probabilities are used. If present, the probabilities must be specified in the order of the factor levels. }
  \item{gamma}{ A vector of values specifying which rules to take among the ones in \code{object}. If unspecified, all rules built with \code{object$gamma} will be used. If present, \code{gamma} must be contained in \code{object$gamma}. }
  \item{grouping}{ A numeric vector or factor with numeric levels specifying the class for each observation. If present, true error rate will be estimated from \code{newdata}. }
  \item{\dots}{ Arguments based from or to other methods. }
}
\details{
This function is a method for the generic function \code{predict()} for class \code{'rqda'}.
}
\value{
A list with components
  \item{call}{ The (matched) function call. }
  \item{class}{ Matriarchx with the classification for each rule (in columns). }
  \item{prior}{ The prior probabilities of the classes used. }
  \item{posterior}{ Array with the posterior probabilities of the classes for each rule. }
  \item{error.rate}{ True error rate estimation (when \code{grouping} specified) for each rule, based on \code{newdata}. }
}
\references{
Conde, D., Fernandez, M. A., Rueda, C., and Salvador, B. (2012). Classification of samples into two or more ordered populations with application to a cancer trial. \emph{Statistics in Medicine}, \bold{31}, 3773-3786.

Conde, D., Fernandez, M. A., Salvador, B., and Rueda, C. (2015). dawai: An R Package for Discriminant Analysis with Additional Information. \emph{Journal of Statistical Software}, \bold{66(10)}, 1-19. URL http://www.jstatsoft.org/v66/i10/.
}
\author{
David Conde
}
\note{
If there are missing values in \code{newdata}, corresponding observations will not be classified.

If there are missing values in \code{grouping}, corresponding observations will not be considered on calculating the true error rate.
}
\seealso{
\code{\link{rqda}}, \code{\link{err.est.rqda}}, \code{\link{rlda}}, \code{\link{predict.rlda}}, \code{\link{err.est.rlda}}
}
\examples{
data(Vehicle2)
levels(Vehicle2$Class)
## "bus" "opel" "saab" "van"

data <- Vehicle2[, 1:4]
grouping = Vehicle2$Class
levels(grouping) <- c(4, 2, 1, 3)
## classes ordered by increasing size
## 
## according to variable definitions, we can consider 
## the following restrictions on the means vectors:
## mu11 >= mu21 >= mu31 >= mu41
## mu12 >= mu22 >= mu32 >= mu42
## mu13 >= mu23 >= mu33 >= mu43
## 
## we can specify these restrictions by restext = "s>1,2,3"

set.seed(7964)
values <- runif(dim(data)[1])
trainsubset <- values < 0.2
testsubset <- values >= 0.2
obj <- rqda(data, grouping, subset = trainsubset,
            gamma = (1:5)/5, restext = "s>1,2,3")
pred <- predict(obj, newdata = data[testsubset,], 
                grouping = grouping[testsubset])
pred$error.rate
## we can see that the test error rate of the restricted
## rules decrease with gamma:
##                      gamma=0.2 gamma=0.4 gamma=0.6 gamma=0.8  gamma=1
## True error rate (%):  40.14815  39.85185  39.85185  39.11111 39.11111
}
\keyword{ multivariate }
\keyword{ classif }
