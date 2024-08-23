#!/bin/bash
#$ -N makef 
#$ -o /scratch/oscar_uaem/main/output

# to run this script run the following program
#qsub prep/enumerate.sh /scratch/oscar_uaem/main/data/hiv.fastaz
#qsub /scratch/oscar_uaem/main/prep/enumerate.sh /scratch/oscar_uaem/main/data/hiv.fastaz



source /share/apps/External/Miniconda3-4.7.10/bin/activate

conda activate "mhs" 

echo $1

python /scratch/oscar_uaem/lu/src/lucas_compressor/enumerate.py $1

# to test 500 sequences
#head -n 1000 $1n > /scratch/oscar_uaem/main/sandbox/database.fasta
head -n $3 $1n > $2 


