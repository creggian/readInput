Parse parameters for R scripts
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
