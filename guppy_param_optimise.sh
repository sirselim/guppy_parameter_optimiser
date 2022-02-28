#!/bin/bash
## guppy_param_optimise - a small tool to aid in Guppy parameter selection
## Author: Miles Benton
## Created: 2022/02/09 15:12:34
## Last modified: 2022/02/09 17:58:35

helpFunction()
{
    echo ""
    echo "Usage: $0 -a model -b chunks_per_runner -c data_dir -d output_dir"
    echo -e "\t-a Basecalling model to test, one of: fast, hac, sup"
    echo -e "\t-b A list of chunks_per_runner values to test, example: \"256 512 786 1024\""
    echo -e "\t-c Directory containing a sub set of fast5 files"
    echo -e "\t-d Directory for results to be written to"
    exit 1 # Exit script after printing help
}

while getopts "a:b:c:d:" opt
do
    case "$opt" in
        a ) model="$OPTARG" ;;
        b ) chunks_per_runner="$OPTARG" ;;
        c ) data_dir="$OPTARG" ;;
        d ) output_dir="$OPTARG" ;;
        ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
    esac
done

# Print helpFunction in case parameters are empty
if [ -z "$model" ] || [ -z "$chunks_per_runner" ] || [ -z "$data_dir" ] || [ -z "${output_dir}" ]
then
    echo "Some or all of the parameters are empty";
    helpFunction
fi

# Begin script in case all parameters are correct
echo "Slected $model as the basecalling model"
echo "Sweeping these vlaues of chunks_per_runner: $chunks_per_runner"
echo "Location of fast5 files: $data_dir"
echo "Output directory: $output_dir"

# create output_dir if it doesn't exist
mkdir -p "${output_dir}"

for chunksperrunner in $chunks_per_runner; do
    
    # poll gpu ram usage
    nvidia-smi  dmon -i 0 -d 5 -f "${output_dir}"/gpu_usage_"${model}"_"${chunksperrunner}"_out.txt &
    nvidiasmidmonpid=$!
    
    # run guppy with user provided parameters
    guppy_basecaller -c dna_r9.4.1_450bps_"${model}".cfg \
    -i "${data_dir}" \
    -s "${output_dir}" \
    -x 'auto' \
    --chunks_per_runner "${chunksperrunner}" > "${output_dir}"/guppy_"${model}"_"${chunksperrunner}".out
    
    # kill nvidia-smi dmon
    kill $nvidiasmidmonpid

    # report back average GPU mem used
    mem_total_mb=$(nvidia-smi --query-gpu=memory.total --format=csv -i 0 | tail -1 | awk '{print $1}')
    avgmem=$(sed -n 'n;p' "${output_dir}"/gpu_usage_"${model}"_"${chunksperrunner}"_out.txt | awk 'BEGIN{sum=0}{sum=sum+$6}END{print sum/NR}')
    gpumemused=$(echo "($avgmem * 1000)" | bc -l)
    mem_used_percent=$(echo "scale=2; ( $gpumemused / $mem_total_mb ) * 100" | bc -l)
    echo "this iteration used ${mem_used_percent}% GPU RAM"
    
    # create variables to output
    gpu=$(nvidia-smi -q | grep 'Product Name' | sed -e 's/.*: //g')
    gpumem=$(nvidia-smi --query-gpu=memory.total --format=csv -i 0 | tail -1 | awk '{print $1}')
    gpudriver=$(nvidia-smi -q | grep 'Driver Version' | sed -e 's/.*: //g')
    cudaversion=$(nvidia-smi -q | grep 'CUDA Version' | sed -e 's/.*: //g')
    guppyversion=$(guppy_basecaller --version | grep -oP 'Version [0-9.a-zA-Z+]{0,20}' | sed -e 's/Version //g')
    chunksize=$(grep 'chunk size:' "${output_dir}"/guppy_"${model}"_"${chunksperrunner}".out | sed -e 's/.*://g' -e 's/ //g')
    numbasecallers=$(grep 'num basecallers:' "${output_dir}"/guppy_"${model}"_"${chunksperrunner}".out | sed -e 's/.*://g' -e 's/ //g')
    runnersperdevice=$(grep 'runners per device:' "${output_dir}"/guppy_"${model}"_"${chunksperrunner}".out | sed -e 's/.*://g' -e 's/ //g')
    samplespersecond=$(grep 'samples/s:' "${output_dir}"/guppy_"${model}"_"${chunksperrunner}".out | sed -e 's/.*://g' -e 's/ //g')
    
    # create csv output
    csvout=$(paste <(echo "guppy_paramopt_") <(echo "$model") <(echo _"$chunksperrunner") <(echo ".csv") --delimiters '')
    # create output file or delete contents if it exists
    if [ -f "$csvout" ]; then
        echo "csv file found... deleting its contents!"
        cat /dev/null > "$csvout"
    else
        echo "output csv file created"
        > "$csvout"
    fi
    
    # add header to csv file (i.e. write one line)
    header=$(paste  <(echo "gpu") \
        <(echo "gpu_memory") \
        <(echo "gpu_memory_used") \
        <(echo "gpu_driver_version") \
        <(echo "cuda_version") \
        <(echo "guppy_version") \
        <(echo "guppy_model") \
        <(echo "chunk_size") \
        <(echo "chunks_per_runner") \
        <(echo "num_basecallers") \
        <(echo "runners_per_device") \
        <(echo "samples_per_second") \
    --delimiters ',')
    echo "$header" >> "$output_dir"/"$csvout"
    
    # output to file
    dataset=$(paste <(echo "$gpu") \
        <(echo "$gpumem") \
        <(echo "$gpumemused") \
        <(echo "$gpudriver") \
        <(echo "$cudaversion") \
        <(echo "$guppyversion") \
        <(echo "$model") \
        <(echo "$chunksize") \
        <(echo "$chunksperrunner") \
        <(echo "$numbasecallers") \
        <(echo "$runnersperdevice") \
        <(echo "$samplespersecond") \
    --delimiters ',')
    echo "$dataset" >> "$output_dir"/"$csvout"
    
    #/END
done