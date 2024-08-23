#!/bin/bash 
#$ -N compress 
#$ -o /scratch/oscar_uaem/inf/output/b_comp/
#$ -e /scratch/oscar_uaem/inf/output/b_comp/
#$ -pe thread 2 
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

mkdir ${FOLDER} 

module load programs/bowtie2-2.3.4.3
module load programs/samtools-1.10

echo $DB

perl ${SC}/enumerate.pl $DB ${FOLDER}/database.fasta

echo "started" >  ${FOLDER}/debug_start

grep ">" ${FOLDER}/database.fasta | cut -d">" -f2,4 > ${FOLDER}/taxids_hash.dmp

perl $SC/kmer.pl  $3 $4 ${FOLDER}/database.fasta ${FOLDER}/kmers_w

$SC/remove.sh ${FOLDER}/kmers_w.fasta ${FOLDER}/kmers_clean.fasta


DATA=kmers_clean.fasta

module load programs/cdhit-4.8.1 

cd-hit -i ${FOLDER}/${DATA} -o ${FOLDER}/result -c $1 -n 5 -M 8000 -T 8 -G 1 -g 1 -sc 1 -aS $2 

grep "*" ${FOLDER}/result.clstr | cut -d">" -f2 | cut -d"." -f1  | sort -V > ${FOLDER}/unique.list ## this will output the list of headers 

grep -n "*" ${FOLDER}/result.clstr > ${FOLDER}/domain.list
perl ${SC}/cluster_element_counter.pl ${FOLDER}/domain.list ${FOLDER}/cluster_size

perl ${SC}/uniques_intanglement.pl ${FOLDER}/ $3 $4 #this is the new version 
perl ${SC}/uniques_concatenation.pl ${FOLDER}/


A=$(perl $SC/counter.pl $FOLDER/database.fasta)
B=$(perl $SC/counter.pl $FOLDER/database.compressed)
echo ${FILE} >> ${FOLDER}/andy
echo $A >> ${FOLDER}/andy
echo $B >> ${FOLDER}/andy
perl ${SC}/divider.pl $A $B >> ${FOLDER}/andy
grep -c ">" ${FOLDER}/database.fasta >> ${FOLDER}/andy

## checar bien esta parte con el reporte actual
## porque no se si es corecto
sed -i 's/db_,/0 /g' ${FOLDER}/andy
sed -i 's/db_//g' ${FOLDER}/andy
sed -i 's/,/ /g' ${FOLDER}/andy
sed -i 's/[_.]metalf//g' ${FOLDER}/andy

tr '\n' ' ' < ${FOLDER}/andy > ${FOLDER}/rp
echo '' >> ${FOLDER}/rp

echo "finished" >  ${FOLDER}/debug_finish

