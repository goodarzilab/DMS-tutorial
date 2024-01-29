#!/bin/bash

for file in ./*R1_001.fastq.gz; do
	
	f2=${file/R1/R2}
	echo trim_galore --paired $file $f2

	trim_galore --paired $file $f2
	
done
