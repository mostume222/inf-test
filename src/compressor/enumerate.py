import numpy as np
from Bio import SeqIO as io
import array as arr
import sys

#this script removes teh name of a sequence and puts a consecutive number instead

print(" entered the python script ")

filename = sys.argv[1] 
corrected_file = filename+"n"
sequences = io.parse(filename, 'fasta')
i = 0
#print(type(sequences))
#print("the file is:, "+corrected_file)
with open(corrected_file, "w") as obj_file:
	for record in sequences:
		#print(record.id)
		obj_file.write(">"+str(i)+"\n")
		obj_file.write(str(record.seq)+"\n")
		i = i+1

print("en of enumerate script")
		
