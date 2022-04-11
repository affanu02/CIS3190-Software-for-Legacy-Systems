# CIS3190-Software-for-Legacy-Systems
University of Guelph course Winter 2022, Distance Education. 4 assignments, based on the languages Cobol, Ada, Fortran (F95), C, Python

## Assignment 1
Deciphering a legacy Fortran program, re-engineering by translation fortran to a more modern fortran language (F95).
### How to Run ###
> gfortran -Wall FFWIndices.f95 ffwi.f95

## Assignment 2
Basic image processing through a simple matrix of pixels of 2-dimensional array of pixels through PGM format.
Puts the matrix through several calculating processors to invert, transform and contrast stretch them.
### How to Run ###
> gnatmake -Wall imagePGM.adb imagePROCESS.adb image.adb

## Assignment 3
Cobol Re-engineering. Calculate a 10-digit and 13-digit ISBN to see if they are valid or not.
### How to Run ###
> cobc -free -x -Wall isbn.cob

## Assignment 4
Calclating e to n amount of digits. Algorithm provided by Sale, recode algorithm in Python, C, F95, ADA.
### How to Run ###
FORTRAN   > gfortran -Wall calce.f95
ADA       > gnatmake -Wall calce.adb
C         > gcc -std=c99 -lm -Wall calce.c
PYTHON    > python3 calce.py
