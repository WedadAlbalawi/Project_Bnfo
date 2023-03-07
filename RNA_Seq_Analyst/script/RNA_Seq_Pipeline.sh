#!/bin/bash
SECONDS = 0
'''
Written by Wedad Albalawi
Nov-2022
For training RNA_SEQ Pipeline fastq and generate counts for various analysis
Input : demo.fastq 
Refs: hg38
'''


cd /Users/wedadalbalawi/Desktop/RNA_Seq_Analyst/

#---------------------------STEP 1: Run fastqc---------------
fastqc data/demo.fastq -o data/

#/usr/local/bin/trimmomatic-0.39.jar
#SE - single-end (SE) or paired-end (PE).
#threads- the number of processors 4 mismatch
#TRAILING - cut bases off the end of the a read , if below a threshold quailty 
#phred33 -convert quality score to Phred-33

java -jar /usr/local/bin/trimmomatic-0.39.jar SE -threads 4 data/demo.fastq data/demo_trimmed.fastq TRAILING:10 -phred33
echo "Trimmomatic finished running!"

fastqc data/demo_trimmed.fastq -o data/

#-------------------------Step 2: Run HISAT2-------------------
'''
HISAT2 is a fast and sensitive alignet program for mapping NGS reads both DNA & RNA to Hg 
as well as single genome referance
'''
mkdir HISAT2
#get the genome indicates
wget https://genome-idx.s3.amazonaws.com/hisat/grch38_genome.tar.gz
#Unzip the file
tar -xf grch38_genome.tar.gz

#-q :read fastq files
#--rna-strandness :Specify strand-specific information R
#-x :the basename of the index for the reference genome. 
#-U : unpair

hisat2 -q --rna-strandness R -x HISAT2/grch38/genome -U data/demo_trimmed.fastq | samtools sort -o HISAT2/demo_trimmed.bam
echo "Hisatq finished running!"

#-----------------------Step 3 : Run featureCounts - Quantifiation------------
#get gtf 
wget https://ftp.ensembl.org/pub/release-108/gtf/homo_sapiens/Homo_sapiens.GRCh38.108.gtf.gz
gunzip Homo_sapiens.GRCh38.108.gtf.gz

#-s:specifies strand-specific read counting
#2 : reversely stranded reads
#-a: the genome annotation
#-o : output file


featureCounts -S 2 -a Homo_sapiens.GRCh38.108.gtf -o quants/demo_featureCounts.txt HISAT2/demo_trimmed.bam
echo "featureCounts finished running!"


duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
