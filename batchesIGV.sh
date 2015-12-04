#!/bin/bash 

### input information

BAM="/Volumes/TwoT/Desktop/breastcancer/IGV/IGV_2.3.57/bams_9_24.txt" 
FILES=IGVs_single_gene/*IGVs.txt
#echo $FILES

for INDEL in $FILES;
do
GENE=`basename $INDEL | cut -d '_' -f 1`
#echo $GENE
DIR=`echo 'IGVs_single_gene/'$GENE'IGVs'`
#echo $DIR
./onesetIGV.sh ${INDEL} ${BAM} ${DIR}
done

