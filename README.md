# guppy_parameter_optimiser
A small bash script that automates sweeping Guppy parameters in an attempt to optimise basecalling rate

## What is this?

Nvidia GPUs greatly accelerate the basecalling rate of Nanopore data. This is great, but not all GPUs are built equally, meaning that sometimes you'll need to tweak specific parameters to either increase performance, or on the other side of the coin, tune down parameters so that a lower spec'd card can work.

As this optimistation process can get time consuming I decided to put together a rough and ready bash script that would allow me to iterate through a given list/string of chunks_per_runner values while also outputting the basecalling metrics as well as GPU usage. I have gotten it into a shape that I’m happy to release a minimal working version on GitHub, it can be found here (link).

At the moment the basic approach is that a user provides the model to optimise (fast, hac, sup) and then a string of chunks_per_runner values (i.e. “160 256 512 786 1024”), as well as a directory of fast5 files and an output location. The script then sequentially runs Guppy using the selected model and processes through the string of values. For each iteration it logs the Guppy information as well GPU usage information.

## How do the tested GPUs compare?

See [here](gpu_basecalling_benchmarks.md) for an extended table of basecalling rates for a range of GPUs. Benchmarks are being contributed by the wider community so make sure to check back often for updates.

## Installation

Just download the script from this repository and run (or clone the repository).

This script depends on several other pieces of software being install prior to it's use:

* nvidia-smi (installed alongside Nvidia drivers)
* CUDA
* Guppy (I was using 6.0.1, but it will work with any recent Guppy version)
* gpustat (https://github.com/wookayin/gpustat)

## Example / "benchmarking" data set

I have provided a small set of example data that I have been using in testing, development and benchmarking. It is hosted via MEGA.co.nz, and can be downloaded manually or via the command line.

Link to the small subset of fast5 data for manual download: ([link](https://mega.nz/file/nAkFHAZR#hFc2ELBxNlXV8MfGaAuuP8nXfoEHBwvk1obnO-LkZTI))

### Install megatools

`megatools` is a cli program that allows terminal-based access to MEGA.co.nz hosted files/data. It's straightforward to install on Debain/Ubuntu systems:

```shell=
sudo apt update
sudo apt install megatools
```

### Download the example data

We can now use `megatools` to download the example fast5 data:

```shell=
megadl https://mega.nz/file/nAkFHAZR#hFc2ELBxNlXV8MfGaAuuP8nXfoEHBwvk1obnO-LkZTI
```

Once downloaded extract the data and you're ready to go.

## Basic usage

```sh
./guppy_parameter_optimiser

Some or all of the parameters are empty

Usage: ./testing2.sh -a model -b chunks_per_runner -c data_dir -d output_dir
	-a Basecalling model to test, one of: fast, hac, sup
	-b A list of chunks_per_runner values to test, example: "256 512 786 1024"
	-c Directory containing a sub set of fast5 files
	-d Directory for results to be written to

```

```sh
./guppy_parameter_optimiser -a fast -b "160 256 512 786 1024" -c example_fast5_data -d results_output
```

## quick look at results

{Very much under development!}

Pull info from Guppy logs:

### FAST model

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

### HAC model

```sh
$ grep -o 'chunks per runner: .*\|samples/s:.*' param_sweep_hac/guppy_hac_*

param_sweep_hac/guppy_hac_256.out:chunks per runner:  256
param_sweep_hac/guppy_hac_256.out:samples/s: 4.49655e+06
param_sweep_hac/guppy_hac_512.out:chunks per runner:  512
param_sweep_hac/guppy_hac_512.out:samples/s: 9.11726e+06
param_sweep_hac/guppy_hac_768.out:chunks per runner:  768
param_sweep_hac/guppy_hac_768.out:samples/s: 1.1925e+07
param_sweep_hac/guppy_hac_1024.out:chunks per runner:  1024
param_sweep_hac/guppy_hac_1024.out:samples/s: 1.38832e+07
param_sweep_hac/guppy_hac_1246.out:chunks per runner:  1246
param_sweep_hac/guppy_hac_1246.out:samples/s: 1.37355e+07
param_sweep_hac/guppy_hac_1500.out:chunks per runner:  1500
param_sweep_hac/guppy_hac_1500.out:samples/s: 1.28892e+07
```

