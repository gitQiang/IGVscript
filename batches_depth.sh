#!/bin/bash 

### input information
cd /Volumes/TwoT/Desktop/breastcancer/IGV/IGV_2.3.57
BAM="/Volumes/TwoT/Desktop/breastcancer/IGV/IGV_2.3.57/bams_12_4.txt"  ## bam file lists
REF="/Volumes/TwoT/Desktop/tools/references/b37/human_g1k_v37.fasta" ## reference genome
dirhq="/Volumes/TwoT/Desktop/breastcancer/IGV/IGV_2.3.57/depthoutput/" ## output files
FILES=IGVs_single_gene/*IGVs.txt

for TARGET in $FILES;
do
GENE=`basename $TARGET | cut -d '_' -f 1`
./samtools_depth.sh ${BAM} ${REF} ${dirhq} ${TARGET} ${GENE}
done

