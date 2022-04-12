       *> 1095729 - Affan Khan
       *> CIS 3190 - A3 Cobol Re-engineering
       *> isbn.cob
       *> 2022-03-26
       *> this program validates a file filled with ISBNs
       
       identification  division.
       program-id. isbn.
       environment division.
       input-output section.
       file-control.
       select INPUT-FILE assign to WS-FILE-NAME
           organization  is LINE sequential 
           file status  is INP-FS.
       select OUTPUT-FILE assign to "output.txt"
           organization  is LINE sequential.
       
       data division.
       file section.
       fd INPUT-FILE.
           01 INP-REC   pic x(10).
       fd OUTPUT-FILE.
           01 OUT-REC   pic x(80).
       
       working-storage section.
       77 WS-CHK-VLD  pic X VALUE "Y".
       77 WS-CHKSUM-VLD  pic X VALUE "Y".
       77 I           pic 99.
       77 J           pic 99.
       77 WS-CHK-SUM  pic 9(05).
       77 INP-FS      pic X(02).
       77 WS-EOF      pic X VALUE "N".
       77 WS-FILE-NAME pic X(30).
       77 WS-REM      pic 9(2).
       77 WS-DIV      pic 9(5).
       01 WS-ISBN-INP pic X(10).
       01 WS-ISBN-INP-N pic 9(01).
       01 WS-PRNT-REC.
           05 WS-PRNT-ISBN pic X(10).
           05 FILLER       pic X(5) VALUE SPACES.
           05 WS-PRNT-MSG  pic X(65).
       
       procedure division.
       *> prompt user to input a correct file to read and perform from
       main-para.
           display "Enter a file name to read from: "
           accept  WS-FILE-NAME.
           open input INPUT-FILE.
           if INP-FS NOT = "00"
              display "Error: Incorrect file name, please try again."
              perform main-para
           else 
              open output OUTPUT-FILE
              move "N" to WS-EOF
              perform readISBN UNTIL WS-EOF = "Y"
           end-if. 
           close INPUT-FILE.
           close OUTPUT-FILE.
           stop run.
       
       *> read the values of ISBN numbers and process them.
       readISBN.
           initialize  WS-PRNT-REC.
           read INPUT-FILE at end move "Y" to WS-EOF.
           if WS-EOF = "N"
              move INP-REC to WS-ISBN-INP WS-PRNT-ISBN
              perform isValid
              if WS-CHK-VLD = "Y"
                 perform checkSUM
              end-if
           end-if.   
       
       *> Check validity of ISBN, if it containts correct characters
       isValid.
           move "Y" to WS-CHK-VLD
           if WS-ISBN-INP(1:9) IS NOT numeric
              move "incorrect, contains a non-digit" to WS-PRNT-MSG
              write OUT-REC from WS-PRNT-REC
              move "N" to WS-CHK-VLD
           end-if.
           if ((WS-ISBN-INP(10:1) NOT = "X" AND "x") AND
               (WS-ISBN-INP(10:1) IS NOT NUMERIC))
               move "incorrect, contains a non-digit/X in check digit"
                   to WS-PRNT-MSG
               write OUT-REC from WS-PRNT-REC
               move "N" to WS-CHK-VLD
           end-if.
       
       *> Extracts individual digits and calculates the checksum digit
       checkSUM.
           initialize  WS-PRNT-MSG.
           move 0 to J WS-CHK-SUM.
           perform varying I from 10 by -1 until I < 2
                compute J = J + 1
                move WS-ISBN-INP(J : 1) to WS-ISBN-INP-N
               compute WS-CHK-SUM = WS-CHK-SUM + (WS-ISBN-INP-N * I)
           end-perform
           divide WS-CHK-SUM by 11 giving WS-DIV remainder WS-REM.
           if WS-REM <> 0
              subtract 11 from WS-REM
           end-if.
           if WS-REM(2:1) = WS-ISBN-INP(10:1) OR 
              (WS-REM = 10 AND WS-ISBN-INP(10:1) = 'X' OR 'x')
              move "Y" to WS-CHKSUM-VLD
           else
              move "N" to WS-CHKSUM-VLD
           end-if.
           if WS-CHKSUM-VLD = "Y" AND WS-ISBN-INP(1:1) = 0 AND 
              WS-ISBN-INP(10:1) = 0
              move "correct and valid with leading and trailing zero"
                   to WS-PRNT-MSG
           end-if.
           if WS-CHKSUM-VLD = "Y" AND (WS-ISBN-INP(10:1) = "X" OR "x") 
              AND WS-ISBN-INP(1:1) = 0 AND WS-PRNT-MSG = spaces
              move "correct and valid with leading zero, trailing X"
                  to WS-PRNT-MSG
           end-if.
           if WS-CHKSUM-VLD = "Y" AND  WS-ISBN-INP(1:1) = 0 AND
              WS-PRNT-MSG  = spaces
              move "correct and valid with leading zero" to WS-PRNT-MSG
           end-if.
           if WS-CHKSUM-VLD = "Y" AND WS-ISBN-INP(10:1) = 0 AND
              WS-PRNT-MSG = spaces
              move "correct and valid with trailing zero" to WS-PRNT-MSG
           end-if.
           if WS-CHKSUM-VLD = "Y" AND  WS-ISBN-INP(10:1) = "x" AND 
              WS-PRNT-MSG = spaces
              move  "correct and valid with trailing lowercase X"
                      to WS-PRNT-MSG
           end-if.
           if WS-CHKSUM-VLD = "Y" AND WS-ISBN-INP(10:1) ="X" AND
              WS-PRNT-MSG = spaces
              move "correct and valid with trailing uppercase X" 
                       to WS-PRNT-MSG
           end-if.
           if WS-CHKSUM-VLD = "Y" AND WS-PRNT-MSG = spaces
              move "correct and valid" to WS-PRNT-MSG
           end-if.
           if WS-CHKSUM-VLD = "N" AND WS-PRNT-MSG = spaces
              move "correct but not valid (invalid check)"
                         to WS-PRNT-MSG
           end-if.
           write OUT-REC from WS-PRNT-REC.

