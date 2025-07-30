#!/usr/bin/env python3

def insertion_sort(array):
    for step in range(1, len(array)):
        key = array[step]
        j = step - 1
        while j >= 0 and key < array[j]:
            array[j + 1] = array[j]
            j = j - 1
        array[j + 1] = key

def main():
    array = [8, 2, 4, 9, 3, 6]
    insertion_sort(array)
    print(array)
    
if __name__ == "__main__":
    main()

