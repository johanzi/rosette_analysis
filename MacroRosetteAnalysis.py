#!/Users/tergemina/anaconda3/bin/python

'''
        FILE: MacroRosetteAnalysis.py

       USAGE: ./MacroRosetteAnalysis.py

 DESCRIPTION: rosette analysis for the project leaf area and RGB values
     OPTIONS: ---
REQUIREMENTS: ---
        BUGS: ---
       NOTES:
      AUTHOR: Emmanuel Tergemina
ORGANIZATION: Department of Plant Developmental Biology, Max Planck Institute for Plant Breeding Research
     VERSION: 1.0
     CREATED: 2018/11/22
    REVISION: ---
'''

import glob
import os
import re
import pandas as pd

current_wd = os.getcwd()
wd = os.chdir(current_wd + '/results')

output = open('FinalAnalysis.txt','wt')

#Header
header = ''
color = ['Red', 'Green', 'Blue']
def head_Results(var):
    return '\tRosette_{0}\tSD_Rosette_{0}'.format(var)
def head_Scale(var, col):
    tmp = ''
    for i in var:
         tmp += '\t{1}_{0}\tSD_{1}_{0}'.format(i, col)
    return(tmp)

header += 'Sample\tArea'
for i in color:
    header += head_Results(i)
header += head_Scale(color,'GREEN_Calibrator')
header += head_Scale(color,'YELLOW_Calibrator')
header += '\n'

output.write(header)
#Extract the name of the pictures
pictures = []
for file in glob.glob('*.txt'):
    if 'Results' in file:
        index = re.search('_Result', file).start()
        pictures.append(file[:index])

def extract_Results(var):
        df = pd.read_csv(var, sep = "\t")
        string = ''
        string += '\t{}'.format(df['Area'][0])
        for i in range(3):
            string += ('\t{}\t{}'.format(df['Mean'][i],df['StdDev'][i]))
        return string

def extract_Scale(var):
        df = pd.read_csv(var, sep = "\t")
        string = ''
        for i in range(3):
            string += ('\t{}\t{}'.format(df['Mean'][i],df['StdDev'][i]))
        return string

#Extract Results and RGB
for name in pictures:
    results = ''
    green = ''
    for file in glob.glob('*.txt'):
        if name in file:
            if 'Results' in file:
                results = extract_Results(file)
            elif 'Green' in file:
                green = extract_Scale(file)
            elif 'Yellow' in file:
                yellow = extract_Scale(file)
    output.write(name + results + green + yellow +'\n')
output.close()







