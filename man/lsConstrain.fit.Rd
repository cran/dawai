% $Author: sinnwell $ -->
% $Date: 2010/02/08 18:14:18 $ -->
% $Header: /people/biostat3/sinnwell/Projects/IBDReg/Make/RCS/lsConstrain.fit.Rd,v 1.2 2010/02/08 18:14:18 sinnwell Exp $ -->
% $Locker:  $ -->
% 
%Log: $
%
\name{lsConstrain.fit}
\alias{lsConstrain.fit}
\title{
  Minimize Inequality Constrained Mahalanobis Distance 
}
\description{
Find the vector z that solves:

  min\{ (x - z)'inv(S)(x - z); Az <= b \},

where x is an input vector, S its covariance matrix,
A is a matrix of known contrasts, and b is a vector
of known constraint constants.
}
\usage{
lsConstrain.fit(x, b, s, a, iflag, itmax=4000, eps=1e-06, eps2=1e-06)
}
\arguments{
\item{x}{
vector of length n
}
\item{b}{
vector of length k, containing constraint constants
}
\item{s}{
matrix of dim n x n, the covariance matrix for vector x
}
\item{a}{
matrix of dim k x n, for the contraints
}
\item{iflag}{
vector of length k; an item = 0 if inequality constraint, 1 if equality constraint
}
\item{itmax}{
scalar for number of max interations
}
\item{eps}{
scalar of accuracy for convergence
}
\item{eps2}{
scalar to determine close to zero
}
}
\value{
List with the following components:

itmax:   (defined above)

eps:     (defined above)

eps2:    (defined above)

iflag:   (defined above)

xkt:     vector of length k, for the Kuhn-Tucker coefficients.

iter:    number of completed iterations.

supdif:  greatest difference between estimates across a full cycle

ifault:  error indicator:
               0 = no error
               1 = itmax exceeded
               3 = invalid constraint function for some row ASA'=0.

a:       (defined above)

call:    function call

x.init:  input vector x.

x.final: the vector "z" that solves the equation (see z in description).

s:       (defind above)

min.dist: the minimum value of the function (see description).
}
\section{References}{
Wollan PC, Dykstra RL. Minimizing inequality constrained
mahalanobis distances. Applied Statistics Algorithm AS 225 (1987).
}
\examples{
# An simulation example with linear regression with 3 beta's, 
# where we have the contraints:
#
# b[1] > 0
# b[2] - b[1] < 0
# b[3] < 0


set.seed(111)

n <- 100
x <- rep(1:3,rep(n,3))
x <- 1*outer(x,1:3,"==")

beta <- c(2,1,1)

y <- x\%*\%beta + rnorm(nrow(x))

fit <- lm(y ~-1 + x)

s <- solve( t(x) \%*\% x )

bhat <- fit$coef


a <-  rbind(c(-1, 0, 0),
            c(-1, 1, 0),
            c( 0, 0, 1))

# View expected constraints (3rd not met):

a \%*\% bhat
#            [,1] 
# [1,] -1.8506811
# [2,] -0.9543320
# [3,]  0.8590827

b <- rep(0, nrow(a))
iflag <- rep(0,length(b))

save <- lsConstrain.fit(x=bhat,b=b, s=s, a=a, iflag=iflag, itmax=500, 
                        eps=1e-6, eps2=1e-6)

save
}
% docclass is function
% Converted by Sd2Rd version 43267.
