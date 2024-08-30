# PanGen 
Sequence based Pangenome Generator for groups of sequences that share types. 
You can run this software in your local machine by following the instructions in the [infa_main.ipynb ](https://github.com/mostume222/inf-test/blob/master/infa_main.ipynb) notebook, the notebook can run in your local machine or in google colab by pressing the "Open in Colab" option.

If you wish to run PanGen in your linux local machine without a notebook, please follow the instructions bellow:

# Install dependencies

Install the conda environment in [/inf-test/env/infa.yml ](https://github.com/mostume222/inf-test/blob/master/env/infa.yml) using the following command:

'''
conda env create -f env/infa.yml --quiet
'''

If you would like to install the dependencies on your own, the important ones are:

cd-hit 4.8.1
bowtie2 2.5.4
cutadapt 3.5
python 3.6.13
perl 5.34.0
pip 21.2.2
