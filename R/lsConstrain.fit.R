#$Author: sinnwell $
#$Date: 2006/09/12 21:38:40 $
#$Header: /people/biostat3/sinnwell/Projects/IBDReg/Make/RCS/lsConstrain.fit.q,v 1.5 2006/09/12 21:38:40 sinnwell Exp $
#$Locker:  $
#$Log: lsConstrain.fit.q,v $
#Revision 1.5  2006/09/12 21:38:40  sinnwell
#package to PACKAGE
#
#Revision 1.4  2006/06/06 14:47:15  sinnwell
#add package="ibdreg" for .C
#
#Revision 1.3  2006/04/26 15:55:55  sinnwell
#took out a browser call, it was added during debug
#
#Revision 1.2  2006/04/20 18:13:44  sinnwell
#check code, fixed a comment
#
#Revision 1.1  2006/03/08 16:37:52  sinnwell
#Initial revision
#
lsConstrain.fit <- function(x, b, s, a, iflag, itmax=4000,eps=1e-6, eps2=1e-6){

# Use the method of Wollan and Dykstra for minimizing inequality constrained
# mahalanobis distances (translated AS 225 from fortran to C)
#
# Wollan PC, Dykstra RL. Minimizing inequality constrained
# mahalanobis distances. Applied Statistics Algorithm AS 225 (1987).

# Input:
# x     =  vector of length n
# b     =  vector of length k, containing constraint constants
# s     = matrix of dim n x n, the covariance matrix for vector x
# a     = matrix of dim k x n, for the contraints
# iflag = vector of length k; an item = 0 if inequality constraint, 1 if equality constraint
# itmax = scalar for number of max interations
# eps   = scalar of accuracy for convergence
# eps2  = scalar to determine close to zero

# Find the g vector that solves:
#
#  min{ (x-g)'S^{-1}(x-g); ag <= b }
#
# The vector g is returned as x.final


call <- match.call()

n <- length(x)
k <- length(b)

nwork <- 2*n*k + n + k

if(n==0){
    stop("length x = 0")
}
if(k==0){
    stop("length b = 0")
}
if(itmax<=0){
    stop("itmax <= 0")
}
if(eps <= 0 | eps2 <=0){
    stop("eps <=0 or eps2 <=0")
}
if(nwork <=0){
    stop("nwork <=0")
}

nk = n * k
nk2 = nk + nk
nk2k = nk2 + k

if(nwork < (nk2k + n)){
    stop("not enough work space: nwork < (nk2k + n)")
}
if(any( (iflag!=0) & (iflag!=1) )){
    stop("iflag value not a 1 or 0")
}


avec <- as.vector(a)


tmp <- .C("lsConstrain",
          x=as.double(x),
          n=as.integer(n),
          k=as.integer(k),
          nwork=as.integer(nwork),
          itmax=as.integer(itmax),
          eps=as.double(eps),
          eps2=as.double(eps2),
          svec=as.double(as.vector(s)),
          avec=as.double(avec),
          b=as.double(b),
          iflag=as.integer(iflag),
          xhat=as.double(numeric(n)),
          xkt=as.double(numeric(k)),
          iter=as.integer(0),
          supdif=as.double(0),
          ifault=as.integer(1),
          w=as.double(numeric(nwork)),
          PACKAGE="dawai")
  

if(tmp$ifault!=0){
  warning("Convergence not achieved")
}

tmp$svec <- NULL
tmp$avec <- NULL
tmp$a <- a
tmp$w <- NULL
tmp$call <- call
tmp$x.init <- tmp$x
tmp$x.final <- tmp$xhat
tmp$x <- NULL
tmp$xhat <- NULL
tmp$n <- NULL
tmp$k <- NULL
tmp$nwork <- NULL
tmp$s <- s

delta <- (tmp$x.init - tmp$x.final)
tmp$min.dist <- t(delta) %*% solve(s) %*% delta

return(tmp)
               
}

