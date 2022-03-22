import pandas as pd

def main():
    original = pd.read_csv("coordinates.csv",)
    result = pd.read_csv("result_coordinates.csv")
    sliced = original.loc[result["original_index"]]
    
    print(sliced)
    print(result)
    
if __name__ == "__main__":
    main()

