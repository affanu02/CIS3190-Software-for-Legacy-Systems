# Author: Affan Khan
# Student ID: 1095729
# Date: 2022-04-08
# University of Guelph - CIS 3190 - Assignment #4
# Description: Calculates e using the infinite series using algorithm provided by Sale.

import math
import sys
import array as arr
import numpy as np

# function to calculate e value using the algorithm
def ecalculation(n, d):
    #variables used
    m = 4
    test = (n+1) * 2.30258509
    while ((m * (math.log10(m) - 1.0) + 0.5 * math.log10(6.2831852 * m)) < test):
        m += 1

    #declare more variables and fill coef array with 1s
    coef = [0] * (m + 1)
    temp = 0
    carry = 0
    j = 2
    while j <= m:
        coef[j] = 1
        j += 1
    
    #append the first digit to e
    d.append(2)

    #sweep section of algorithm, calculate every decimal for e
    i = 1
    while i <= n:
        carry = 0
        j = m
        while j >= 2:
            temp = int(math.floor(coef[j] * 10 + carry))
            carry = int(math.floor(temp/j))
            coef[j] = int(math.floor(temp - carry * j))
            j-=1
        #append each decimal after calculation
        d.append(int(carry))
        i += 1

# prints the e calculation to the file
def keepe(array, filename, n):
    fp = open(filename, "w")

    i = 0
    for x in array:
        if i == 1:
            fp.write('.')
        fp.write(str(x))
        i += 1 

    fp.close

    print("Successfully stored calculated e value!")

# get user number and filename through STDIN
digits = input("Enter the number of significant digits to calculate: ")
filename = input("Enter the filename in which to store the value of e calculated: ")

#declare empty array
d = arr.array('i')

#call e calculation to calculate value of e
ecalculation(int(digits), d)
# call keepe to save value calculated to file
keepe(d, filename, digits)