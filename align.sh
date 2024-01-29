#!/bin/bash

while getopts ":r:" opt; do
  case $opt in
    r)
      ref="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [ -z "$ref" ]; then
  echo "Please provide a bowtie reference directory using the --ref flag."
  exit 1
fi

for file in ./*R1_001_val_1.fq.gz; do
  f2=${file/R1_001_val_1/R2_001_val_2}
  out="$(echo "$file" | cut -d'_' -f1-2)"
  echo "bowtie2 --local --no-unal --no-discordant --no-mixed -X 1000 -L 12 -p 8 -x $ref -1 $file -2 $f2 | samtools view -Sb - | samtools sort -@ 8 -m 1G -o ${out}.srt.bam -"
  bowtie2 --local --no-unal --no-discordant --no-mixed -X 1000 -L 12 -p 8 -x $ref -1 $file -2 $f2 | samtools view -Sb - | samtools sort -@ 8 -m 1G -o ${out}.srt.bam -
done
