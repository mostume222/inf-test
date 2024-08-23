#!/bin/bash 
source $HOME/.bashrc

#the result is at maximum 1
cutadapt --max-n 0 -o $2 $1

