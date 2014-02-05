classify <- 
function(y, means, variances, prior, numgroups, dimension)
{
    values <- array(NA, c(dim(y)[1], numgroups))
    if(dimension == 1)
        for(i in 1:numgroups)
            values[, i] <- prior[i] * dnorm(y, means[i], sqrt(variances[, , i]))
    else
        for(i in 1:numgroups)
            values[, i] <- prior[i] * c(apply(y, 1, dmvnorm, means[{dimension * {i - 1} + 1}:{dimension * i}], 
                                        variances[, , i]))
    maxClass <- {values == apply(values, 1, max)} * rep(1:numgroups, each = length(as.matrix(y)) / dimension)
    group <- apply(maxClass, 1, function(x) x[x != 0][sample(length(x[x != 0]), 1)])
    return(group)
}