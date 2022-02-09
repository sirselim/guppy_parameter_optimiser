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