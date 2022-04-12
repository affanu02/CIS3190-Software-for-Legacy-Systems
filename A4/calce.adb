-- Author: Affan Khan
-- Student ID: 1095729
-- Date: 2022-04-08
-- University of Guelph - CIS 3190 - Assignment #4
-- Description: Calculates e using the infinite series using algorithm provided by Sale.

with Ada.Text_IO; use Ada.Text_IO;
with ada.integer_text_io; use ada.integer_text_io;
with ada.strings.unbounded; use ada.strings.unbounded;
with ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;
with ada.numerics.elementary_functions; use ada.numerics.elementary_functions;

procedure calce is
    --variables used
    filename: unbounded_string;
    digitss : integer;
    type MainArray is array (0..802) of integer;
    d: MainArray;

    --procedure that outputs e calculation to file
    procedure keepe is
        j : integer := 0;
        outfp: file_type;
        n : integer := digitss;
    begin
        if n > 1 then 
            n := n + 1;
        end if;

        -- creates new file to output to
        create(outfp, out_file, to_string(filename));

        -- loops through the number of required iterations to output to
        for i in Integer range 1 .. n loop
            if i /= 2 then
                put(outfp, d(j), width => 0);
                j := j + 1;
            else
                put(outfp, "."); -- inputs the decimal where it belongs
            end if;
        end loop;

        --closes the file
        close(outfp);
    end keepe;

    --more calculations
    procedure moreCalculation(m : integer; n : integer) is
        i: integer;
        j: integer := 2;
        carry: integer;
        temp : integer;
        type secondArray is array(2 .. m) of integer;
        coef : secondArray;
    begin
        loop
            coef(j) := 1;
            exit when j >= m;
            j := j + 1;
        end loop;
        d(0) := 2;

        --sweep section from the algorithm
        i := 1;
        loop
            carry := 0;
            j := m;
            loop
                temp := coef(j) * 10 + carry;
                carry := temp/j;
                coef(j) := temp - carry * j;

                exit when j <= 2;
                j := j - 1;
            end loop;

            --inputs the value into the array
            d(i) := carry;                
            exit when i >= n;
            i := i + 1;
        end loop;
    end moreCalculation;

    -- calculates some variables used for e calculation
    procedure ecalculation is
        m: integer := 4;
        test : float;
    begin
        test := float((digitss + 1) * 2.30258509);
        loop
            m := m + 1;
            exit when ((float(m) * (log(float(m)) - 1.0) + 0.5 * log(float(6.2831852 * m))) >= test);
        end loop;
        --gets the value m, necassry for the e calculation

        --calls procedure as m is figured through runtime, easier to call another procedure to handle it
        moreCalculation(m, digitss);  
    end ecalculation;
    
begin
    -- get number of digits to calculate and filename to output from STDIN
    Put_line("Enter the filename in which to store the value of e calculated: ");
    get_line(filename);
    Put_line("Enter the number of significant digits to calculate: ");
    get(digitss);

    -- call e calculation to calculate value of e
    ecalculation;
    -- call keepe to save value calculated to file
    keepe;
    
end calce;