# DMS-Seq tutorial

## 1. Clone this repository

`` git clone https://github.com/goodarzilab/DMS-tutorial.git ``

## 2. Install the conda environment

`` conda env create -f DMS-Seq.yml ``

## 3. Clone and Install RNA-Framework (https://rnaframework-docs.readthedocs.io/en/latest/)

To clone:
`` git clone https://github.com/dincarnato/RNAFramework ``

Add rnaframework scripts to path variable (replace `/path/to/RNAFramework` with the absolute path of the cloned RNAFramework folder)

``export PATH=$PATH:/path/to/RNAFramework``


## 4. Trim the reads
Assumes that the fastqs are in the same folder as the `trim_galore.sh` script. If needed copy over the script to the fastq folder

`` bash trim_galore.sh ``

## 5. Create a bowtie reference for the sequence

Prepare a fasta (`.fa` file) for the sequence to align against. For example, the file ``MYC_5UTR.fa``is included in the repository for formatting purposes. Put it in a folder called `/ref` and run the following commands in the `/ref` folder.

Make a bowtie reference for the fasta file using the command ``bowtie2-build -f {reference.fa} {output_ref_name}``
eg: ``bowtie2-build MYC_5utr.fa MYC_5utr``

Now ref folder will contain the `.fa` file, and all the other files associated with the Bowtie reference, with different extensions but containing the suffix `{output_ref_name}`

## 6. Align the trimmed fastqs

Trimmed fastqs should now have the name `*val_{1/2}.fq.gz`. Similar to `trim_galore.sh` script, the `align.sh` script assumes that the trimmed fastqs are in the same folder.

``bash align.sh -ref {/path/to/refFolder/with/Bowtie_suffix}``

eg: `bash align.sh -ref ./ref/MYC_5utr`

## 7. Process bams

Folder should now contain bam files (aligned), now we use rnaframework to count mutations, normalize and predict structure.

To count mutations:
-  ``rf-count -r -m -f ref/reference.fa sample.bam -o output_folder``. To process multiple replicates at once you can use the ``*`` (wildcard character).
-  eg:  ``rf-count -r -m -f ref/MYC_5utr.fa siRBM42*.bam -o output_folder``

To normalize (individual replicates):
- ``rf-norm -t output_folder/*.rc -i output_folder/index.rci -sm 4 -nm 2 -rb AC``

To combine replicates into one xml file:
- ``rf-combine Rep1_norm/{refrence_name}.xml Rep2_norm/{refrence_name}.xml -o {combined_output_folder}``
- eg: ``rf-combine DMS-siRBM42_Rep1_S22.srt_norm/MYC_5UTR.xml DMS-siRBM42_S21.srt_norm/MYC_5UTR.xml -o DMS-siRBM42_combined``

To do structure prediction:
- ``rf-fold -g -ct --folding-method 2 {combined_output_folder}/{file}.xml -dp -o {fold_output}``
- eg: ``rf-fold -g -ct --folding-method 2 DMS-siRBM42_combined/MYC_5UTR.xml -dp -o DMS_siRBM42_fold

The fold command outputs 3 folders, `dotplot` (for IGV visualization), `images` (for linear folding plot) and `structures` for `.ct` file

## 8. Inspect reactivites.

The two ``*.html`` notebook files in the repository contains R and python code to parse through the xml files to read structures and create outputs that qc reactivities between replicates and create visualizations








