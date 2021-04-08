# functions
#this function is used to edit bam files and extract only the met gene reads and their corresponding potential chimeric reads
#it is assumed that the folder passed to the function is the upper folder where are located folders, downloaded by TCGA, each one containing a bam and a bai file
import sys # Load a library module print(sys.platform)
import os
import os.path

def extractMet(folder):
	os.chdir(folder) #setting working dir
	#print(os.getcwd())
	#dir_list = os.listdir(folder)
	#reads files in a folder
	for file_name in os.listdir(folder):
		#detect which is a folder
		if os.path.isdir(file_name):
			#  my_folder =  str.join('/', (folder, file_name))
			my_folder =  os.path.join(folder, file_name)
			#print(my_folder, sep="\n")
			for file_in_folder in os.listdir(my_folder):
				if file_in_folder.endswith(".bam"):
					#print(os.path.join(folder, file_name))
					mybam = os.path.join(folder, file_name, file_in_folder)
					mysam = mybam.replace(file_in_folder, 'met.sam')
					samtools_view = 'samtools view'
					met_loc = 'chr7:116672196-116798377' #hg38 location
					mycommand = str.join(' ', (samtools_view, mybam, met_loc, '> ', mysam))
					print('\n', 'Extracting MET reads', '\n')
					#print(mycommand, sep="\n")
					os.system(mycommand)
					#bams stats
					samtools_idxstats = 'samtools idxstats'
					stats_output = os.path.join(folder, file_name, 'stats.txt')
					mystat = str.join(' ', (samtools_idxstats, mybam, '>', stats_output))
					#print(mystat, sep="\n")
					os.system(mystat)
					#extract chimeric reads
					bamsam = '/usr/local/bin/IOsam/BAMandSAM'
					mybam2 = mybam.replace(file_in_folder, 'others.bam')
					mycommand = str.join(' ', (bamsam, mybam, mybam2))
					print(mycommand, sep="\n")
					os.system(mycommand)
					
					
	#print('\n', 'initial bam files are removed', '\n)				
	return(0)    


def extractChimericMet(folder):
	os.chdir(folder) #setting working dir
	for file_name in os.listdir(folder):
		if os.path.isdir(file_name):
			my_folder =  os.path.join(folder, file_name)
			for file_in_folder in os.listdir(my_folder):
				if file_in_folder.endswith(".sam"):
					if(file_in_folder != 'supplementary.sam'):
						met_sam = os.path.join(folder, file_name, file_in_folder)
						extract_reads = 'cut -d$\'\t\' -f1'
						met_reads = os.path.join(folder, file_name, 'met_reads.txt')
						#print(met_reads, sep="\n")
						mycommand = str.join(' ', (extract_reads, met_sam, '>',  met_reads))
						#print(mycommand, sep="\n")
						os.system(mycommand)
						sorted_met_reads = os.path.join(folder, file_name, 'sorted_met_reads.txt')
						mycommand = str.join(' ',('sort', met_reads, '>', sorted_met_reads))
						os.system(mycommand)
						get_unique = 'uniq -u '
						sorted_met_reads_u = os.path.join(folder, file_name, 'sorted_met_reads_u.txt')
						mycommand = str.join(' ',(get_unique, sorted_met_reads, '>', sorted_met_reads_u))
						os.system(mycommand)
	return(0)
	