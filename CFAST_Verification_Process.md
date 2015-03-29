# Introduction #

These are preliminary notes on how to run the CFAST Verification Suite. The Suite consists of input files that are designed to test
various CFAST routines. .

All of the input files are located in the Verification diretory of the CFAST repository. The routines used to automate this process are either shell scripts that are appropriate for a Unix, Linux or OSX operating system or ".bat" files for a Windows/DOS computer.

# Required Software #

  * Subversion client
  * LaTeX, preferably PDF-LaTeX.

# Initial Tasks #

The process has a number of prerequisite steps:
  1. Check out the entire CFAST Repository [using these instructions](AccessingSubversionRepository.md), or update your current repository to the latest revision.
  1. Compile CFAST by running the "make\_cfast" scripts in the appropriate directory under the CFAST directory.

# Running the Cases #

  1. cd to the Verification/scripts directory of the Repository.
  1. At the command prompt, type: `./Run_CFAST_Cases.sh`

# Processing the Output #

  1. cd to the Verification/scripts directory of the Repository.
  1. Type `./Make_CFAST_Pictures.sh` (Linux/Unix) or execute `Make_CFAST_Pictures.bat` (Windows). This should automatically generate the Smokeview pictures.

# Compiling the CFAST Verification and Users Guides #