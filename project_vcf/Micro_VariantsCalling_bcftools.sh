#!/bin/bash
'''

Writtedn by Wedad Albalawi
Jan 2023
https://www.youtube.com/watch?v=mKqdfdtv0cI

Title: Variants Calling  for Whole-Genome Sequence of Mycobacterium ulcerans CSURP7741
https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6639603/

Tools theat used:
sickle
bwa 
samtools
bcftools

'''

#Step 1 : create conda enviromant 
cd /Users/wedadalbalawi/project_vcf/
# remove the channels of its exists 
conda config --remove channels bioconda
conda config --remove channels conda-forge
#recreate
conda config --add channels conda-forge
conda config --add channels bioconda

#view channels
conda config --show channels

#-----------------------------------------------#
#Step2: Create the env variable for tools  that use 
conda create -n variants bwa bcftools samtools sickle python biopython

#To install this package run one of the following:
conda install -c bioconda libdeflate
conda install -c "bioconda/label/cf201901" libdeflate

# Activate conda variants by run 
conda activate variants
#Note : you can type the tool name ex.bwa or samtools if it install or not. 

#-----------------------------------------------#
#Step3: 
#Downloud the ref genome
#by runing the below code
python3 ref_dowloud.py 
#Dowloud the fasta file of R1 & R2 from
mkdir data
cd data 
#Read1
wget http://ftp.sra.ebi.ac.uk/vol1/run/ERR333/ERR3335404/P7741_R1.fastq.gz
#Read2 
wget http://ftp.sra.ebi.ac.uk/vol1/run/ERR333/ERR3335404/P7741_R2.fastq.gz
echo " source of data finished downloud!"
#---------------------------------------------------------#
#Step 4: Trim the read 
sickle pe -f P7741_R1.fastq.gz -r P7741_R2.fastq.gz -t sanger -q 20 -l 20 -g -o trimmed_R1.fastq.gz -p trimmed_R2.fastq.gz -s trimmed_S.fastq.gz
echo "Triming finished running!"
#---------------------------------------------------------#
#Step Two alignment with ref genome Agy99

#Step Two alignment with ref genome Agy99
bwa mem -t 8 ~/project_vcf/ref/Agy99.fasta ~/project_vcf/trimmed_R1.fastq.gz ~/project_vcf/trimmed_R2.fastq.gz > ~/project_vcf/output.sam

#Step third confired sam to baw to minamized the size
samtools view -S -b output.sam > ~/project_vcf/output.bam

#Check the size of sam and bam file by run 
    #du -sh output.sam 
    #du -sh output.bam 


# with this the index file will be in the same dir of your reference

bwa index /Users/wedadalbalawi/project_vcf/ref/Agy99.fasta

#bwa mem -t 8 /Users/wedadalbalawi/project_vcf/ref/Agy99.fasta /Users/wedadalbalawi/project_vcf/data/trimmed_R1.fastq.gz /Users/wedadalbalawi/project_vcf/data/trimmed_R2.fastq.gz > /Users/wedadalbalawi/project_vcf/data/output.sam
 #- for the output from first command
bwa mem -t 8 ~/project_vcf/ref/Agy99.fasta ~/project_vcf/data/trimmed_R1.fastq.gz ~/project_vcf/data/trimmed_R2.fastq.gz | samtools sort -o ~/project_vcf/data/output.sorted.bam -
echo "Alignment and sorted finished running!"


#Step Fifth bcftools mpileup 
bcftools mpileup -O b -o ~/project_vcf/data/raw.bcf -f ~/project_vcf/ref/Agy99.fasta --threads 8 -q 20 -Q 30 ~/project_vcf/data/output.sorted.bam 
echo " bcftools mpileup running!"
bcftools call --ploidy 1 -m -v -o ~/project_vcf/data/variants.raw.vcf ~/project_vcf/data/raw.bcf

#Expplation 
#count the variants
#grep -v -c '^#' variants.raw.vcf 
# count snp  & indels varants
bcftools view -v snps ~/project_vcf/data/variants.raw.vcf | grep -v -c '^#' 
bcftools view -v indels  ~/project_vcf/data/variants.raw.vcf | grep -v -c '^#' 
bcftools query -f '%POS\n' ~/project_vcf/data/variants.raw.vcf >~/project_vcf/data/pos.txt
