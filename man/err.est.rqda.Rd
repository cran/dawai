\name{err.est.rqda}
\alias{err.est.rqda}
\title{Restricted Quadratic Discriminant Analysis. True Error Rate Estimation}
\description{Estimate the true error rate of quadratic classification rules built with additional information (in conjunction with \code{rqda}).}  
\usage{
\method{err.est}{rqda}(x, nboot = 50, gamma = x$gamma, prior = x$prior, \dots)
}
\arguments{
  \item{x}{ An object of class \code{'rqda'}. }
  \item{nboot}{ Number of bootstrap samples used to estimate the true error rate of the classification rules. }
  \item{gamma}{ A vector of values specifying which rules to take among the ones in \code{x}. If unspecified, all rules built with \code{x$gamma} will be used. If present, \code{gamma} must be contained in \code{x$gamma}. }
  \item{prior}{ The prior probabilities of class membership. If unspecified, \code{x$prior} probabilities are used. If present, the probabilities must be specified in the order of the factor levels. }
  \item{\dots}{ Arguments based from or to other methods. }
}
\details{
This function is a method for the generic function \code{err.est()} for class \code{'rqda'}.
}
\value{
A list with components
  \item{call}{ The (matched) function call. }
  \item{restrictions}{ Character vector with the restrictions on the means vector detailed. }
  \item{prior}{ The prior probabilities of the classes used. }
  \item{counts}{ The number of observations of the classes used. }
  \item{N}{ The total number of observations used. }
  \item{estimationError}{ Matrix with BT2, BT3, BT2CV and BT3CV true error rate estimates of the rules. }
}
\references{
Conde, D., Fernandez, M. A., Rueda, C., and Salvador, B. (2012). Classification of samples into two or more ordered populations with application to a cancer trial. \emph{Statistics in Medicine}, \bold{31}, 3773-3786.

Conde, D., Fernandez, M. A., Salvador, B., and Rueda, C. (2015). dawai: An R Package for Discriminant Analysis with Additional Information. \emph{Journal of Statistical Software}, \bold{66(10)}, 1-19. URL http://www.jstatsoft.org/v66/i10/.

Conde, D., Salvador, B., Rueda, C. , and Fernandez, M. A. (2013). Performance and estimation of the true error rate of classification rules built with additional information. An application to a cancer trial. \emph{Statistical Applications in Genetics and Molecular Biology}, \bold{12(5)}, 583-602.
}
\author{
David Conde
}
\note{
To overcome singularity of the covariance matrices after bootstraping, the number of observations in each class must be greater than the number of explanatory variables divided by 0.632.
}
\seealso{
\code{\link{err.est}}, \code{\link{rqda}}, \code{\link{predict.rqda}}, \code{\link{rlda}}, \code{\link{predict.rlda}}, \code{\link{err.est.rlda}}
}
\examples{
data(Vehicle2)
levels(Vehicle2$Class)
## "bus" "opel" "saab" "van"

data = Vehicle2[, c("Kurt.Maxis", "Holl.Ra", "Sc.Var.maxis")]
grouping = Vehicle2$Class
levels(grouping) <- c(3, 1, 1, 2)  
## now we can consider the following restrictions:
## mu11 >= mu21 >= mu31
## mu12 >= mu22 >= mu32
## 
## we can specify these restrictions by restext = "s>1,2"

set.seed(5561)
values <- runif(length(rownames(data)))
trainsubset <- values < 0.05
testsubset <- values >= 0.05
obj <- rqda(data, grouping, subset = trainsubset, restext = "s>1,2")
pred <- predict(obj, data[testsubset,], grouping = grouping[testsubset],
                prior = c(1/3, 1/3,1/3))
pred$error.rate
err.est(obj, 25, prior = c(1/3, 1/3, 1/3))
}
\keyword{ multivariate }
\keyword{ classif }