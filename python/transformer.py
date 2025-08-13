import pandas as pd
import numpy as np
import os

def load_csv(complete_path):
    # Use a breakpoint in the code line below to debug your script.
    print(f'Hi, {complete_path}')  # Press Ctrl+F8 to toggle the breakpoint.
    csv_data = pd.read_csv(complete_path, encoding="utf-8")
    print(csv_data.__class__.__name__)
    output_file = data_directory + "objects.js"
    out = open(output_file, 'w')

    out.write('function addObjectClusters() {\n')
    for index, row in csv_data.iterrows():
        print("""'ra': {:.2f}, 'dec': {:.2f},""".format(row['ra'], row['dec']))
        out.write('''planetarium.addPointer({
           "ra": ''' + str(row['ra']) + ''',
           "dec": ''' + str(row['dec']) + ''',
           "label": "",
           "colour": " rgb(255,0,0) "});\n''')

    out.write('\n}\n')
    out.close()


def print_hi(name):
    # Use a breakpoint in the code line below to debug your script.
    print(f'Hi, {name}')  # Press Ctrl+F8 to toggle the breakpoint.


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    print_hi('PyCharmsss')
    data_directory = 'C:\\users\\carlos\\oneDrive\\data-science\\TFM\\tfm\\data\\'
    file = data_directory + "sample.csv"
    print(file)
    load_csv(file)
