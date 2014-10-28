Parameter parser for R scripts
==============================

The goal is to easily parse parameters when launching R script using `Rscript` command. Example:

`Rscript myscript.R --arg1=param1 --arg2=param2`

What to do
----------

* create a data.frame with default arguments (and little bit more)
* merge default with custom parameters
* retrieve the final values

How to do that?
---------------

I will detail what is included in `src/example1.R` (which is a runnable example)

`default_args <- rbind(
  cbind("name", "my_job_name", ".", "as.character"),
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
)`

`default_args` is a data.frame with as many rows as parameters and 4 columns

* column 1: parameter name
* column 2: default value
* column 3: description written in the help message (not yet implemented)
* column 4: preprocessing function

The first three column meanings are quite intuitive. The fourth one is the function name used to convert the value passed as a string to its real value. For instance, `resampling_times` value is "1" (as string) but the in the script I want to use it as numeric, and calling "as.numeric" will help me out.

For the preprocessing function you can use both built-in and user-defined functions, such as `evalParseText` (see the example file for the code).

`argsL <- readInput(default_args, commandArgs(TRUE))`

`argsL` is a list (one item per each parameter) resulting from merging default and custom parameters. One remarks: if there is one custome parameter not listed in the default ones, the script will generate an error and quit.
