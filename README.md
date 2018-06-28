# IncrementalAnalysesEvaluation

This repository contains the set of files used for the evaluation run of the IncrementalAnalysesInfrastructure in conjunction with IncrementalDeadCodeAnalysis. The data gathered through executing the analysis was analyzed using the tools QualityEvaluator and PerformaceEvaluator which can be found [here](https://github.com/moritzfl/IncrementalAnalysesHelpers)

## Scripts to generate Execution Results

### reset-and-init.sh

this creates all required folders and removes files from any previous executions of KernelHaven. This script should at least be executed once before calling kernelHaven through ``kernelhaven-evaluation-incremental.sh`` or ``kernelhaven-evaluation-reference.sh``

### unpack-diffs.sh

while you may choose to run the evaluation based on your own set of diff files (e.g. by using [DiffGenerator](https://github.com/moritzfl/IncrementalAnalysesHelpers) ), we include a set of diff files. You can unpack them into the diffs-folder by using this script.
Those diff files represent the commits to the main branch of the linux kernel from commit ``4fbd8d194f06c8a3fd2af1ce560ddb31f7ec8323 Linux 4.15-rc1`` to commit ``d8a5b80568a9cb66810e75b182018e9edb68e8ff Linux 4.15`` of the [linux-kernel](https://github.com/torvalds/linux).

*Note: for the evaluation performed by us, ``00129-git.diff`` was disabled by renaming it to ``00129-git.diff.disabled`` after unpacking as it represents no changes.*"

### kernelhaven-evaluation-incremental.sh

Runs the evaluation on all diffs-files in the ``./diff`` folder using the configuration file ``./config/configuration-incremental.properties`` as a template.
When KernelHaven is executed it will work with a copy of the configuration file where DIFF_FILE_GENERATED_VALUE is replaced with the name of the current diff-file. It is assumed that the diff-files within the ``./diff/`` are ordered chronologically through their filename in alphabetical order.

### kernelhaven-evaluation-reference.sh
Runs the evaluation on all diffs-files in the ``./diff`` folder using the configuration file ``./config/configuration-reference.properties`` as a template.
When KernelHaven is executed it will work with a copy of the configuration file without further modification. Instead the diffs contained in ``./diff/`` will be applied in alphabetical order between each run of KernelHaven so that a complete analysis is done for each commit.
