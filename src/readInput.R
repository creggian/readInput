readInput <- function(default_args, args=commandArgs(TRUE), print.input=TRUE) {
  default_args <- as.data.frame(default_args, stringsAsFactors=FALSE)
  colnames(default_args) <- c("arg", "value", "description", "cast")
  
  default_args_string <- default_args
  default_args_string$arg <- paste(rep("\t", 4), "--", default_args_string$arg, sep="")
  
  if(length(args) < 1) {
    args <- c("--help")
  }
  
  ## Help section
  if("--help" %in% args) {
    cat("
        Welcome to the help message :)
        
        Default arguments:", "\n")
    cat(paste(do.call("paste", c(default_args_string[c("arg", "value")], sep="=")), collapse="\n"))
    cat("\n\n")
    
    q(save="no")
  }
  
  custom_args <- default_args
  
  parseArgs <- function(x) {
    l <- strsplit(sub("^--", "", x), "=")
    lapply(l, function(x) {c(x, rep(NA, 3-length(x)))})
  }
  argsDF <- as.data.frame(do.call("rbind", parseArgs(args)), stringsAsFactors=FALSE)
  
  if (!Reduce("&", argsDF$V1 %in% default_args$arg)) {
    cat("ERROR: wrong parameter definition, please use --help for documentation", "\n")
    q(save="no")
  }
  
  # overriding
  for (i in 1:length(argsDF$V1)) {
    arg <- argsDF$V1[i]
    custom_args$value[custom_args$arg == arg] <- argsDF$V2[i]
    if (!is.na(argsDF$V3[i])) {
      custom_args$cast[custom_args$arg == arg] <- argsDF$V3[i]
    }
  }
  
  argsL <- as.list(as.character(custom_args$value))
  argsL <- lapply(seq(1:length(argsL)), function(idx) {
    do.call(custom_args[idx,c("cast")], args=list(argsL[[idx]]))
  })
  names(argsL) <- custom_args$arg
  
  if (print.input) {
    custom_args_string <- cbind(
      names(argsL), sapply(argsL, function(x) {paste(as.character(x), collapse="; ")})
    )
    custom_args_string <- as.data.frame(custom_args_string, stringsAsFactors=FALSE)
    colnames(custom_args_string) <- c("arg", "value")
    custom_args_string$arg <- paste("-- ", custom_args_string$arg, sep="")
    
    cat("\n", "Script running with the following parameters", "\n", sep="")
    cat(paste(do.call("paste", c(custom_args_string[c("arg", "value")], sep=": ")), collapse="\n"))
    cat("\n", "------------------------------------------", "\n", sep="")
  }
  
  argsL
}
