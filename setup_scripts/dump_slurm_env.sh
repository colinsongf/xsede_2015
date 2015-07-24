#!/bin/bash

env | grep -i ^slurm | grep -i -v per_node | sed -e 's/^/export\ /' > slurm-env.sh
