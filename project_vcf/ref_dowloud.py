#!/bin/bash
#!/bin/sh

import os 
from Bio import Entrez, SeqIO

paTh ="/Users/wedadalbalawi/Desktop/MHJ_Training/project_vcf/ref/"

isExist= os.path.exists(paTh)
print("the directry is exist",isExist)
if not isExist:
    os.makedirs(paTh)
    isExist= os.path.exists(paTh)
    print("the directry is exist",isExist)
    Entrez.email='bioinfocoach@bioinfo.com'
    handle=Entrez.efetch(db='nuccore',id='CP000325.1', rettype='fasta', retmode='text')
    record=SeqIO.read(handle,'fasta')
    SeqIO.write(record,paTh+'Agy99.fasta','fasta')
    print("The ref genome downloud under :",paTh+'Agy99.fasta' )
    