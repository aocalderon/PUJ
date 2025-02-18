#!/usr/bin/env python3

import random

# traverse a range of length n and for each n call a get a random integer between 0 and n...
def generate_random_array(n):
    return [random.randint(0, n) for _ in range(n)]

def main():
    n = random.randint(30, 100) # test with a value of n between 30 and 100...
    random_array = generate_random_array(n)
    print(random_array)    

if __name__ == "__main__":
    main()

