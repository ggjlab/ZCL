cd 'pwd'

/tools/bbmap/bbduk2.sh in=H_R1.fastq in2=H_R2.fastq outm=H_R1_linker1.fastq outm2=H_R2_linker1.fastq fliteral=CGACTCACTACAGGG k=15 skipr2=t hdist=3

/tools/bbmap/bbduk2.sh in=H_R1_linker1.fastq in2=H_R2_linker1.fastq outm=H_R1_linker2.fastq outm2=H_R2_linker2.fastq fliteral=TCGGTGACACGATCG k=15 skipr2=t hdist=3 && rm H_R1_linker1.fastq H_R2_linker1.fastq

/tools/bbmap/bbduk2.sh in=H_R1_linker2.fastq in2=H_R2_linker2.fastq outm=H_R1_linker3.fastq outm2=H_R2_linker3.fastq fliteral=TTTTTTTTTTTT k=12 skipr2=t hdist=3 && rm H_R1_linker2.fastq H_R2_linker2.fastq

java -jar /tools/Drop-seq_tools-1.12/3rdParty/picard/picard.jar FastqToSam F1=H_R1_linker3.fastq F2=H_R2_linker3.fastq  O=H.bam QUALITY_FORMAT=Standard SAMPLE_NAME=sample_name && rm H_R1_linker3.fastq H_R2_linker3.fastq

/tools/Drop-seq_tools-1.12/Drop-seq_alignment_DS.sh -g /tools/STAR_Reference_Zebrafish/genomeDir  -r /tools/STAR_Reference_Zebrafish/Danio_rerio.GRCz11.92.fa  -d /tools/Drop-seq_tools-1.12 -o ./ -t ./ -s /tools/STAR-2.5.2a/source/STAR  ./H.bam

