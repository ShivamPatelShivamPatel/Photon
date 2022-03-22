import pandas as pd

def convert(val):
    count = 0
    result = val
    while(float(result) != float(int(result))):
        count += 1
        result *= 10
    
    return (int(result), count)

def main():
    df = pd.read_csv("coordinates.csv")
    prefix = "echo table_add photon_coordinates coordinates_select "
    suffix = " | python3 ~/Hangar/BMv2/send_bmv2_commands.py ~/Hangar/networks/Photon/Photon.yml p0e0"
    contents = ["#!/usr/bin/env bash" + "\n"]
    for i in range(len(df.values)):
        coordinate = {"x":df.values[i][0], 
                      "y":df.values[i][1], 
                      "z":df.values[i][2]}
        temp = prefix + str(i) + " =\>"

        for dim in coordinate.keys():
            result, count = convert(coordinate[dim])
            sign = result != abs(result)
            temp += " " + str(abs(result)) + " " + str(int(sign)) + " " + str(count)

        contents.append(temp + suffix + "\n")

    with open("sendCoordinates.sh", "w") as f:
        f.writelines(contents)
    
    print("check sendCoordinates.sh")

if __name__ == "__main__":
    main()
