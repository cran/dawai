\name{rlda}
\alias{rlda}
\alias{rlda.formula}
\alias{rlda.default}
\alias{rlda.data.frame}
\alias{rlda.matrix}
\title{Restricted Linear Discriminant Analysis}
\description{Build linear classification rules with additional information expressed as inequality restrictions among the populations means.}
\usage{
rlda(x, \dots)

\method{rlda}{matrix}(x, \dots)

\method{rlda}{data.frame}(x, grouping, \dots)

\method{rlda}{formula}(formula, data, \dots)

\method{rlda}{default}(x, grouping, subset = NULL, resmatrix = NULL, resvector = NULL, 
     restext = NULL, gamma = c(0, 1), prior = NULL, \dots)
}
\arguments{
  \item{formula}{ A formula of the form \code{groups ~ x1 + x2 + ...}. That is, the response is the grouping factor and the right hand side specifies the (non-factor) discriminators. }
  \item{data}{ Data frame from which variables specified in \code{formula} are to be taken. }
  \item{x}{ (Required if no formula is given as the principal argument.) A data frame or matrix containing the explanatory variables. }
  \item{grouping}{ (Required if no formula is given as the principal argument.) A numeric vector or factor with numeric levels specifying the class for each observation. }
  \item{subset}{ An index vector specifying the cases to be used in the training sample. }
  \item{resmatrix}{ A matrix specifying the linear restrictions on the mean vectors: \code{resmatrix} \code{\%*\%} \code{mu} \code{<=} \code{resvector}, where \code{mu = c(mu1, mu2, ...)} and \code{mui} is the mean vector of class \code{i}. If unspecified, \code{restext} will be required (and \code{resmatrix} established accordingly). }
  \item{resvector}{ A vector of constant values: \code{resmatrix \%*\% mu <= resvector}. By default, \code{resvector = rep(0, dim(resmatrix)[1])}. }
  \item{restext}{ (Required if no \code{resmatrix} argument is given.) A character string from which \code{resmatrix} will be calculated. The first element must be either \code{"s"} (simple order) or \code{"t"} (tree order: \code{mu1 >= mu2, mu1 >= mu3 ...}). The second element must be either \code{"<"} (increasing componentwise order) or \code{">"} (decreasing componentwise order). The rest of the elements must be numbers from 1 to the number of explanatory variables, separated by commas, specifying among which variables the restrictions hold. For example, \code{"s<1,3"} will stand for \code{mu11} \code{<=} \code{mu21} \code{<=} \code{mu31} \code{<=} \dots, \code{mu13} \code{<=} \code{mu23} \code{<=} \code{mu33} \code{<=} \dots }
  \item{gamma}{ A vector of values in the unit interval that determine the classification rules with additional information (see references). }
  \item{prior}{ The prior probabilities of class membership. If unspecified, the class proportions for the training set are used. If present, the probabilities must be specified in the order of the factor levels. }
  \item{\dots}{ Arguments passed to or from other methods. }
}
\details{
Specifying the \code{prior} will affect the classification and error unless over-ridden in \code{predict.rlda} and \code{err.est.rlda}, respectively.
}
\value{
An object of class \code{'rlda'} containing the following components:
  \item{call}{ The (matched) function call. }
  \item{trainset}{ Matrix with the training set used (first columns) and the class for each observation (last column). }
  \item{restrictions}{ Edited character string with the linear restrictions on the mean vectors detailed. }
  \item{resmatrix}{ The matrix with the restrictions on the mean vectors used. }
  \item{resvector}{ Constant values vector used. }
  \item{prior}{ Prior probabilities of class membership used. }
  \item{counts}{ The number of observations of the classes used. }
  \item{N}{ The total number of observations used. }
  \item{samplemeans}{ Matrix with the sample means in rows. }
  \item{samplevariances}{ Array with the sample covariance matrices of the classes. }
  \item{gamma}{ Gamma values used. }
  \item{spooled}{ Pooled covariance matrix. }
  \item{estimatedmeans}{ Array with the estimated means for each classification rule. }
  \item{apparent}{ Apparent error rate for each classification rule. }
}
\references{
Conde, D., Fernandez, M. A., Rueda, C., and Salvador, B. (2012). Classification of samples into two or more ordered populations with application to a cancer trial. \emph{Statistics in Medicine}, \bold{31}, 3773-3786.

Fernandez, M. A., Rueda, C., Salvador, B. (2006). Incorporating additional information to normal linear discriminant rules. \emph{Journal of the American Statistical Association}, \bold{101}, 569-577.
}
\author{
David Conde
}
\note{
This function may be called giving either a formula and data frame, or a data frame and grouping factor, or a matrix and grouping factor as the first two arguments. All other arguments are optional.

Classes must be identified, either in a column of \code{data} or in the \code{grouping} vector, by natural numbers varying from 1 to the number of classes. The number of classes must be greater than 1.

If there are missing values in either \code{data}, \code{x} or \code{grouping}, corresponding observations will be deleted.

To overcome singularity of the covariance matrices, the number of observations in each class must be greater or equal than the number of explanatory variables.
}
\seealso{
\code{\link{predict.rlda}}, \code{\link{err.est.rlda}}, \code{\link{rqda}}, \code{\link{predict.rqda}}, \code{\link{err.est.rqda}}
}
\examples{
data(Vehicle2)
levels(Vehicle2$Class)
## "bus" "opel" "saab" "van"

data <- Vehicle2
levels(data$Class) <- c(4, 1, 2, 3)  
## classes ordered by increasing size
## 
## according to variable definitions, we can 
## think of next restrictions on the mean vectors:
## mu11, mu21 <= mu31 <= mu41
## mu12, mu22 <= mu32 <= mu42
## mu13, mu23 >= mu33 >= mu43
A <- matrix(0, ncol = 12, nrow = 9)
A[t(matrix(c(1,1,2,4,3,7,4,2,5,5,6,8,7,9,8,9,9,12), nrow = 2))] <- 1
A[t(matrix(c(1,7,2,7,3,10,4,8,5,8,6,11,7,3,8,6,9,9), nrow = 2))] <- -1
set.seed(1725)
values <- runif(dim(data))
trainsubset <- values < 0.25
testsubset <- values >= 0.25
obj <- rlda(Class ~ Pr.Axis.Ra + logSkew.Maxis + Holl.Ra, 
            data, subset = trainsubset, gamma = c(0, 0.5, 1), 
            resmatrix = A)

data <- Vehicle2[, c("Pr.Axis.Ra", "logSkew.Maxis")]
grouping <- Vehicle2$Class
levels(grouping) <- c(3, 1, 1, 2)  
## now we can think of next restrictions:
## mu11 <= mu21 <= mu31
## mu12 <= mu22 <= mu32
set.seed(1652)
values <- runif(length(rownames(data)))
trainsubset <- values < 0.25
testsubset <- values >= 0.25
obj <- rlda(data, grouping, subset = trainsubset, 
            restext = "s<1,2")
}
\keyword{ multivariate }
\keyword{ classif }