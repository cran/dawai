posterior <- 
function(y, means, variances, prior, numgroups, dimension)
{
    values <- array(NA, c(dim(y)[1], numgroups))
    if(dimension == 1)
        for(i in 1:numgroups)
            values[, i] <- prior[i] * dnorm(y, means[i], sqrt(variances[, , i]))
    else
        for(i in 1:numgroups)
            values[, i] <- prior[i] * c(apply(y, 1, dmvnorm, means[{dimension*{i - 1} + 1}:{dimension*i}], 
                                        variances[, , i]))
    values <- values / rowSums(values)   
    return(values)
}
