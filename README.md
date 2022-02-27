# Cherry Blossom Peak Bloom Prediction

Author: Steven Lio  
Date: Feb-2022

This is the repository for George Mason’s Department of Statistics cherry blossom peak bloom prediction competition.

This repository contains cleaned and ready-to-use data on peak bloom dates in the *data/* folder, alongside the rendered prediction analysis report can be found [here](https://htmlpreview.github.io/?https://github.com/stevenlio88/peak-bloom-prediction/blob/main/doc/Cherry_Blossom_Prediction.html)
and the pdf file can be found [here](https://github.com/stevenlio88/peak-bloom-prediction/blob/main/doc/Cherry_Blossom_Prediction.pdf).


### Requirements
----------------

You will need R (>=4.1.1) as well as the following recommended libraries:
-	tidyverse
-	ggplot2
-	plotly
-	broom
-	lubridate
-	forecast
-	rnoaa

### Reproduce the results
-------------------------

The results of this submission can be reproduced by follow the following steps:

1. Clone this repo to your local machine

```sh
$ git clone https://github.com/stevenlio88/peak-bloom-prediction.git
```

2. The model process is documented and runnable in _doc/Cherry_Blossom_Prediction.Rmd_ file.

3. Prerequisite data and scripts can be found in _data/_ and _src/_ folders.

4. The final prediction can be found in the report as well as [here](https://github.com/stevenlio88/peak-bloom-prediction/blob/main/cherry-predictions.csv) in csv format.


## License
----------

![CC-BYNCSA-4](https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png)

Unless otherwise noted, the content in this repository is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-nc-sa/4.0/).

For the data sets in the _data/_ folder, please see [_data/README.md_](data/README.md) for the applicable copyrights and licenses.
