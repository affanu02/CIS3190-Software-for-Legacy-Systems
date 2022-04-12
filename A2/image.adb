-- Author: Affan Khan
-- Student ID: 1095729
-- Date: 2022-03-07
-- University of Guelph - CIS 3190 - Assignment #2
-- A program in Ada to perform some image processing operations on a grayscale image 
--      stored in an ASCII P2 PGM format. image.adb allows user to interact with the
--      two packages imageprocess.adb and imagepmg.adb. SUbprograms to assist in
--      this are continue and getFilename.

with Ada.Text_IO; use Ada.Text_IO;
with ada.integer_text_io; use ada.integer_text_io;
with ada.strings.unbounded; use ada.strings.unbounded;
with ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;
with ada.directories; use ada.directories;
with imagepgm; use imagepgm;
with imageprocess; use imageprocess;

procedure image is
    --variables used
    fileIN, fileOUT: unbounded_string;
    choice : integer;
    image : File_Record(500, 500);

    -- Function to return boolean if user imputted yes or no to continue
    --      Return: boolean
    function continue return boolean is
        ch: character;
    begin
        loop
            get(ch);
            skip_line;

            --return boolean depending on user input
            case ch is
                when 'y' | 'Y' =>
                    return true;
                when 'n' | 'N' =>
                    return false;
                when others =>
                    put("type y or n: ");
            end case;
        end loop;
    end continue;

    -- Function to get file name, error check if the file exists or not
    --      Param: character to specify if file is for reading ('r') or writing ('w')
    --      Return: unbounded_string 
    function getFilename(x : character) return unbounded_string is
        fileN : unbounded_string;
        nameOK : boolean := false;
    begin
        get_line(fileN);-- do not remove, unknown bug defender 

        -- for reading files
        if x = 'r' then
            loop
                exit when nameOK;
                get_line(fileN);
                nameOK := exists(to_string(fileN));

                --check if they exist, if not say error and prompt user to input again
                if nameOK = false then
                    Put_line("File does not exist try again: ");
                end if;
            end loop;
        -- for writing files
        else
            loop
                exit when nameOK;
                get_line(fileN);
                nameOK := exists(to_string(fileN));

                --check if filename exists, if it does prompt user to overwrite it
                if nameOK then
                    Put_line("File already exists. Would you like to over write it? (y,n) ");

                    --prompt user to enter another filename if user does not want to over write file
                    if continue = false then
                        Put_line("Please enter a file name to write to: ");
                        nameOK := false;
                    end if;
                else
                    nameOK := true;
                end if;
            end loop;
        end if;

        return fileN;
    end getFilename;

begin
    loop
        -- Display menu
        new_line;
        Put_line("-------------------------------------------------------");
        Put_line("Enter an image conversion option from list below");
        Put_line("1. Read in PGM image from file");
        Put_line("2. Apply image invertion");
        Put_line("3. Apply LOG function");
        Put_line("4. Apply contrast stretching");
        Put_line("5. Apply histogram equalization");
        Put_line("6. Write PGM image to file");
        Put_line("7. Quit");
        Put_line("-------------------------------------------------------");

        -- Prompt user for menu choice
        put("Enter a number (1-7): ");
        get(choice);
        new_line;
        Put_line("-------------------------------------------------------");

        --call subprograms and packages depending on menu choice inputted by user
        case choice is
            when 1 =>
                --get file name from user
                Put_line("Please enter a file name to read: ");
                fileIN := getFilename('r');

                --call readPGM to read and record contents of file
                image := readPGM(to_string(fileIN));
                if image.valid then
                    Put_line("Record has been validated!!");
                else
                    Put_line("File was not validated.");
                end if;
            when 2 =>
                --image inversion transformation
                Put_line("Image inversion...");
                image := imageINV(image);
                Put_line("...Completed!");
            when 3 =>
                --logarithmetic transformation
                Put_line("Image logarithmetic transofrmation...");
                image := imageLOG(image);
                Put_line("...Completed!");
            when 4 =>
                --contrast stretching trnasformation
                Put_line("Contrast stretching transformation...");
                image := imageSTRETCH(image);
                Put_line("...Completed!");
            when 5 =>
                --extra marks function not implemented
                Put_line("This has not been implemented yet. Sorry!");
            when 6 =>
                --get filename from user to write to
                Put_line("Please enter a file name to write to: ");
                fileOUT := getFilename('w');
                writePGM(to_string(fileOUT), image);
            when 7 =>
                --user exiting program
                Put_line("Exiting. Have a good day!");
            when others =>
                --error trap any other choice
                Put_line("Incorrect choice, try again.");
        end case;
        exit when choice = 7;
    end loop;
end image;