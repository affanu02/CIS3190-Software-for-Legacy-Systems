-- Author: Affan Khan
-- Student ID: 1095729
-- Date: 2022-03-07
-- University of Guelph - CIS 3190 - Assignment #2
-- image processing algorithms implemeted through sub programs:
-- inversion, log conversion, contrast stretching

with imagepgm; use imagepgm;

package imageprocess is

    --subprogram declarations
    function imageINV (image : in File_Record) return File_Record;
    function imageLOG(image : in File_Record) return File_Record; 
    function imageSTRETCH(image : in File_Record) return File_Record; 

end imageprocess;