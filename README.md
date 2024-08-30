# PanGen 
Sequence based Pangenome Generator tool for groups of sequences that share types. 
You can run this software in your local machine by following the instructions in the [infa_main.ipynb ](https://github.com/mostume222/inf-test/blob/master/infa_main.ipynb) notebook, the notebook can run in your local machine or in google colab by pressing the "Open in Colab" option.

If you wish to run PanGen in your linux local machine without a notebook, please follow the instructions bellow:

# Step 1. Install dependencies

Install the conda environment in [/inf-test/env/infa.yml ](https://github.com/mostume222/inf-test/blob/master/env/infa.yml) using the following command:

```
conda env create -f /env/infa.yml --quiet
```

If you would like to install the dependencies on your own without the need of using a conda environment, thesse are the core dependencies to make the scripts work:

cd-hit 4.8.1

bowtie2 2.5.4

cutadapt 3.5

python 3.6.13

perl 5.34.0

pip 21.2.2

# Step 2. Input 
PanGen works with 3 inputs:
input_file: 


```
perl /src/merge.pl /input/{input_file} /input/{classes_file} /input/{names_file} /sequences/{input_file}  /data/sci_names.dmp /data/acc_variants.list
```
