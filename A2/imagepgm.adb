-- Author: Affan Khan
-- Student ID: 1095729
-- Date: 2022-03-07
-- University of Guelph - CIS 3190 - Assignment #2
-- PGM file reading and writing algorithms implemeted through sub programs:
-- readPGM, writePGM

with Ada.Text_IO; use Ada.Text_IO;
with ada.integer_text_io; use ada.integer_text_io;
with ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;
with ada.strings.fixed; use ada.strings.fixed;

package body imagepgm is

    -- ReadPGM function, read contents of pgm file and return record of it in 2D array
    --     Param: filename string
    --     Return: temp file_Record holding data about the file to manipulate
    function readPGM(fileN : string) return File_Record is
        infp : file_type;
        i, j: integer := 0;
        image : File_Record(500, 500);
    begin
        --open file for reading and declare record
        open(infp, in_file, fileN);

        --check for P2 or P5 in first row. If missing, display error and return false after closing file
        get_line(infp, image.magicID);
        if image.magicID /= "P2" and image.magicID /= "P5" then
            Put_line("File is not in the P2 PGM format. Terminating reading file.");
            close(infp);
            return image;
        end if;
        
        --check second and third row. read in rows and columns number and value max
        get(infp, image.C);
        get(infp, image.R);
        get(infp, image.maxValue);

        --fill 2D array with file values
        begin
            --go through file content and get out each number and input into 2D array if error out of bounds display error and return false after closing file
            i := 1; j := 1;

            --loop until all file contents are empty
            loop
                exit when end_of_file(infp);
                get(infp, image.values(i, j));

                -- increment j until it reaches column max
                j := j + 1;

                --plus i with if j reaches column max and reset j
                if j > image.C then 
                    i := i + 1;
                    j := 1;
                -- send error message if the number of rows do exceed dimensions
                elsif i > image.R then
                    Put_line("Error: File has incorrect dimensions. Terminating reading file.");
                    close(infp);
                    return image;
                end if;
            end loop;

        --catch any exceptions thrown throughout loop
        exception
                when constraint_error =>
                    -- if the columns exceed or less than dimensions, throw exception
                    if i <= image.R then
                        Put_line("Error: File has incorrect dimensions. Terminating reading file.");
                        close(infp);
                        image.valid := false;
                        return image;
                    end if;
                when end_error => -- bug to fix, throws this exception even when file is valid
                    new_line;
        end;

        --close file and return true
        close(infp);
        image.valid := true;
        return image;
    end readPGM;
    

    -- WritePGM function, writes the record contents to a file, peferrably pgm type file
    --     Param: filename string, temp file_Record holding data about the file
    procedure writePGM(fileOUT : string; image : File_Record) is
        outfp : file_type;
    begin
        --open filename for writing
        create(outfp, out_file, fileOUT);

        --write magic ID< rows, columns, max value
        put(outfp, image.magicID);
        new_line(outfp);
        put(outfp, Trim(Integer'Image(image.C), Ada.Strings.Left));
        put(outfp, Integer'Image(image.R));
        new_line(outfp);
        put(outfp, Trim(Integer'Image(image.maxValue), Ada.Strings.Left));
        new_line(outfp);

        --write all values
        for i in 1..image.R loop
            for j in 1..image.C loop
                if j = 1 then --removes the leading space when writing to a file
                    put(outfp,  Trim(Integer'Image(image.values(i,j)), Ada.Strings.Left));
                else
                    put(outfp, Integer'Image(image.values(i, j)));
                end if;
            end loop;
            new_line(outfp);
        end loop;

        --close file
        close(outfp);
    end writePGM;

end imagepgm;