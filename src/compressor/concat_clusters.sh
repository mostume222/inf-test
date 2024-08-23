#!/bin/bash 
#$ -N concat
#$ -o /scratch/oscar_uaem/inf/output/concat/
#$ -e /scratch/oscar_uaem/inf/output/concat/
#$ -pe thread 1
#$ -l h_vmem=8G


### $1 identity percent
### $2 coverage percent
### $3 kmer lenght of reference to compress
### $4 kmer jump of reference to compress
### $5 work folder
### $6 .fasta file where the database is
### $7 number of sequences to analyze *2 , of 1000, its 500 sequences 

#qsub -R y -l h_rt=23:59:59 -t 1-46184 lucas_compressor.sh 0.94 0.958 200 50 99999 /scratch/oscar_uaem/main/no_version/meta_sequence_filter_restricted.list

#qsub -R y -l h_rt=23:59:59 -t 1-2 lucas_compressor.sh 0.94 0.958 200 50 100000 /scratch/oscar_uaem/main/no_version/meta_sequence_filter_restricted.l    ist

source $HOME/.bashrc

FILE=$(cat $6 | head -n $SGE_TASK_ID| tail -1) #file from the list

MAIN=/scratch/oscar_uaem/inf/ #main folder
#SC=${MAIN}/mew/ #here are al the used to work scripts
SC=/scratch/oscar_uaem/inf/src/lucas_compressor/

#IN_FOLDER=${MAIN}/meta_sequence_filter/ #input folder
IN_FOLDER=/scratch/oscar_uaem/inf/output_sequences/

#OUT_FOLDER=${MAIN}/meta_sequence_lucassed/ #output folder
OUT_FOLDER=/scratch/oscar_uaem/inf/output_compression/

FOLDER=${OUT_FOLDER}/$FILE/ #this will be changed for the id of the job array to give name
DB=${IN_FOLDER}/$FILE #access to the .meta fatabase

DATA=kmers_clean.fasta


grep -n "*" ${FOLDER}/result.clstr > ${FOLDER}/domain.list
perl ${SC}/cluster_element_counter.pl ${FOLDER}/domain.list ${FOLDER}/cluster_size

perl ${SC}/uniques_gitrog.pl ${FOLDER}/ $3 $4 #this is the new version 
perl ${SC}/uniques_concatenation.pl ${FOLDER}/ #this is the script that generated the pan sequence 


A=$(perl $SC/counter.pl $FOLDER/database.fasta)
B=$(perl $SC/counter.pl $FOLDER/database.compressed)
echo ${FILE} > ${FOLDER}/andy
echo $A >> ${FOLDER}/andy
echo $B >> ${FOLDER}/andy
perl ${SC}/divider.pl $A $B >> ${FOLDER}/andy
grep -c ">" ${FOLDER}/database.fasta >> ${FOLDER}/andy

sed -i 's/db_,/0 /g' ${FOLDER}/andy
sed -i 's/db_//g' ${FOLDER}/andy
sed -i 's/,/ /g' ${FOLDER}/andy
sed -i 's/[_.]metalf//g' ${FOLDER}/andy

tr '\n' ' ' < ${FOLDER}/andy > ${FOLDER}/rp
echo '' >> ${FOLDER}/rp

echo "finished" >  ${FOLDER}/debug_finish

