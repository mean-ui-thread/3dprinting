#!/usr/bin/env python3
import os
import json
import subprocess
import glob
import sys
# from lib3mf_common import get_wrapper, get_version

# Prompt user for JSON file
json_file = input("Enter the JSON file to use (default: tpu_grommet.json): ").strip()
if not json_file:
    json_file = "tpu_grommet.json"
scad_file = "tpu_grommet.scad"
three_mf_file = "tpu_grommet.3mf"
out_dir = "."

os.makedirs(out_dir, exist_ok=True)

# Remove existing STL files
for stl in glob.glob(os.path.join(out_dir, "*.stl")):
    os.remove(stl)

# Load parameter sets from JSON
with open(json_file, "r") as f:
    data = json.load(f)
parameter_sets = data.get("parameterSets", {})

stl_files = []
for set_name, params in parameter_sets.items():
    # Build OpenSCAD parameter string
    param_str = ";".join(f"{k}={v}" for k, v in params.items())
    out_file = os.path.join(out_dir, f"{set_name.replace(' ', '_').replace(',', '').replace('.', '_').replace('+_', '')}.stl")
    # Run OpenSCAD
    subprocess.run([
        "openscad", "-o", out_file, "-D", param_str, scad_file
    ], check=True)
    stl_files.append(out_file)

# Use lib3mf_common to combine STL files into a single 3MF file
# wrapper = get_wrapper()
# get_version(wrapper)
# model = wrapper.CreateModel()
# for stl_file in stl_files:
#     reader = model.QueryReader("stl")
#     abs_stl_file = os.path.abspath(stl_file)
#     print(f"Reading {abs_stl_file}...")
#     reader.ReadFromFile(abs_stl_file)
# writer = model.QueryWriter("3mf")
# print(f"Writing {three_mf_file}...")
# writer.WriteToFile(three_mf_file)
# print("Done")
