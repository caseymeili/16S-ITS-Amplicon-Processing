#!/bin/bash

ml sra-toolkit/3.0.2
ml seqtk/040218

# Download data using jwt.cart file obtained from NCBI SRA Run Selector and Bioproject number
prefetch -X  /path/to/file/cart.jwt --option-file /path/to/file/SRR_Acc_List.txt 

# Read each accession number from the file and convert to FASTQ
while IFS= read -r accession; do
    echo "Processing accession: $accession"
    fastq-dump "$accession"
done < accession_list.txt

# Initialize the combined file
combined_file="combined.fasta"
touch "$combined_file"

# Create an array to store the filenames
files_to_merge=()

# Read each accession number from the file and store the corresponding filename
while IFS= read -r accession; do
    # Assuming filenames follow a pattern like "SRR000001.fastq"
    filename="${accession}.fastq"
    
    # Check if the file exists before adding it to the array
    if [ -f "$filename" ]; then
        files_to_merge+=("$filename")
    else
        echo "File $filename not found."
    fi
done < accession_list.txt

# Merge all FASTQ files into a single file
cat "${files_to_merge[@]}" > combined.fastq

echo "Merged files into combined.fastq"

# Convert FASTQ to FASTA
seqtk seq -a combined.fastq > combined.fasta

