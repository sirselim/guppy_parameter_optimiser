# GPU basecalling benchmarking

## Table of results (updated: 2022-02-25)

| GPU\CPU                  | FAST model | HAC model | SUP model |
|--------------------------|---------------|--------------|--------------|
| A100                  | 3.40604e+07   | 2.68319e+07  | 6.58227e+06  |
| RTX3090 (HG) | 6.09667e+07 | 1.90738e+07 | 6.24702e+06 |
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

### Table indicating live calling performance

The below table lists results for all the GPUs that we have currently tested. We have used the same example set of ONT fast5 files, Guppy 6.0.1, and where possible have tuned the `chunks_per_runner` parameter to get the most out of HAC and SUP calling based on the GPU being tested. This hopefully gives a more "real world" example of what you can expect from these types of cards in terms of basecalling rate.

The colours represent how well a given GPU and basecalling model will perform for keeping up with live basecalling during a sequencing run.

  * green - easily keeps up in real-time
  * orange - will likely keep up with 80-90% of the run in real-time
  * red - won't get anywhere close, large lag in basecalling

From ONT community forum [link](https://community.nanoporetech.com/protocols/Guppy-protocol/v/gpb_2003_v1_revaa_14dec2018/guppy-software-overview):
> “Keep up” is defined as 80% of the theoretical flow cell output.
e.g. MinION = 4000 kHz x 512 channels x 0.8 = 1.6 M samples/s = 160 kbases/s at 400 b/s

MinION = 4000 kHz x 512 channels x 1.0 = 2,048,000 samples/s $\equiv$ 2.048 M samples/s or 2.048e+06 samples/s

It should be noted that this is based of an ideal situation where a flowcell is sequencing at 100% it's capacity / theoretical output. This is in reality never going to happen, so it's probably safe to assume that a GPU that can perform a minimum of 1.6 M samples/s for a given basecalling model will be able to keep up 'live'.

<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;}
.tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  overflow:hidden;padding:10px 5px;word-break:normal;}
.tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}
.tg .tg-ufg6{background-color:#34cdf9;border-color:inherit;color:#ffffff;font-family:Tahoma, Geneva, sans-serif !important;
  font-size:20px;font-weight:bold;text-align:center;vertical-align:top}
.tg .tg-ysu4{background-color:#67fd9a;border-color:inherit;font-family:Tahoma, Geneva, sans-serif !important;text-align:center;
  vertical-align:top}
.tg .tg-hyiz{background-color:#ffccc9;border-color:inherit;font-family:Tahoma, Geneva, sans-serif !important;text-align:center;
  vertical-align:top}
.tg .tg-00oa{background-color:#34cdf9;border-color:inherit;color:#ffffff;font-size:16px;font-weight:bold;text-align:right;
  vertical-align:top}
.tg .tg-gbfs{background-color:#34cdf9;border-color:inherit;color:#ffffff;font-family:Tahoma, Geneva, sans-serif !important;
  font-size:16px;font-weight:bold;text-align:right;vertical-align:top}
.tg .tg-fi3u{background-color:#ffcc67;border-color:inherit;font-family:Tahoma, Geneva, sans-serif !important;text-align:center;
  vertical-align:top}
.tg .tg-bolj{background-color:#ffccc9;border-color:inherit;text-align:center;vertical-align:top}
</style>
<table class="tg" style="undefined;table-layout: fixed; width: 1022px">
<colgroup>
<col style="width: 231px">
<col style="width: 294px">
<col style="width: 251px">
<col style="width: 246px">
</colgroup>
<thead>
  <tr>
    <th class="tg-ufg6">GPU\CPU</th>
    <th class="tg-ufg6">FAST model+</th>
    <th class="tg-ufg6">HAC model+</th>
    <th class="tg-ufg6">SUP model+</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-gbfs">A100</td>
    <td class="tg-ysu4">3.40604e+07</td>
    <td class="tg-ysu4">2.68319e+07</td>
    <td class="tg-ysu4">6.58227e+06</td>
  </tr>
  <tr>
    <td class="tg-gbfs">RTX3090 (HG)</td>
    <td class="tg-ysu4">6.09667e+07</td>
    <td class="tg-ysu4">1.90738e+07</td>
    <td class="tg-ysu4">6.24702e+06</td>
  </tr>
  <tr>
    <td class="tg-gbfs">RTX3080Ti (eGPU)</td>
    <td class="tg-ysu4">5.71209e+07</td>
    <td class="tg-ysu4">1.18229e+07</td>
    <td class="tg-ysu4">4.52692e+06</td>
  </tr>
  <tr>
    <td class="tg-gbfs">Titan RTX (P920)</td>
    <td class="tg-ysu4">3.17412e+07</td>
    <td class="tg-ysu4">1.47765e+07</td>
    <td class="tg-ysu4">4.29710e+06</td>
  </tr>
  <tr>
    <td class="tg-gbfs">Telsa V100</td>
    <td class="tg-ysu4">2.66337e+07</td>
    <td class="tg-ysu4">1.58095e+07</td>
    <td class="tg-ysu4">3.91847e+06</td>
  </tr>
  <tr>
    <td class="tg-gbfs">RTX6000 (Clara AGX)</td>
    <td class="tg-ysu4">2.01672e+07</td>
    <td class="tg-ysu4">1.36405e+07</td>
    <td class="tg-ysu4">3.42290e+06</td>
  </tr>
  <tr>
    <td class="tg-gbfs">Titan V (DE)</td>
    <td class="tg-ysu4">4.71917e+07</td>
    <td class="tg-ysu4">1.33653e+07</td>
    <td class="tg-ysu4">3.07009e+06</td>
  </tr>
  <tr>
    <td class="tg-gbfs">RTX3070 (HG)</td>
    <td class="tg-ysu4">5.04924e+07</td>
    <td class="tg-ysu4">1.03841e+07</td>
    <td class="tg-ysu4">2.95291e+06</td>
  </tr>
  <tr>
    <td class="tg-gbfs">RTX3070 (MH)</td>
    <td class="tg-ysu4">4.59143E+07</td>
    <td class="tg-ysu4">7.32223E+06</td>
    <td class="tg-ysu4">2.40374E+06</td>
  </tr>
  <tr>
    <td class="tg-gbfs">RTX3060 (eGPU)</td>
    <td class="tg-ysu4">4.70238e+07</td>
    <td class="tg-ysu4">6.40374e+06</td>
    <td class="tg-ysu4">2.28163e+06</td>
  </tr>
  <tr>
    <td class="tg-gbfs">RTX4000 (mobile)</td>
    <td class="tg-ysu4">2.88644e+07</td>
    <td class="tg-ysu4">4.81920e+06</td>
    <td class="tg-fi3u">1.36953e+06</td>
  </tr>
  <tr>
    <td class="tg-gbfs">Jetson Xavier AGX (16GB)</td>
    <td class="tg-ysu4">8.49277e+06</td>
    <td class="tg-fi3u">1.57560e+06</td>
    <td class="tg-hyiz">4.40821e+05</td>
  </tr>
  <tr>
    <td class="tg-gbfs">Jetson Xavier NX</td>
    <td class="tg-ysu4">4.36631e+06</td>
    <td class="tg-hyiz">-</td>
    <td class="tg-hyiz">-</td>
  </tr>
  <tr>
    <td class="tg-gbfs">Jetson TX2 (Mk1C)</td>
    <td class="tg-fi3u">1.60000e+06</td>
    <td class="tg-hyiz">-</td>
    <td class="tg-hyiz">-</td>
  </tr>
  <tr>
    <td class="tg-00oa">Xeon W-10885M (CPU)</td>
    <td class="tg-bolj">6.43747e+05</td>
    <td class="tg-bolj">DNF</td>
    <td class="tg-bolj">DNF</td>
  </tr>
</tbody>
</table>

\* the metric reported is samples/second - where higher is faster basecalling
**DNF** - did not finish (I couldn’t be bothered waiting hours/days for the CPU)