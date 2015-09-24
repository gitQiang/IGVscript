#!/bin/bash 

### input information
BAMFILE="/Volumes/BigData/WENDY/BreastCancer/Regeneron/bams/" ## bam file directory
INDELS="/Volumes/TwoT/Desktop/breastcancer/IGV/IGV_2.3.57/allcheck/igvfile.txt" ## indels files
BAM="/Volumes/TwoT/Desktop/breastcancer/IGV/IGV_2.3.57/bams_9_24.txt" ## bam files
DIR="/Volumes/TwoT/Desktop/breastcancer/IGV/IGV_2.3.57/SnapshotCheck/" ## figure output folder

###=========================================================
IGVR="/Volumes/TwoT/Desktop/breastcancer/IGV/IGV_2.3.57/igv.sh" ## igv 
SCRF="igv_batch_script_v4.txt" 

touch $SCRF
printf "#! /bin/bash\n" >> $SCRF

kk=1
BAMS0="OO"
while read line
do
	## Step 1: write the tmp IGV igv_batch_script.txt
	
	##printf "$line"
	NAME=`echo $line | cut -d ' ' -f 1`
	VALUE=`echo $line | cut -d ' ' -f 2`
	SAMPLE=`echo $line | cut -d  ' ' -f 3`
	SAMS=`echo $SAMPLE|tr "," "\n"`
	##echo $line
	
	i=1
	for ONE in $SAMS;
 	do	
 		ONEBAM=`grep $ONE $BAM`
		if [[ "$ONEBAM" != "" ]]
		then
			if [[ $i -gt 1 ]]; then
				BAMS=`echo $BAMS,$ONEBAM`
			else
				BAMS=`echo $ONEBAM`
			fi
		fi
		let i+=1	
	done
	#echo $i
	
	
	if [[ $kk -gt 1 ]];then
		if [[  "$BAMS0" != "$BAMS" ]];then
			printf "new\n" >> $SCRF
			printf "genome hg19\n"  >> $SCRF
			printf "load  $BAMS\n" >> $SCRF
			printf "snapshotDirectory $DIR \n" >>  $SCRF
		fi
	else
			printf "new\n" >> $SCRF
			printf "genome hg19\n"  >> $SCRF
			printf "load  $BAMS\n" >> $SCRF
			printf "snapshotDirectory $DIR \n" >>  $SCRF	
	fi
	
	BAMS0=$BAMS
	
	let "START=$VALUE - 25"
	let "END=$VALUE + 25"
	printf "goto chr$NAME:$START-$END \n" >> $SCRF
	printf "sort position \n" >> $SCRF
	#printf "expand \n" >> $SCRF	
	printf "collapse \n" >> $SCRF
	#printf "squish \n" >> $SCRF
	#printf "viewaspairs \n" >> $SCRF
	printf "maxPanelHeight 2000 \n" >> $SCRF
	printf "snapshot $NAME.$START.$END.$SAMPLE.png \n" >> $SCRF
	printf "\n" >> $SCRF
	
	let kk+=1
done < "$INDELS"

printf "exit \n" >> $SCRF
## run IGV
$IGVR  -g hg19 -b $SCRF	
rm $SCRF	
	