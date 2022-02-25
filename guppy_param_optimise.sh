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

for CHUNKS_PER_RUNNER in $chunks_per_runner; do

  # poll gpu ram usage
  #gpustat -i 5 > "${output_dir}"/gpu_usage_"${model}"_"${CHUNKS_PER_RUNNER}"_out.txt &
  nvidia-smi  dmon -i 0 -d 5 -f "${output_dir}"/gpu_usage_"${model}"_"${CHUNKS_PER_RUNNER}"_out.txt &
  nvidiasmidmonpid=$!

  # run guppy with user provided parameters
  guppy_basecaller -c dna_r9.4.1_450bps_"${model}".cfg \
    -i "${data_dir}" \
    -s "${output_dir}" \
    -x 'auto' \
    --chunks_per_runner "${CHUNKS_PER_RUNNER}" > "${output_dir}"/guppy_"${model}"_"${CHUNKS_PER_RUNNER}".out
  
  # report back average GPU mem used
  #mem_total_mb=$(nvidia-smi --query-gpu=memory.total --format=csv -i 0 | tail -1 | awk '{print $1}')
  #AVG=$(tail -n +3 "${output_dir}"/gpu_usage_"${model}"_"${CHUNKS_PER_RUNNER}"_out.txt | awk 'BEGIN{sum=0}{sum=sum+$6}END{print sum/NR}')
  #echo  "${mem_total_mb} * ${AVG}/100.0"  | bc -l

  # kill nvidia-smi dmon
  kill $nvidiasmidmonpid
  #/END
done