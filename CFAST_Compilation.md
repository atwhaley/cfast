# Preliminaries #

This page describes how to build CFAST using command line
tools that come with the Intel Fortran compiler.

  * Install (or update to the most recent revision) the CFAST SVN repository ([See this Wiki](AccessingSubversionRepository.md) for more details.)
  * Install the Intel Fortran compiler.
  * Define the IFORT\_COMPILER environment variable to point to where your compiler resides. For example for the bash shell place the following line:
```
export IFORT_COMPILER=/opt/intel/composerxe
```
in your .bash\_profile start up file.  For the tcsh shell, place the following line:
```
setenv IFORT_COMPILER /opt/intel/composerxe
```
in your .tcsh start up file.  (Of course put in your own compiler location)
  * If you are working on a Windows PC, install the GNU make utility (http://gnuwin32.sourceforge.net/downlinks/make.php).  Other download options may be found at http://gnuwin32.sourceforge.net/packages/make.htm

# Building CFAST #

There is a general purpose makefile for CFAST compilation in the CFAST/SVN repository directory named CFAST. To compile CFAST for your particular OS, do the following:

  * Open a command shell and cd to the CFAST\intel\_win\_32 directory within the CFAST repository. If you are working under Linux or OSX, 32 or 64 bit, choose the appropriate directory.
  * Type make\_cfast.bat or make\_cfast.sh, depending on your OS.

Alternatively on a Windows PC you may

  * Open the directory CFAST\intel\_win\_32 directory within the CFAST repository using the Windows Explorer interface
  * Double-click on the make\_cfast.bat batch file

If you get stuck, take a look at the `make_cfast` script to better understand what is actually happening. Chances are that there a different path name or compiler version number installed on your machine.