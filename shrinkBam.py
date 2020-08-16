#!/usr/local/bin/python3
import sys # Load a library module print(sys.platform)
import os
import os.path
sys.path.append("/Users/raffaelecalogero/Dropbox/data/comoglio/iggrant/MetObservatory/metObservatory")
from functions import extractMet 

"""

This script is used to edit bam files and extract only the met gene reads
It is assumed that the folder passed to the script is the upper folder where folders, each one containg a bam and a bai file, downloaded by TCGA are located.

"""


try:
 home=sys.argv[1]
 print(home)
except:
 print('\nPlease, run script passing directory_name\n')
 sys.exit()


# home = '/Users/raffaelecalogero/Desktop/test'
extractMet(folder = home)

#./shrinkBam.py /Volumes/Elements/brain

#extractChimericMet(folder = home)