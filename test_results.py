import pandas as pd
import math

def convert(val):
    count = 0
    result = val
    while(float(result) != float(int(result))):
        count += 1
        result *= 10
    
    return (int(result), count)

def main():
    df = pd.read_csv("coordinates.csv",)
    #result = pd.read_csv("result_coordinates.csv")
    #sliced = original.loc[result["original_index"]]
    contents = ["result,sign,count,log2" + "\n"]
    for i in range(len(df.values)):
        coordinate = {"x":df.values[i][0], 
                      "y":df.values[i][1], 
                      "z":df.values[i][2]}

        for dim in coordinate.keys():
            temp = ""
            result, count = convert(coordinate[dim])
            sign = result != abs(result)
            temp += str(abs(result)) + "," + str(int(sign)) + "," + str(count) + "," + str(math.ceil(math.log2(abs(result)))) + "," + str(math.ceil(math.log2(100 * abs(result))))
            contents.append(temp + "\n")
    
    with open("testoutput.csv","w") as f:
        f.writelines(contents)
    
if __name__ == "__main__":
    main()

