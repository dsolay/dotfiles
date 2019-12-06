#! /usr/bin/python
# -*- coding: utf-8 -*-

import csv, json, os

path_data_input="/media/Data/Documents/solay_usb/logins/Appstore/"
dir_data_output="/home/ernest/csv"
header = ["name", "username", "url", "password", "extra", "grouping"]

def to_csv(data):
    row = []

    outputFile = open(dir_data_output + "/" + data["name"] + ".csv", 'w') #load csv file
    output = csv.writer(outputFile) #create a csv.write

    output.writerow(header)

    for value in header:
        if value in data:
            if value == "url":
                row.append(data[value][0])
            else:
                row.append(data[value])
        else:
            row.append("")

    output.writerow(row)
    outputFile.close()    

def main():
    for (root, dirs, files) in os.walk(path_data_input): 
        for file in files:
            # name, ext = os.path.splitext(file)
            data = json.loads(open(root + file).read())
            to_csv(data)
            print(file + " converted to .csv")
            print('------------------------------------------\n')

main()