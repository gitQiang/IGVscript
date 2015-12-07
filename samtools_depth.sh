#!/bin/bash

BAM=$1
REF=$2
dirhq=$3
TARGET=$4
GENE=$5

LEN=10 ## length of intervals
k=1
BAMS=""
while read line
do		
	SAMPLE=`echo $line | cut -d  ' ' -f 3`
	ONEBAM=`grep $SAMPLE $BAM`
	
	if [[ "$ONEBAM" != "" ]]; then
		BAMS=`echo $BAMS $ONEBAM`
	fi
			
	if [[ $k -eq 1 ]]; then
		CHR=`echo $line | cut -d ' ' -f 1`
		POSITION=`echo $line | cut -d ' ' -f 2`
		let "START=$POSITION - $LEN"
		let "END=$POSITION + $LEN"
		Tg=`echo $CHR:$START-$END`
	fi
	
	let k+=1
done <"$TARGET"

## samtools depth in cases and controls for one variant
samtools mpileup -ugf $REF -r $Tg -t DP,DV,DPR,INFO/DPR,DP4,SP $BAMS | bcftools view  ->  $dirhq$GENE-$Tg.vcf

## vcftools depth in all sites and samples
vcftools --vcf $dirhq$GENE-$Tg.vcf --geno-depth --out $dirhq$GENE-$Tg


: <<'END'
## format PL:DP:DV:SP:DP4:DPR
N=2 ## extract DP
TMPF=`echo $dirhq$GENE-$Tg.depth.txt`
touch $TMPF

k=1
while read line
do
	if [[ ( "${line:0:2}" != "##" ) && ( $k -eq 1 ) ]]; then
		printf "$line \n" >> $TMPF
		let k+=1
	elif [[ $k -gt 1 ]]; then
		STRS=(${line//'\t'/ })
		i=1
		newline=""
		for ONE in "${!STRS[@]}";
 		do	
			if [[ $i -gt 9 ]];then
				DP=`echo ${STRS[ONE]} | cut -d ':' -f $N`
				newline=`echo $newline	$DP`
			else
				newline=`echo $newline	${STRS[ONE]}`
			fi
			let i+=1
		done
		printf "$newline \n" >> $TMPF
	fi
done < "$dirhq$GENE-$Tg.vcf"
END
