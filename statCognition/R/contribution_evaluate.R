.contribution_evaluate <- function(obj, val){
  stopifnot(class(obj) == "contribution", is.numeric(val), length(val) == 1)

  idx <- which(obj$breakpoints <= val)
  if(length(idx) == 0) return(obj$values[1]) else return(obj$values[max(idx)])
}