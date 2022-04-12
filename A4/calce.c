/*
* Author: Affan Khan
* Student ID: 1095729
* Date: 2022-04-08
* University of Guelph - CIS 3190 - Assignment #4
* Description: Calculates e using the infinite series using algorithm provided by Sale.
*/

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

//definitions
int * ecalculation(int n, int * d);
void keepe(int * d, char* filename, int n);

int main(){
    //variables
    int digits;
    char filename[20];

    //get number of digits to calculate and filename to output from STDIN
    printf("Enter the number of significant digits to calculate: ");
    scanf("%d", &digits);
    int array[digits];
    printf("Enter the filename in which to store the value of e calculated: ");
    scanf("%s", filename);

    //call function to calculate e
    ecalculation(digits, array);

    //call function to output the info to file
    keepe(array, filename, digits);
    return 1;
}

//function to perform the e algorithm
int * ecalculation(int n, int *  d){
    //variables
    int m = 4;
    double test = (n+1) * 2.30258509;

    //calculate m
    do{
        m++;
    }while((m * (log10(m) - 1.0) + 0.5 * log10(6.2831852 * m)) < test);

    //more variables, set all values of coef to 1, set first digit to 2
    int i,j,carry,temp;
    int coef[m-1];
    for(j = 2; j <= m; j++){
        coef[j] = 1;
    }
    d[0] = 2;

    

    //sweep section of algorithm, calculate every digit
    for(i = 1; i <=n; i++){
        carry = 0;
        for(j = m; j >= 2; j--){
            temp = coef[j] * 10 + carry;
            carry = temp/j;
            coef[j] = temp - carry * j;
        }
        
        d[i] = carry;
    }
    
    //return array
    return d;
}

//function  which saves the value of e calculated in an ASCII file
void keepe(int * array, char * filename, int n){
    //variables
    int j = 0;
    FILE *fp;

    //open file for writing
    fp = fopen(filename,"w");
    if(n > 1){
        n++;
    }
    
    //output every element to file
    for(int i = 0; i < n; i++){
        if(i == 1){
            fprintf(fp, ".");
        }
        else{
            fprintf(fp,"%d",array[j++]);
        }
    }

    //close and output success message
    fclose(fp);
    printf("Successfully stored calculated e value!\n");
}
