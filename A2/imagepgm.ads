-- Author: Affan Khan
-- Student ID: 1095729
-- Date: 2022-03-07
-- University of Guelph - CIS 3190 - Assignment #2
-- PGM file reading and writing algorithms implemeted through sub programs:
-- readPGM, writePGM

with ada.strings.unbounded; use ada.strings.unbounded;

package imagepgm is

    -- Variable declarations
    type myArray is array (integer range <>, integer range <>) of integer;    
    type File_Record(rows : integer; columns : integer) is 
        record
            valid : boolean := false;
            magicId : unbounded_string;
            C : integer;
            R : integer;
            maxValue : integer;
            values : myArray(1..rows, 1..columns);
        end record;

    -- Subprogram declarations
    function readPGM(fileN : string) return File_Record;
    procedure writePGM(fileOUT : string; image : File_Record);

end imagepgm;