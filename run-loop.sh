#!/bin/sh

if [ ! $# -eq 1 ]; then
  echo "Usage: $0 <num_iterations>"
  exit 0
fi

echo "Launching $1 iterations to reproduce the issue."

for i in `seq 1 $1`; do
  echo -n "."
  sh run.sh 1>run.log 2>&1

  if [ ! $? -eq 0 ]; then
    echo ""
    echo "Reproduced the failure, check run.log"
    exit 1
  fi
done

echo ""
echo "Failed to reproduce issue in $1 iterations"

