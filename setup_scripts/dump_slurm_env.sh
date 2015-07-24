#!/bin/bash

env | grep SLURM | sed -e 's/^/export\ /' > slurm-env.sh
