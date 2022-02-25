# GPU basecalling benchmarking

## Table of results (updated: 2022-02-25)

| GPU\CPU                  | FAST model | HAC model | SUP model |
|--------------------------|---------------|--------------|--------------|
| A100                  | 3.40604e+07   | 2.68319e+07  | 6.58227e+06  |
| RTX3090 (HG) | 6.09667ee+07 | 1.90738e+07 | 6.24702e+06 |
| RTX3080Ti (eGPU)         | 5.71209e+07   | 1.18229e+07  | 4.52692e+06  |
| Titan RTX (P920)      | 3.17412e+07   | 1.47765e+07  | 4.29710e+06  |
| Telsa V100            | 2.66337e+07   | 1.58095e+07  | 3.91847e+06  |
| RTX6000 (Clara AGX)   | 2.01672e+07   | 1.36405e+07  | 3.42290e+06  |
| Titan V (DE) | 4.71917e+07 | 1.33653e+07 | 3.07009e+06 |
| RTX3070 (HG) | 5.04924e+07 | 1.03841e+07 | 2.95291e+06 |
| RTX3070 (MH) | 4.59143E+07 | 7.32223E+06 | 2.40374E+06 |
| RTX3060 (eGPU)           | 4.70238e+07   | 6.40374e+06  | 2.28163e+06  |
| RTX4000 (mobile)         | 2.88644e+07   | 4.81920e+06  | 1.36953e+06  |
| Jetson Xavier AGX (16GB) | 8.49277e+06   | 1.57560e+06  | 4.40821e+05  |
| Jetson Xavier NX         | 4.36631e+06   | -  | -  |
| Xeon W-10885M (CPU)      | 6.43747e+05   | DNF          | DNF          |

**NOTE:** the above table is currently sorted based on best performance in the Super Accuracy Model (SUP). All results are reported in samples/s and represent Guppy parameters that have been "tuned" (so these aren't the default Guppy parameters).

A massive thank you to all external contributors:

* **David Eccles** (Titan V)
* **Martin Haagmans** (RTX3070)
* **Hasindu Gamaarachchi** (RTX3070, 2x RTX3090)