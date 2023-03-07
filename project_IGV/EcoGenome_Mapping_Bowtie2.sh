#!/bin/bash
#!/bin/sh


# -----------Step1-------------------
#get the datasent from https://www.ebi.ac.uk/ena/browser/view/SRX012992?show=reads
mkdir mapping 
cd mapping
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR030/SRR030257/SRR030257_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR030/SRR030257/SRR030257_2.fastq.gz
echo " source of data finished downloud!"
# -----------Step2 -------------------
#get the ref of Escherichia coli 
python3 ref_downloud.py
echo " source of referance E.coli finished downloud!"
# -----------Step3 -------------------

#Build the index of ref
mkdir index
bowtie2-build ref/REL606.fasta index/REL
# -----------Step4 -------------------
mkdir mapped 
#bowtie2 -x index/REL -1 mapping/SRR030257_1.fastq.gz -2 mapping/SRR030257_2.fastq.gz -S mapped/REL.sam --threads 8 
echo "Mapping finished downloud!"
# -----------Step5 -------------------
#Converted to bam file "less size"
samtools view -b -o mapped/REL.bam mapped/REL.sam
echo "Converted the sam file to bam file finished!"
# -----------Step6 -------------------
#Statistic 
#samtools flagstat mapped/REL.bam 
echo "flagstat results Done"

#Sorted the bam file by samtools cordanated
#samtools sort -@ 8 -o mapped/REL.sorted.bam mapped/REL.bam
echo "sorted results Done"
# -----------Step7 -------------------
#Index the bam file 
#samtools index mapped/REL.sorted.bam 
#Index the ref by samtools
samtools faidx ref/REL606.fasta 
# -----------Step 8 -------------------
#Finally we can use IGV Tool to visualize the bam file 
#https://software.broadinstitute.org/software/igv/
