restrictions <- 
function(resmatrix, ...) UseMethod("restrictions")

restrictions.default <- 
function(resmatrix, resvector, dimension, ...)
{
    sign <- function(x){paste(ifelse(x >= 0, "+", "-"), " ", 
                        ifelse(abs(x) != 1, paste(abs(x), "*", sep = ""), ""), sep = "")}
    numgroups <- dim(resmatrix)[2] / dimension
    variables <- paste("mu", rep(1:numgroups, each = dimension), ",", 1:dimension, sep = "")
    restriction <- ""
    for(i in 1:length(resvector))
    {
        con <- paste(paste(" ", sign(resmatrix[i, resmatrix[i, ] != 0]), 
                     variables[resmatrix[i, ] != 0], sep = "", collapse = ""), 
                     "<=", resvector[i])
        if(substr(con, 1, 2) == " +")
            con=paste("  ", substr(con, 3, nchar(con)), sep="")
        restriction <- paste(restriction, con, "\n", sep = "")
    }
    class(restriction) <- "restrictions"
    restriction
}

print.restrictions <- 
function(x, ...)
{
    cat(x)
}