import csv
import re
import bz2
import os

#directory is the location of the raw files from https://figshare.com/articles/dataset/Parity_games/6004130/1?file=10792910

directory = "modelcheck_RAW"
save = "modelchecking"


count = 0
error_files = []
for filename in os.listdir(directory):
    count += 1
    print(count)
    file = os.path.join(directory, filename)
    if os.path.isfile(file) and filename.endswith(".bz2") and (filename+".csv") not in os.listdir(save):
        pass
    else:
        continue
    
    print("converting: " + filename)
    try:
        f = bz2.open(file, "rt")
        lines = f.readlines()
        f.close()
        size = len(lines) -1;
        row_i = []
        col_j = []
        priority = []
        owner = []
        for i in range(len(lines)-1):
            line = []
            for string in re.split("[ ;,]",lines[i+1]):
                try:
                    line.append(int(string))
                except ValueError:
                    pass
            priority.append(line[1])
            owner.append(line[2])
            row_i += [i+1]*len(line[3:])
            for pos in line[3:]:
                col_j.append(pos+1)
    except:
        error_files.append(filename)
            
    with open(save + "/" + filename + ".csv", "w") as exp:
        writer = csv.writer(exp)
        writer.writerow(owner)
        writer.writerow(priority)
        writer.writerow(row_i)
        writer.writerow(col_j)

#Run the following version for mlsolver files
#Just makes start from index 2 instead of 1 

"""
count = 0
error_files = []
for filename in os.listdir(directory):
    count += 1
    file = os.path.join(directory, filename)
    if os.path.isfile(file) and filename.endswith(".bz2") and (filename + ".csv") not in os.listdir(save):
        pass
    else:
        continue
    
    print("converting: " + filename)
    try:
        f = bz2.open(file, "rt")
        lines = f.readlines()
        f.close()
        size = len(lines) -2;
        row_i = []
        col_j = []
        priority = []
        owner = []
        for i in range(len(lines)-2):
            line = []
            for string in re.split("[ ;,]",lines[i+2]):
                try:
                    line.append(int(string))
                except ValueError:
                    pass
            priority.append(line[1])
            owner.append(line[2])
            row_i += [i+1]*len(line[3:])
            for pos in line[3:]:
                col_j.append(pos+1)
    except:
        error_files.append(filename)
            
    with open("converted_GAMES/mlsolver/" + filename + ".csv", "w") as exp:
        writer = csv.writer(exp)
        writer.writerow(owner)
        writer.writerow(priority)
        writer.writerow(row_i)
        writer.writerow(col_j)

"""
