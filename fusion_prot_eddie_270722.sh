##!/bin/bash



###################
###################
## TO RUN THE SCRIPT: echo "./fusion_prot_eddie.sh" | qsub -cwd -V -l h_vmem=64G -l h_rt=24:00:00
###################
###################

echo -e 'STAR-FUSION pipeline for our needs:\n

I: modules will be loaded\n
II: path will be selected\n
III: STAR-FUSION will be run\n'

module load igmm/apps/STAR/2.7.8a
module load igmm/apps/STARFusion/1.10.0 

#make new dir
newdir=star_fusion_$(date +"%M__%H_%d_%m_%Y")

mkdir $newdir

#move to new dir
cd $newdir


#inform usr about dir
path=$(pwd)

echo -e "###\n###\n###\n
#####LIBRARY 

You are in this directory:'$path'\n"

echo -e 'Input the directory your GRCh37_gencode_v19_CTAT_lib_Mar012021.plug-n-play/ctat_genome_lib_build_dir/ is located in\n
for dev:/exports/eddie/scratch/v1nbrude/fusion_prot/genome/GRCh37_gencode_v19_CTAT_lib_Mar012021.plug-n-play/ctat_genome_lib_build_dir/'

answer_ctat_genome_lib=/exports/eddie/scratch/v1nbrude/fusion_prot/genome/GRCh37_gencode_v19_CTAT_lib_Mar012021.plug-n-play/ctat_genome_lib_build_dir/

echo -e $answer_ctat_genome_lib

######TRANSCRIPTOME

echo -e 'Input the directory your transcriptomes are located in'

answer_transcriptome_path=/exports/eddie/scratch/v1nbrude/fusion_prot/mv411_all
echo -e 'The following files are copies in the current directory:'
ls $answer_transcriptome_path/*fastq.gz

echo -e '###############WORKS FOR .gz fils ONLY##############'

cp $answer_transcriptome_path/*fastq.gz .

#create file with all files analysed 

ls > analysed_files_list.txt

echo -e 'START\n'

filenames=$(for fastq in $path/*fastq.gz; do
        var=${fastq%??????????}
        echo "$var"
done | sort -u)

echo -e '#\n#\n#\n'
for name in $filenames; do
        echo -e "Current file pair: '$name'"

echo -e 'Unzipping files'

gunzip ${name}1.fastq.gz ${name}2.fastq.gz


STAR-Fusion --left_fq ${name}1.fastq \
--right_fq ${name}2.fastq \
--genome_lib_dir $answer_ctat_genome_lib

echo -e 'deleting fastq files'
rm -fr ${name}1.fastq ${name}2.fastq
done






