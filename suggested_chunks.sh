#!/usr/bin/bash 

# read argument
gpu_ram_mb=$1
# echo it back
if [ ! ${gpu_ram_mb} ]; then
    echo "Give me an argument that is the MB (megabytes) of RAM in your GPU"
    exit
else
    echo "You specified that your card has ${gpu_ram_mb} MB (megabytes) of RAM."
fi

# constants in guppy "protocol"
fast_mode_constant=1200
hac_mode_constant=3300
sup_mode_constant=12600

echo "According to the guppy 'protocol', they have a formula for calculating \
your approximate chunks_per_runner to try. So using that..."
echo ""

echo "I recommend for 'fast' mode these chunks_per_runner sizes of :"
max=$(( ${gpu_ram_mb} * 1000000 / 2000 / ${fast_mode_constant} ))
for i in $(seq 1 12); do
    echo -n " $((${max}/$i/2*2))"   # so BASH math rounds down, so we divide and
                                    # multiply to get to the recommended even #
done
echo ""

echo "I recommend for 'hac' mode these chunks_per_runner sizes of :"
max=$(( ${gpu_ram_mb} * 1000000 / 2000 / ${hac_mode_constant} ))
for i in $(seq 1 12); do
    echo -n " $((${max}/$i/2*2))"
done
echo ""

echo "I recommend for 'sup' mode these chunks_per_runner sizes of :"
max=$(( ${gpu_ram_mb} * 1000000 / 2000 / ${sup_mode_constant} ))
for i in $(seq 1 12); do
    echo -n " $((${max}/$i/2*2))"
done
echo ""

#1200
#3300
#12600
