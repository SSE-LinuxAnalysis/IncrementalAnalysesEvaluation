# IncrementalAnalysesEvaluation

This repository contains the set of files used for the evaluation run of the IncrementalAnalysesInfrastructure in conjunction with IncrementalDeadCodeAnalysis. The data gathered through executing the analysis was analyzed using the tools QualityEvaluator and PerformaceEvaluator which can be found [here](https://github.com/moritzfl/IncrementalAnalysesHelpers)

## Scripts to generate Execution Results

First you need to download the scripts on your machine.
There are several options to accomplish this:

```
git clone https://github.com/moritzfl/IncrementalAnalysesEvaluation.git
```

```
wget -O incremental_evaluation.zip https://codeload.github.com/moritzfl/IncrementalAnalysesEvaluation/zip/master
unzip incremental_evaluation.zip
```

### reset-and-init.sh

this creates all required folders and removes files from any previous executions of KernelHaven. This script should at least be executed once before calling kernelHaven through ``kernelhaven-evaluation-incremental.sh`` or ``kernelhaven-evaluation-reference.sh``

### get-evaluation-diffs.sh

While you may choose to run the evaluation based on your own set of diff files (e.g. by using [DiffGenerator](https://github.com/moritzfl/IncrementalAnalysesHelpers) ), you can also download the set of diff files we used by executing this script. This script automatically places the files in the diff-folder. All diff-files within that folders will be used for execution through ``kernelhaven-evaluation-incremental.sh`` or ``kernelhaven-evaluation-incremental``.
Those diff files represent the commits to the main branch of the [linux-kernel](https://github.com/torvalds/linux) from commit ``0c744ea4f77d72b3dcebb7a8f2684633ec79be88`` to commit ``866a30efdcb63a330b480600d0b501547f9a5a58``. This covers the time from January to September 2017.

### kernelhaven-evaluation-incremental.sh

Runs the evaluation on all diffs-files in the ``./diff`` folder using the configuration file ``./config/configuration-incremental.properties`` as a template.
When KernelHaven is executed it will work with a copy of the configuration file where DIFF_FILE_GENERATED_VALUE is replaced with the name of the current diff-file. It is assumed that the diff-files within the ``./diff/`` folder are ordered chronologically through their filename in alphabetical order.

### kernelhaven-evaluation-reference.sh
Runs the evaluation on all diffs-files in the ``./diff`` folder using the configuration file ``./config/configuration-reference.properties`` as a template.
When KernelHaven is executed it will work with a copy of the configuration file without further modification. Instead the diffs contained in ``./diff/`` will be applied in alphabetical order between each run of KernelHaven so that a complete analysis is done for each commit.
