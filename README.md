# IncrementalAnalysesEvaluation

This repository contains the set of files used for the evaluation run of the IncrementalAnalysesInfrastructure in conjunction with IncrementalDeadCodeAnalysis. The data gathered through executing the analysis was analyzed using the tools QualityEvaluator and PerformaceEvaluator which can be found [here](https://github.com/moritzfl/IncrementalAnalysesHelpers). Please refer to the Readme-file of that project for instructions on how to evaluate the data with our tools.

In the releases-section of this repository, we also provide downloads for the virtual machine that was used to perform our experiment. 

While the virtual machine is specced according to the powerful server hardware that we used to produce our results, it is worth noting that it will run on significantly lower-end hardware. We successfully tested our setup with 32GB of RAM. The processor speed is relatively unimportant as to whether the experiment will run but keep in mind that executions will be very slow with a low number of CPU cores or a slower clock speed of the CPU.
In case a lower amount of RAM, you will need to adjust the JVM parameters in kernelhaven-evaluation-incremental.sh and kernelhaven-evaluation-reference.sh to accomodate for the RAM available.
In case of a lower amout of CPU cores, you will need to adjust the number of threads used for the analysis accordingly to what your CPU offers.

## Scripts to generate Execution Results

You can use our Linux-VM provided in the release section for executing the experiment. On that machine, you first need to download the scripts and KernelHaven executables for executing the experiment.

There are several options to accomplish this:

```
// for the most current version
wget -O incremental_evaluation.zip https://codeload.github.com/moritzfl/IncrementalAnalysesEvaluation/zip/master
unzip incremental_evaluation.zip

// for a specific version (in this case 4.0, this is the version used for our publication)
wget -O incremental_evaluation.zip https://codeload.github.com/moritzfl/IncrementalAnalysesEvaluation/zip/4.0
unzip incremental_evaluation.zip
```


### reset-and-init.sh
This is used to setup the initial folder structure. If results reside in the folders from previous execution, this script removes them. This script should at least be executed once before calling kernelHaven through ``kernelhaven-evaluation-incremental.sh`` or ``kernelhaven-evaluation-reference.sh``. Otherwise KernelHaven will not run as it is missing directories that the provided configuration files rely on.

### get-evaluation-diffs.sh

While you may choose to run the evaluation based on your own set of diff files (e.g. by using [DiffGenerator](https://github.com/moritzfl/IncrementalAnalysesHelpers) ), you can also download the set of diff files we used by executing this script. This script automatically places the files in the diff-folder. Due to the size of the commit files, we do not version them in git but instead include this script which downloads them from the release section of this repository.

### kernelhaven-evaluation-incremental.sh

Runs the evaluation on all diffs-files in the ``./diff`` folder using the configuration file ``./config/configuration-incremental.properties`` as a template. We do include a few configurations that can be used here in the folder `./config/incremental-configs/`. They names of the files correspond to the naming in our publication.

When KernelHaven is executed it will work with a copy of the configuration file where DIFF_FILE_GENERATED_VALUE is replaced with the name of the current diff-file. It is assumed that the diff-files within the ``./diff/`` folder are ordered chronologically through their filename in alphabetical order.

### kernelhaven-evaluation-reference.sh
Runs the evaluation on all diffs-files in the ``./diff`` folder using the configuration file ``./config/configuration-reference.properties`` as a template.
When KernelHaven is executed it will work with a copy of the configuration file without further modification. Instead the diffs contained in ``./diff/`` will be applied in alphabetical order between each run of KernelHaven so that a complete analysis is done for each commit.
