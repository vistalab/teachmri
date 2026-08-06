#!/bin/bash

# Run all MATLAB tutorial files with proper path setup
MATLAB="/Applications/MATLAB_R2026a.app/bin/matlab"
MATLAB_PATH="$HOME/Documents/MATLAB/teach/teachmri/utility"
OUTPUT_FILE="tutorial_output.log"

# Clear previous output
> "$OUTPUT_FILE"

# Run each tutorial file
for file in *.m; do
  echo "Running $file..." | tee -a "$OUTPUT_FILE"
  "$MATLAB" -batch "addpath('$MATLAB_PATH'); run('$file')" >> "$OUTPUT_FILE" 2>&1
  
  # Check exit status
  if [ $? -eq 0 ]; then
    echo "✅ $file completed successfully" | tee -a "$OUTPUT_FILE"
  else
    echo "❌ $file failed" | tee -a "$OUTPUT_FILE"
  fi
  
  echo "----------------------------------------" | tee -a "$OUTPUT_FILE"
done

echo "All tutorials completed. See $OUTPUT_FILE for details"