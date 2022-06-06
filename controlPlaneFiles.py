import pandas as pd

def main():

    args = ["ln", "exp", "cos", "sin", "arccos"]
    suffix = " | python3 ~/Hangar/BMv2/send_bmv2_commands.py ~/Hangar/networks/PhotonV3/Photon.yml p0e0"
    contents = ["#!/usr/bin/env bash" + "\n"]
    
    for i in range(1,5):
        temp = "echo mirroring_add " + str(i) + " " + str(i) #in future, put multiples/mod
        contents.append(temp + suffix + "\n")

    for arg in args:
        coefficients = pd.read_csv(arg + "Coef.csv").values
        for ci in coefficients:
            if(arg != "arccos"):
                temp = "echo register_write %s_coefficients %d %d" % (arg, ci[0], ci[1])
            else:
                temp = "echo register_write arcsin_coefficients %d %d" % (ci[0], ci[1])
            
            contents.append(temp + suffix + "\n")

    
    with open("sendCoefficients.sh", "w") as f:
        f.writelines(contents)
    
    print("check sendCoefficients.sh")

if __name__ == "__main__":
    main()
