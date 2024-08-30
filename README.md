# PanGen 
Sequence based Pangenome Generator tool for groups of sequences that share types. 
You can run this software in your local machine by following the instructions in the [infa_main.ipynb ](https://github.com/mostume222/inf-test/blob/master/infa_main.ipynb) notebook, the notebook can run in your local machine or in google colab by pressing the "Open in Colab" option.

We recomend ALWAYS running PanGen using a jupyter notebook but if you wish to run PanGen in your linux local machine without a notebook, please follow the instructions bellow:

# Step 1. Install dependencies

Install the conda environment in [/inf-test/env/infa.yml ](/env/infa.yml) using the following command:

```
conda env create -f /env/infa.yml --quiet
conda activate infc
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

Input_file: this is a fasta file, the header of this file must contain ONLY the "accession_id" of the given sequences.

Classes_file: this is a tab-separated column text file, first column has to be "accession_id" and second column "class_id", we recommend using taxids as "class_id" but any numerical input can be used. This file seves as a supervised pre-asigned template for classes of each one of the sequences in the Input_file. The generation of unique pieces in the pangenome generation is guided by this class file.

Names_file: this is a tab-separated column text file, first column has to be "class_id" and second column is "class_name", class_name must not contain "/" characters. This file is used to generate the final Pangenome fasta file with recognizable class names. 

You can see and use examples of all three inputs in [/sample_input/](https://github.com/mostume222/inf-test/tree/master/sample_input) 

Once you have the listed 3 input files you MUST put them in the [](/input/ folder).

Then, run the following code:

```
perl /src/merge.pl /input/{input_file} /input/{classes_file} /input/{names_file} /sequences/{input_file}  /data/sci_names.dmp /data/acc_variants.list
```

The former code will create all the neded files to run the compression program.

# Step 3. Run PanGen and find your results

To run the main script and generate pangenomes use:

```
chdmod +x /scr/run_compress.sh
./src/run_compress.sh 0.94 0.958 200 50 100000 {input_file}
```

Your results can be found in the /output/input_file/ folder

