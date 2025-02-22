import os
import pandas as pd

# Configuration parameters
current_dir = os.path.dirname(os.path.abspath(__file__))
folder_path = current_dir
excel_path = os.path.join(current_dir, "Core Image Rename.xlsx")

# Read Excel file
df = pd.read_excel(excel_path)
# Iterate through each row in Excel
for _, row in df.iterrows():
    id_value = str(row["Raw file number"])
    b_value = row["B number"]
    box_value = row["Box number"]
    start_value = row["Slice from"]
    end_value = row["Slice end"]

    # Generate new filename
    new_filename = f"B{b_value}_Box{box_value}_{start_value}-{end_value}.cr2"
    new_filepath = os.path.join(folder_path, new_filename)
    print(new_filepath)
    # Find old file
    old_filename = f"IMG_{id_value}.cr2"
    old_filepath = os.path.join(folder_path, old_filename)
    print(old_filepath)

    # Check if file exists and rename
    if os.path.exists(old_filepath):
        os.rename(old_filepath, new_filepath)
        print(f"Renamed: {old_filename} → {new_filename}")
    else:
        print(f"File not found: {old_filename}")

print("Batch renaming completed!")