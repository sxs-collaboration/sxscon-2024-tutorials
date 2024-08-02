#!/bin/bash -
#SBATCH -o spectre.out
#SBATCH -e spectre.out
#SBATCH -J SpectreCCE
#SBATCH --no-requeue
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --cpus-per-task 2
#SBATCH --mem 10G
#SBATCH -p batch
#SBATCH -t 08:00:00

# Distributed under the MIT License.
# See LICENSE.txt for details.

export SPECTRE_INPUT_FILE=$PWD/CceExecutables/Inspiral.yaml
export SPECTRE_EXECUTABLE=$PWD/CceExecutables/CharacteristicExtract

# Tutorial TODO: Add the run comman for invoking the exectuable