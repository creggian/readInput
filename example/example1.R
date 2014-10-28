# Task 1: run $ Rscript example1.R
# Task 2: run $ Rscript example1.R --name=my_new_name
# Task 3: run $ Rscript example1.R --n_feature_selection_to=110astext=as.character
# Task 4: run $ Rscript example1.R --phenotype=NULL=as.null

source("../src/readInput.R")

evalParseText <- function(text) {
  eval(parse(text=text))
}

default_args <- rbind(
  cbind("name", "classification_fs_1x_nfs5to110by5_fs29582", ".", "as.character"),
  cbind("classification_type", "cases_vs_control", "cases_vs_control or cases_vs_cases", "as.character"),
  cbind("resampling_times", "1", ".", "as.numeric"),
  cbind("feature_range", "c(1:50)", ".", "evalParseText"),
  cbind("n_feature_selection_from", "5", ".", "as.numeric"),
  cbind("n_feature_selection_to", "110", ".", "as.numeric"),
  cbind("n_feature_selection_by", "5", ".", "as.numeric"),
  cbind("do_classification_task", "TRUE", ".", "as.logical"),
  cbind("phenotype", "Autism", ".", "as.list"),
  cbind("ncores", "1", ".", "as.numeric"),
  cbind("init_directory", "/my/home/directory", ".", "as.character"),
  cbind("output_dir", "/my/output/directory/", ".", "as.character")
)

#args <- c("--name=prova", "--n_feature_selection_to=5", "--feature_range=c(1:240)")
#argsL <- readInput(default_args, args)
argsL <- readInput(default_args, commandArgs(TRUE))

print(argsL)

name <- argsL$name
classification_type <- argsL$classification_type
resampling_times <- argsL$resampling_times
feature_range <- argsL$feature_range
n_feature_selection_from <- argsL$n_feature_selection_from
n_feature_selection_to <- argsL$n_feature_selection_to
n_feature_selection_by <- argsL$n_feature_selection_by
do_classification_task <- argsL$do_classification_task
phenotype <- argsL$phenotype
ncores <- argsL$ncores
init_directory <- argsL$init_directory
output_dir <- argsL$output_dir
