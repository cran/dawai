\name{err.est}
\alias{err.est}
\title{Restricted Discriminant Analysis. True Error Rate estimation}
\description{\code{err.est} is a generic function for true error rate estimations of classification rules built with additional information. The function invokes particular \emph{methods} which depend on the \code{\link{class}} of the first argument.}
\usage{
err.est(x, \dots)
}
\arguments{
  \item{x}{ An object for which true error rate estimations are desired. }
  \item{\dots}{ Additional arguments affecting the true error rate estimations produced. }
}
\value{	
See the documentation of the particular methods for details of what is produced by each method.
}
\author{
David Conde
}
\seealso{
\code{\link{err.est.rlda}}, \code{\link{err.est.rqda}}
}
\keyword{ multivariate }
\keyword{ classif }