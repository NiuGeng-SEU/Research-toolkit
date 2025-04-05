# Research-toolkit

Essential tools and scripts for academic research workflow automation.

## Directory Structure

- src/  
  1. InsertFormattedEquation.bas  
  2. excel_based_renamer.py  
  3. perspective_crop_raw.py  
  4. TGAWeightDeri.m & TGADSC.m

## Repositories

### Insert Formatted Equation

A Word VBA macro that creates a three-column table to format equations with automatic numbering.  

Requirements: 1. Microsoft Word 2. Enable VBA macros  

### Excel based renamer

A Python script to batch rename image files using Excel data.  

Requirements: 1. Python 3 with pandas 2. Excel file with required naming data  

### Perspective Crop Raw

A Python script that processes RAW camera files (.cr2) by applying perspective correction and converting them to JPEG format.  

Requirements: 1. Python 3 with the following packages: opencv-python (cv2), numpy, rawpy 2. RAW (.cr2) image files in the "Raw" subfolder  

### Thermogravimetric Analysis

A matlab code that figure and analyze TGA DSC data. Mark the mass loss of different stages automatically.

Requirements: 1. Matlab 2. TGA data

