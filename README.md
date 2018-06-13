# IncrementalAnalysesEvaluation

This repository contains the set of files used for the evaluation run of the IncrementalAnalysesInfrastructure in conjunction with IncrementalDeadCodeAnalysis.

## Scripts to generate Execution Results

### reset-and-init.sh

this creates all required folders and removes files from any previous executions of KernelHaven. This script should at least be executed once before calling kernelHaven throug ``kernelhaven-evaluation-incremental.sh`` or ``kernelhaven-evaluation-reference.sh``

### unpack-diffs.sh

while you may choose to run the evaluation based on your own set of diff files, some diff files come included. You can unpack them into the diffs-folder by using this script.
Those diff files represent the commits to the main branch of the linux kernel from commit ``4fbd8d194f06c8a3fd2af1ce560ddb31f7ec8323 Linux 4.15-rc1`` to commit ``d8a5b80568a9cb66810e75b182018e9edb68e8ff Linux 4.15`` of the [linux-kernel](https://github.com/torvalds/linux).

*Note: for the evaluation performed by us, ``00129-git.diff`` was disabled by renaming it to ``00129-git.diff.disabled`` after unpacking as it represents no changes.*"

### kernelhaven-evaluation-incremental.sh

Runs the evaluation on all diffs-files in the ``./diff`` folder using the configuration file ``./config/configuration-incremental.properties`` as a template.
When KernelHaven is executed it will work with a copy of the configuration file where DIFF_FILE_GENERATED_VALUE is replaced with the name of the current diff-file. It is assumed that the diff-files within the ``./diff/`` are ordered chronologically through their filename in alphabetical order.

### kernelhaven-evaluation-reference.sh
Runs the evaluation on all diffs-files in the ``./diff`` folder using the configuration file ``./config/configuration-incremental.properties`` as a template.
When KernelHaven is executed it will work with a copy of the configuration file without further modification. Instead the diffs contained in ``./diff/`` will be applied in alphabetical order between each run of KernelHaven so that a complete analysis is done for each commit.

## Evaluation of the Results

Once you generated the results for both your reference and your incremental execution, 

### QualityEvaluator

The concrete implementation of QualityEvaluator can be found [here](https://github.com/KernelHaven/IncrementalAnalysesInfrastructure/blob/master/src/net/ssehub/kernel_haven/incremental/evaluation/QualityEvaluator.java)

Executing QualityEvaluator checks consistency of the results of the incremental analysis execution compared to the reference execution. The QualityEvaluator assumes identical folder structuring to what the configuration and bash-scripts in IncrementalAnalysesInformation define. It also assumes a complete set of output-files for both incremental and reference execution. There are two implemented modes for result evaluation.

Change-mode:
- The result for a diff file is marked as SAME, if both result files only include identical lines
- The result for a diff file is marked as EQUIVALENT, if the incremental result contains all lines that were modified compared to results for the previous diff file in the reference execution. However the incremental result must not contain any lines that are not present in the reference result for the same diff file.


Variability-mode:
- The result for a diff file is marked as SAME, if both result files only include identical lines *after* disregarding line-number information
- The result for a diff file is marked as EQUIVALENT, if the incremental result contains all variabillity-related lines that were modified compared to results for the previous diff file in the reference execution. However the incremental result must not contain any lines that are not present in the reference result for the same diff file.

The execution of the QualityEvaluator can be achieved through a command line call:

``
# Change-mode (default)
java -jar QualityEvaluator.jar "/path/to/rootfolder_of_kernelhaven_execution"
java -jar QualityEvaluator.jar -c "/path/to/rootfolder_of_kernelhaven_execution"
java -jar QualityEvaluator.jar -change "/path/to/rootfolder_of_kernelhaven_execution"

# Variability-mode
java -jar QualityEvaluator.jar -v "/path/to/rootfolder_of_kernelhaven_execution"
java -jar QualityEvaluator.jar -variability "/path/to/rootfolder_of_kernelhaven_execution"

``

In order to write the evaluation result to your filesystem, use ``> quality.log`` on unix systems:

``
java -jar QualityEvaluator.jar "/path/to/rootfolder_of_kernelhaven_execution" > quality.log

``



 
