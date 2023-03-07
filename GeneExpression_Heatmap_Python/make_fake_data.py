import numpy as np 
import pandas as pd

data = np.random.randint(20,size=(100,20))
data[:,0:10] = data[:,0:10]*3
#print(data)

sample_labels = []

for num in range(1,11):
    sample_labels.append("Tumor_sample_TPM_"+str(num))
for num in range(1,11):
    sample_labels.append("Normal_sample_TPM_"+str(num))



#print(np.__path__)
#print(len(sample_labels))

gene_labels = []

for num in range(1,101):
    gene_labels.append("Gene"+str(num))

#print(data.shape)


df= pd.DataFrame(data, columns=sample_labels,index=gene_labels)
df.to_csv("fake_gene_expression_data.csv")