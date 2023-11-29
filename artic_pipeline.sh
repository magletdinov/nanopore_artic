#!/bin/bash
#conda activate artic-ncov2019;
export ROOT=${PWD}
export HDF5_PLUGIN_PATH=${PWD}/hdf5/lib/plugin
export OX_PATH=$(realpath $1)

echo $OX_PATH
echo $(basename $1)
cd $OX_PATH
mkdir results
cd results

for i in $OX_PATH/fastq_pass/bar*
do
mkdir $(basename $i)
zcat $i/* > $(basename $i)/$(basename $i).fastq
done

for i in ./*
do
artic minion --no-frameshifts --normalise 300 --threads 32  --scheme-directory ${ROOT}/artic-ncov2019/primer_schemes/ --read-file $(basename $i)/$(basename $i).fastq --fast5-directory $OX_PATH/fast5_pass/$(basename $i) --sequencing-summary $OX_PATH/sequencing_summary*txt nCoV-2019/V1200 $(basename $i)
done

mkdir final
cp *.consensus.fasta final/
rm *.consensus.fasta