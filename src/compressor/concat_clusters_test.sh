#!/bin/bash 
#$ -N concat
#$ -o /scratch/oscar_uaem/influenza/output/output_concat/
#$ -e /scratch/oscar_uaem/influenza/output/output_concat/
#$ -pe thread 1
#$ -l h_vmem=8G


source $HOME/.bashrc

FILE=$(cat $6 | head -n $SGE_TASK_ID| tail -1) #file from the list

echo ${FILE}

#MAIN=/scratch/oscar_uaem/influenza/ #main folder
#SC=/scratch/oscar_uaem/influenza/src/lucas_compressor/
#IN_FOLDER=/scratch/oscar_uaem/influenza/output_sequences/
#OUT_FOLDER=/scratch/oscar_uaem/influenza/output_compression/
#FOLDER=${OUT_FOLDER}/$FILE/ #this will be changed for the id of the job array to give name
#DB=${IN_FOLDER}/$FILE #access to the .meta fatabase
#DATA=kmers_clean.fasta


#grep -n "*" ${FOLDER}/result.clstr > ${FOLDER}/domain.list
#perl ${SC}/cluster_element_counter.pl ${FOLDER}/domain.list ${FOLDER}/cluster_size
#perl ${SC}/uniques_intanglement.pl ${FOLDER}/ $3 $4 #this is the new version 
#perl ${SC}/uniques_concatenation.pl ${FOLDER}/
#A=$(perl $SC/counter.pl $FOLDER/database.fasta)
#B=$(perl $SC/counter.pl $FOLDER/database.compressed)
#echo ${FILE} >> ${FOLDER}/andy
#echo $A >> ${FOLDER}/andy
#echo $B >> ${FOLDER}/andy
#perl ${SC}/divider.pl $A $B >> ${FOLDER}/andy
#grep -c ">" ${FOLDER}/database.fasta >> ${FOLDER}/andy

#sed -i 's/db_,/0 /g' ${FOLDER}/andy
#sed -i 's/db_//g' ${FOLDER}/andy
#sed -i 's/,/ /g' ${FOLDER}/andy
#sed -i 's/[_.]metalf//g' ${FOLDER}/andy

#tr '\n' ' ' < ${FOLDER}/andy > ${FOLDER}/rp
#echo '' >> ${FOLDER}/rp

#echo "finished" >  ${FOLDER}/debug_finish

