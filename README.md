Parameter parser for R scripts
==============================

I wanted to get rid of all hardcoded parameters in my script and at the same time have a friendly script that takes care of reading the parameters given as input from the outside environment (i.e. bash). Therefore I developed `readInput` function, which easily parse parameters and provide an "help" text message when launching R script using `Rscript` command, such as

`Rscript myscript.R --arg1=param1 --arg2=param2`

Why
---

There have been two main motivations for this script

1. The need to easily define, read and parse parameters in R, given as input from the outside environment (i.e. from a bash script)
2. Being more efficient with Resource Managers such as Slurm and TORQUE. Their documentations suggest to create a file bash which includes the demanded resources and the script to be run. However, the file will be read only when the submitted job (with `sbatch` or `qsub` commands) starts running, until that time it's not possible to submit a second time with different parameters. Here I wanted to find out a workaround to overcome this limitation.


What to do
----------

Inside R
1. create a data.frame with default arguments (and little bit more)
2. merge default with custom parameters
3. retrieve the final values and run your code

In your bash console
* run your script with `Rscript` command

Extra
* combine `sbatch` and `Rscript` in **one-line**

How to do that?
---------------

I will detail what is included in `src/example1.R` (which is a runnable example)

	default_args <- rbind(
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
	)

`default_args` is a data.frame with as many rows as parameters and 4 columns

* column 1: parameter name
* column 2: default value
* column 3: description written in the help message (not yet implemented)
* column 4: preprocessing function

The first three column meanings are quite intuitive. The fourth one is the function name used to convert the value passed as a string to its real value. For instance, `resampling_times` value is "1" (as string) but the in the script I want to use it as numeric, and calling "as.numeric" will help me out.

For the preprocessing function you can use both built-in and user-defined functions, such as `evalParseText` (see the example file for the code).

`argsL <- readInput(default_args, commandArgs(TRUE))`

`argsL` is a list (one item per each parameter) resulting from merging default and custom parameters. One remark: if there is one custom parameter not listed in the default ones, the script will generate an error and quit.

*Final remark*: right now it is mandatory to provide at least one parameter, otherwise the help text will be shown. 

Example
-------

Download the files, open a (bash) terminal and move to the `example` directory. Then run the following

	Rscript example1.R
	Rscript example1.R --name=my_new_name
	Rscript example1.R --n_feature_selection_to=110astext=as.character
	Rscript example1.R --phenotype=NULL=as.null

and give a look at how the parameters have been read, parsed and preprocessed in the resulting list.

By the way the most effective advantage is using it in combination with Resource Manager, in this example I'll use `sbatch`. The idea here is to provide a **one-line sbatch** command instead of a file

	sbatch  --job-name=my_job_name \
	        --output=my_job_name.out \
		--nodes=1 \
		--ntasks=1 \
		--time=10:00:00 \
		--mem=2000 \
		<<EOF
	#!bin/bash
	module load R/3.0.2
	Rscript /path/to/my/workdir/example1.R \
	        --name="my_job_name" \
		--resampling_times="1" \
		--classification_type="cases_vs_control" \
		--do_classification_task="TRUE" \
		--n_feature_selection_from="5" \
		--n_feature_selection_to="110" \
		--n_feature_selection_by="5" \
		--feature_range="c(241:29582)" \
		--phenotype_list="Intellectual disability"=list_with_name \
		--ncores="1" \
		--init_directory="/path/to/my/workdir/RData" \
		--output_dir="/path/to/my/workdir/output"
	EOF

Ok, it's not one line for humans :) but it is for the machine. And it is easy to edit-copy-paste in your remote cluster and submit a new job

**BONUS**: in this way it easy to create a for loops to launch job array, whenever the resource manager does not support it

**REMARK**: run the example using `Rscript` command from your console. If you try to copy-paste and run the same code inside RStudio or in a R console, it will crash because of `commandArgs(TRUE)`.

To Do
-----

* Include the description in the help
* Run with no custom values
