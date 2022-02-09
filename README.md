# guppy_parameter_optimiser
A small bash script that automates sweeping Guppy parameters in an attempt to optimise basecalling rate

## Basic usage

```sh
./guppy_parameter_optimiser

Some or all of the parameters are empty

Usage: ./testing2.sh -a model -b chunks_per_runner -c data_dir -d output_dir
	-a Basecalling model to test, one of: fast, hac, sup
	-b A list of chunks_per_runner values, example: "256 512 786 1024"
	-c Directory containing a sub set of fast5 files
	-d Directory for results to be written to

```

```sh
./guppy_parameter_optimiser -a fast -b "160 256 512 786 1024" -c example_fast5_data -d results_output
```

## quick look at results

{Very much under development!}

Pull info from Guppy logs:

```sh
grep -o 'chunks per runner: .*\|samples/s:.*' param_sweep_test/guppy_fast_*

param_sweep_test/guppy_fast_160.out:chunks per runner:  160
param_sweep_test/guppy_fast_160.out:samples/s: 3.30911e+07
param_sweep_test/guppy_fast_256.out:chunks per runner:  256
param_sweep_test/guppy_fast_256.out:samples/s: 3.30645e+07
param_sweep_test/guppy_fast_512.out:chunks per runner:  512
param_sweep_test/guppy_fast_512.out:samples/s: 3.33125e+07
param_sweep_test/guppy_fast_768.out:chunks per runner:  768
param_sweep_test/guppy_fast_768.out:samples/s: 3.36026e+07
param_sweep_test/guppy_fast_1024.out:chunks per runner:  1024
param_sweep_test/guppy_fast_1024.out:samples/s: 3.3017e+07
```

Pull info from gpustat logs:

```sh
for i in param_sweep_test/gpu_usage_fast_*_out.txt; do 
  awk '{print $10}' $i | sed '/^$/d' | datamash mean 1; 
done

1650.375
2013.375
2513.875
2299.375
2762.375
```
