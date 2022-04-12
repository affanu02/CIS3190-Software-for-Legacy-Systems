-- Author: Affan Khan
-- Student ID: 1095729
-- Date: 2022-03-07
-- University of Guelph - CIS 3190 - Assignment #2
-- image processing algorithms implemeted through sub programs:
-- inversion, log conversion, contrast stretching

with ada.numerics.Elementary_Functions; use ada.numerics.Elementary_Functions; 

package body imageprocess is 

    -- Subprogram to inverse numbers from 0 to maxValue
    --    Param: file_Record holding data about the file to manipulate
    --    Return: temp file_Record holding data with new converted values
    --    F(Ixy) = abs(Ixy - 255)
    --    where Image is I, and xy represent the coordinates of the pixel
    function imageINV (image : in File_Record) return File_Record is 
        imageTemp : File_Record(500, 500);
    begin 
        imageTemp := image;
        
        --loop through each row and column to convert each pixel value
        for i in 1..image.R loop
            for j in 1..image.C loop
                -- inverse calculations
                imageTemp.values(i,j) := abs(image.values(i, j) - image.maxValue);
            end loop;
        end loop;

        return imageTemp;
    end imageINV;

    -- Logarathimic calculation to perform log calculations
    --    Param: file_Record holding data about the file to manipulate
    --    Return: temp file_Record holding data with new converted values
    --    F(Ixy) = log(Ixy + 1)
    --    where Image is I, and xy represent the coordinates of the pixel
    function imageLOG(image : in File_Record) return File_Record is 
        imageTemp : File_Record(500, 500);
        tempF : float := 0.0;
    begin
        imageTemp := image;

        --loop through each row and column to convert each pixel value
        for i in 1..image.R loop
            for j in 1..image.C loop
                tempF := float(image.values(i, j) + 1);
                tempF := log(tempF);
                imageTemp.values(i, j) := integer(tempF);
            end loop;
        end loop;

        return imageTemp;
    end imageLOG;

    
    -- Stretch calculation, performs contrast stretching
    --    Param: file_Record holding data about the file to manipulate
    --    Return: temp file_Record holding data with new converted values
    --    F(Ixy) = 255 ((Ixy - min)/(max - min))
    --    where Image is I, and xy represent the coordinates of the pixel
    function imageSTRETCH(image : in File_Record) return File_Record is 
        max, min: integer := 0;
        tempF, maxF, minF : float := 0.0;
        imageTemp : File_Record(500, 500);
    begin
        --find max pixel amd min pixel value
        max := 0;
        min := image.maxValue;
        for i in 1..image.R loop
            for j in 1..image.C loop
                if image.values(i,j) > max then
                    max := image.values(i,j);
                elsif image.values(i,j) < min then
                    min := image.values(i,j);
                end if;
            end loop;
        end loop;

        --convert to floats and temp holding values
        maxF := float(max);
        minF := float(min);
        imageTemp := image;

        --loop through each row and column to convert each pixel value
        for i in 1..image.R loop
            for j in 1..image.C loop
                -- contrast stretching calculations
                tempF := float(image.values(i,j));
                tempF := (255.0 * ((tempF - minF) / (maxF - minF)));
                imageTemp.values(i,j) := integer(tempF);
            end loop;
        end loop;

        return imageTemp;
    end imageSTRETCH;

end imageprocess;