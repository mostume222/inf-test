#!/bin/bash

FL=$1
SP=$2
FLD=$FL/$SP
SRC=$(pwd)


## make acce list
grep ">" ${FLD}/database.fasta | cut -d ">" -f 2,3 > ${FLD}/acce.list

## make acc_variants list for this current experiemtn
grep ">" ${FLD}/database.fasta | cut -d ">" -f 3,4 > $FLD/acce_variants.family
sed -i "s/>/,/" $FLD/acce_variants.family

## create the coor file
cut -f 2 ${FLD}/result.clstr | cut -d " " -f 2,3 | sed "s/[...]//g" | sed ':a;N;$!ba;s/at/ /g' | sed 's/>//g' | grep "_" > ${FLD}/cluster.coor

## create the cors file
perl ${SRC}/cluster_acc_family.pl ${FLD}/acce.list ${FLD}/cluster.coor ${FLD}/../../data/acc_variants.list


sort -n ${FLD}/cluster.coors > ${FLD}/cluster.coors_sorted

### generate the cluster.coors hash
cut -d":" -f 2,4,5 ${FLD}/cluster.coors > ${FLD}/hash.coors




