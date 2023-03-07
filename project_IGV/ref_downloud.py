#!/bin/bash
#!/bin/sh

'''
to solve 
[SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed

'''
import ssl
ssl._create_default_https_context = ssl._create_unverified_context

import os 
from Bio import Entrez, SeqIO

paTh ="/Users/wedadalbalawi/Desktop/MHJ_Training/project_IGV/ref/"

isExist= os.path.exists(paTh)
print("the directry is exist",isExist)
if not isExist:
    os.makedirs(paTh)
    isExist= os.path.exists(paTh)
    print("the directry is exist",isExist)
    Entrez.email='bioinfocoach@bioinfo.com'
    handle=Entrez.efetch(db='nucleotide',id='NC_012967', rettype='fasta', retmode='text')
    record=SeqIO.read(handle,'fasta')
    SeqIO.write(record,paTh+'REL606.fasta','fasta')
    print("The ref genome downloud under :",paTh+'REL606.fasta' )