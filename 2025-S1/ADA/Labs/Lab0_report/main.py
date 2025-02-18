#!/usr/bin/env python3

import time # to get the current time...

# call the main functions...
from array_generator import generate_random_array
from insertion_sort import insertion_sort
from merge_sort import merge_sort

# number of runs for each size...
number_of_run = 5
# the array' sizes we want to evaluate...
sizes = [1000, 2000, 4000, 6000, 8000, 10000, 12500, 15000, 17500, 20000]

for n in range(1, number_of_run):
    for size in sizes:
        # generate a random array with the provided size...
        array = generate_random_array(size) 
        # call insertion-sort and capture the execution time...
        t0 = time.time()
        insertion_sort(array)
        insertion_time = time.time() - t0
        print("{}\t{}\t{}".format("Insertion", size, insertion_time))
        # call merge-sort and capture the execution time...
        t0 = time.time()
        merge_sort(array)
        merge_time = time.time() - t0
        print("{}\t{}\t{}".format("    Merge", size, merge_time))