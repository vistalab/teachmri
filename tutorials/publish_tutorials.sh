#!/bin/bash

# Publish all MATLAB tutorial files in this directory to self-contained
# HTML using iePublish (isetcam). Run from inside teachmri/tutorials/, same
# as run_all_tutorials.sh — the *.m glob is relative to the current directory.
#
# iePublish writes each HTML file next to its source .m file, i.e. into
# this directory. Copy the resulting .html files into the book repo's
# code/ directory as a separate step — that repo holds only the published
# HTML, not the runnable tutorial source.
ISETCAM_PATH="$HOME/Documents/MATLAB/isetcam"
MATLAB="/Applications/MATLAB_R2026a.app/bin/matlab"
MATLAB_PATH="$HOME/Documents/MATLAB/teach/teachmri/utility"

for file in *.m; do
  echo "Publishing $file..."
  "$MATLAB" -batch "addpath(genpath('$ISETCAM_PATH')); addpath('$MATLAB_PATH'); iePublish('$file')"

  # Check exit status
  if [ $? -ne 0 ]; then
    echo "Error publishing $file"
    exit 1
  fi
done

echo "All tutorials published successfully"
