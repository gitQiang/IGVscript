#!/bin/bash 

### input information
INDELS="/Volumes/TwoT/Desktop/breastcancer/IGV/IGV_2.3.57/indels.txt" ## indels files
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
	
	let "START=$VALUE - 25"
	let "END=$VALUE + 25"
	outputf=`echo  $DIR$NAME.$START.$END.$SAMPLE.png`
	#echo $outputf
	if [[ ! -f $outputf ]];then
		if [[ ($kk -gt 1  &&  "$BAMS0" != "$BAMS" ) ||  $kk -eq 1 ]];then
			printf "new\n" >> $SCRF
			printf "genome hg19\n"  >> $SCRF
			printf "load  $BAMS\n" >> $SCRF
			printf "snapshotDirectory $DIR \n" >>  $SCRF	
		fi
	
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
		BAMS0=$BAMS
	fi
done < "$INDELS"
printf "exit \n" >> $SCRF

## run IGV
NUMLINES=$(wc -l < "$SCRF")
if [[ $NUMLINES -gt 10 ]];then
	$IGVR  -g hg19 -b $SCRF	
	rm $SCRF
fi
	