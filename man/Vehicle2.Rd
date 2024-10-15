\name{Vehicle2}
\alias{Vehicle2}
\docType{data}
\title{Vehicle Silhouettes 2}
\description{
The purpose is to classify a given silhouette as one of four types of vehicle, using a set of features extracted from the silhouette. The vehicle may be viewed from one of many different angles. The features were extracted from the silhouettes by the HIPS (Hierarchical Image Processing System) extension BINATTS, which extracts a combination of scale independent features utilising both classical moments based measures such as scaled variance, skewness and kurtosis about the major/minor axes and heuristic measures such as hollows, circularity, rectangularity and compactness.

Four "Corgie" model vehicles were used for the experiment: a double decker bus, Cheverolet van, Saab 9000 and an Opel Manta 400. This particular combination of vehicles was chosen with the expectation that the bus, van and either one of the cars would be readily distinguishable, but it would be more difficult to distinguish between the cars.
}
\usage{data(Vehicle2)}
\format{
A data frame with 846 observations on 4 variables, all numerical and one nominal defining the class of the objects.
\tabular{rll}{ 
  [,1] \tab Skew.maxis   \tab Skewness about minor axis \cr
  [,2] \tab Kurt.Maxis   \tab Kurtosis about major axis \cr
  [,3] \tab Holl.Ra      \tab Hollows ratio: (area of hollows)/(area of bounding polygon) \cr
  [,4] \tab Sc.Var.maxis \tab Scaled variance along minor axis: (2nd order moment about minor axis)/area \cr
  [,5] \tab Class        \tab Type \cr
}
}
\source{
\itemize{
  \item Creator: Drs.Pete Mowforth and Barry Shepherd, Turing Institute, Glasgow, Scotland.
}
These data have been taken from the UCI Repository Of Machine Learning Databases at
\itemize{
  \item \url{http://archive.ics.uci.edu/ml/index.php}
}
and were converted to R format by Evgenia Dimitriadou.
}
\references{
Turing Institute Research Memorandum TIRM-87-018 "Vehicle Recognition Using Rule Based Methods" by Siebert, JP (March 1987).

Newman, D.J. & Hettich, S. & Blake, C.L. & Merz, C.J. (1998). UCI Repository of machine learning databases [http://www.ics.uci.edu/~mlearn/MLRepository.html]. Irvine, CA: University of California, Department of Information and Computer Science.}
\examples{
data(Vehicle2)
summary(Vehicle2)}
\keyword{datasets}
