# Automate the generation of Output entries in ADE Explorer / Assember
# Benjamin Hershberg, 2022
 
# This script provides an example of how to generate a CSV file that can be imported into ADE via the Outputs->Import filemenu in Explorer/Assember.
# This is particularly useful when you have a large number of iterated Outputs that you need to instantiate (e.g. for validation of a bus of signals)

import csv

with open('./ADEoutputs.csv', mode='w', newline='') as csv_file:

    # Header names that ADE expects to see in the CSV file:
    headers = ["Name", "Type", "Output", "EvalType", "Plot", "Save", "Spec"]

    writer = csv.DictWriter(csv_file, fieldnames=headers)
    writer.writeheader()

    # Each entry has some fields that are always the same:
    entry = {}
    entry['Type'] = 'expr'
    entry['EvalType'] = 'point'
    entry['Plot'] = 't'
    entry['Save'] = ''

    # Example 1:
    min = 0
    max = 15
    for i in range(min,max+1):
        entry['Name'] = f'spec RANK2 ORDER: clkb16T<{(i+1) % (max+1)}> - clkb16T<{i}>'
        entry['Output'] = f'(cross(clip(VT("/clkb16T<{(i+1) % (max+1)}>") cross(clip(VT("/clkb16T<{i}>") VAR("T_clip") VAR("T_runtime") ?interpolate nil) (VAR("DVDD") / 2) 1 "rising" nil nil VAR("tol")) VAR("T_runtime") ?interpolate nil) (VAR("DVDD") / 2) 1 "rising" nil nil VAR("config_crossingTol")) - cross(clip(VT("/clkb16T<{i}>") VAR("T_clip") VAR("T_runtime") ?interpolate nil) (VAR("DVDD") / 2) 1 "rising" nil nil VAR("tol")))'
        entry['Spec'] = 'range (((VAR("T_clk") / 2) - VAR("spec_4T_skew_tol"))) (((VAR("T_clk") / 2) + VAR("spec_4T_skew_tol")))'
        writer.writerow(entry)

    # Example 2:
    min = 0
    max = 63
    for i in range(min,max+1):
        entry['Name'] = f'spec RANK3 ORDER: clk64T<{(i+1) % (max+1)}> - clk64T<{i}>'
        entry['Output'] = f'(cross(clip(VT("/clk64T<{(i+1) % (max+1)}>") cross(clip(VT("/clk64T<{i}>") VAR("T_clip") VAR("T_runtime") ?interpolate nil) (VAR("DVDD") / 2) 1 "falling" nil nil VAR("tol")) VAR("T_runtime") ?interpolate nil) (VAR("DVDD") / 2) 1 "falling" nil nil VAR("config_crossingTol")) - cross(clip(VT("/clk64T<{i}>") VAR("T_clip") VAR("T_runtime") ?interpolate nil) (VAR("DVDD") / 2) 1 "falling" nil nil VAR("tol")))'
        entry['Spec'] = 'range (((VAR("T_clk") / 2) - VAR("spec_4T_skew_tol"))) (((VAR("T_clk") / 2) + VAR("spec_4T_skew_tol")))'
        writer.writerow(entry)