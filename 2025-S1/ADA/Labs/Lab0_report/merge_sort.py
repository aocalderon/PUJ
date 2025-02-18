#!/usr/bin/env python3

def merge_sort(array):
    if len(array) > 1: # recurse until length of array is 1...
        r = len(array)//2 # split the array in a half...
        L = array[:r]
        R = array[r:]
        merge_sort(L) # recurse in the left hand side (LHS)...
        merge_sort(R) # recurse in the right hand side (RHS)...
        i = 0
        j = 0
        k = 0
        # the MERGE function...
        while i < len(L) and j < len(R): # iterate until we reach the end of one of the arrays...
            if L[i] < R[j]:
                array[k] = L[i] # if LHS is lower than RHS, let's pick that value...
                i += 1
            else:
                array[k] = R[j] # otherwise, let's pick the RHS value...
                j += 1
            k += 1 # keep track of the size of the sorted array...
        while i < len(L): # if L still have values, let's move them to the sorted array...
            array[k] = L[i]
            i += 1
            k += 1
        while j < len(R): # if R still have values, let's move them to the sorted array...
            array[k] = R[j]
            j += 1
            k += 1

def main():
    array = [8, 2, 4, 9, 3, 6]
    merge_sort(array)
    print(array)

if __name__ == "__main__":
    main()

