#!/bin/bash

for file in *.fastq.gz.fastp.fastq.gz; do
    mv "$file" "${file%.fastq.gz.fastp.fastq.gz}.fastp.fastq.gz"
done