source $HOME/.bashrc

### this to run this script
## bash run_compress.sh 0.94 0.958 200 50 100000 1,.comp

## this should be 6
FILE=$6
echo ${FILE}

MAIN=$(pwd)/../../
SC=${MAIN}/src/compressor/
IN_FOLDER=${MAIN}/sequences/
OUT_FOLDER=${MAIN}/output_compression
FOLDER=${OUT_FOLDER}/${FILE}/
DB=${IN_FOLDER}/${FILE}

## make output folder
mkdir $FOLDER

## enumerate fasta files
perl ${SC}/enumerate.pl $DB ${FOLDER}/database.fasta

## make taxid hashfile
grep ">" ${FOLDER}/database.fasta | cut -d">" -f2,4 > ${FOLDER}/taxids_hash.dmp

## make kmers
perl $SC/kmer.pl  $3 $4 ${FOLDER}/database.fasta ${FOLDER}/kmers_w

## remove erroneous kmers
cutadapt --max-n 0 -o ${FOLDER}/kmers_clean.fasta ${FOLDER}/kmers_w.fasta 

## make cd-hit compression
DATA=kmers_clean.fasta
cd-hit -i ${FOLDER}/${DATA} -o ${FOLDER}/result -c $1 -n 5 -M 8000 -T 8 -G 1 -g 1 -sc 1 -aS $2

## create the unique list
grep "*" ${FOLDER}/result.clstr | cut -d">" -f2 | cut -d"." -f1  | sort -V > ${FOLDER}/unique.list

## label clusters variant
./label_clusters_variant.sh ${OUT_FOLDER}/ ${FILE}

## concat clusters procedure
grep -n "*" ${FOLDER}/result.clstr > ${FOLDER}/domain.list
perl ${SC}/cluster_element_counter.pl ${FOLDER}/domain.list ${FOLDER}/cluster_size

perl ${SC}/uniques_gitrog.pl ${FOLDER}/ $3 $4
perl ${SC}/uniques_concatenation.pl ${FOLDER}/
echo "end of concatenation pipeline\n"

## make the pangenome file using modify_headers script
NAM=${FILE}
perl ${SC}/modify_headers.pl ${FOLDER}/acce.list ${FOLDER}/database.compressed ${FOLDER}/${NAM}.pan ${FOLDER} ${FOLDER}/../../data/acc_variants.list ${FOLDER}/../../data/sci_names.dmp ${FILE}


## split the pangenome file into .u and .d file 
SEG=${FILE}
echo ${SEG}
grep -A1 "/u/" ${FOLDER}/${NAM}.pan > ${FOLDER}/${NAM}.u
grep -A1 "/d/" ${FOLDER}/${NAM}.pan > ${FOLDER}/${SP}/${NAM}.d
sed -i '/--/d' ${FOLDER}/${NAM}.u
sed -i '/--/d' ${FOLDER}/${NAM}.d

## split the pangenome into folders 
mkdir ${FOLDER}/pangenome_unique




## reports 
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
#sed -i 's/,/ /g' ${FOLDER}/andy
sed -i 's/[_.]metalf//g' ${FOLDER}/andy

tr '\n' ' ' < ${FOLDER}/andy > ${FOLDER}/rp
echo '' >> ${FOLDER}/rp




