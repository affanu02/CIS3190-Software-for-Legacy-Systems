program file_read
use FFWIndices      
implicit none
      ! variables used throughout calculations
      integer:: LMON(12), i, j, M, NDAYS, NN, IDAYs, L, H, IH, W, IW
      real:: EL(12), FL(12), FR, FO, PO, DOT, T, TX, R, RA, RAIN, F, C, WM, WMO, ED, EW, Z 
      real:: X, FFM, RK, PR, RW, WMI, B, WMR, DMC, PE, SMI, DR, DC, FM, SF, SI, BUI, P, CC
      real:: BB, SL, FWI 
      integer:: IFFM,IDMC,IDC,ISI,IBUI,IFWI
      character(len = 100) :: inputFile, outputFile
      logical :: lexist

      ! prompt user for input and output file through subroutines
7     call get_file_name(inputFile)
      call check_file_exists(inputFile, lexist)
      call get_output_file_name(outputFile)

      ! if file does not exist, ask user again for file name
      if(.not. lexist) go to 7

      ! open both files for reading and writing
      open(100, file = trim(inputFile), action = "read", err = 2000)
      open(200, file = trim(outputFile), action = "write")

      ! reads length of months, and day length factors.
      do j = 1,12
            read(100,100)LMON(j),EL(j),FL(j)
      enddo

      ! reads initial values of ffmc, dmc, dc starting month and number of days of data in starting month.
      read(100,*)FO, PO, DOT, M, NDAYS

      ! loop through each day for the month 
      do j = M,12
            NN = LMON(j)
            if(j.eq.M) goto 304
            IDAYS = 1
            goto 302
304         IDAYS = LMON(j)-NDAYS+1
302         L = 0

            ! reads daily weather data.
            do i = IDAYS,NN
                  L = L + 1
                  read(100,101,end = 2000)T,IH,IW,R
                  if(L .ne. 1.) goto 301
                  write(200,1002)
301               TX = T
                  H = IH
                  W = IW
                  RAIN = R

                  !
                  ! FINE FUEL MOISTURE CODE
                  !
                  if(R .gt. 0.5) goto 10
                  R = 0.0
                  FR = FO
                  goto 150
10                RA = R
                  if(RA .le. 1.45) goto 6
                  if(RA-5.75)9,9,12
6                 F = rainfall(RA)
                  goto 13
9                 F = rainfall(RA)
                  goto 13
12                F = rainfall(RA)
13                C = correction(FO)
                  FR = FFMC_after_rain(FO, F, C)
                  if(FR .ge. 0.) goto 150
                  FR = 0.0
150               WMO = starting_moisture_content(FR)
                  ED = fine_fuel_emc(H,T,"drying")
                  if(WMO-ED) 26,27,28
26                EW = fine_fuel_emc(H,T,"wetting")
                  if(WMO.lt.EW) goto 29
27                WM = WMO
                  goto 30
28                X = log_drying_rate_FFMC(Z,H,W,T)
                  WM = final_moisture_content(ED,WMO,X)
                  goto 30
29                WM = todays_final_moisture_content(EW, WMO)
30                FFM = todays_FFMC(WM)
                  if(FFM .gt. 101.0) goto 32
                  if(FFM)33,34,34
32                FFM = 101.
                  goto 34
33                FFM = 0.0

                  !
                  !	DUFF MOISTURE CODE
                  !
34                if((T+1.1).ge. 0.0) goto 41
                  T = -1.1
41                RK = log_drying_rate(T, H, EL(j))
                  if(R .gt. 1.5) goto 45
                  PR = PO
                  goto 250
45                RA = R
                  RW = effective_rainfall_Re(RA)
                  WMR = duff_moisture_content(WMI, RW, B, PO)
                  PR = DMC_after_rain(WMR)
250               if(PR .ge. 0.) goto 61
                  PR = 0.0
61                DMC = PR+RK

                  !
                  !	DROUGHT CODE
                  !
                  PE = evaportranspiration(T,FL(j))
                  if(R .le. 2.8) goto 300
                  RA = R
                  DR = DC_after_rain(DOT, RW, SMI, RA)
                  if(DR .gt. 0.) goto 83
                  DR = 0.0
83                DC = DR + PE
                  goto 350
300               DR = DOT
                  goto 83
350               if(DC .ge. 0.) goto 85
                  DC = 0.0

                  !
                  !	INITIAL SPREAD INDEX, BUILDUP INDEX, FIRE WEATHER INDEX
                  !
85                SI = ISI_calculator(FM, FFM, SF, W)
                  BUI = BUI_Calculator(DC, DMC)
                  if(BUI.ge.DMC) goto 95
                  BUI = BUI_Recalculate(CC, DMC, P, BUI)
                  if(BUI .lt. 0.) BUI = 0.0
95                BB = intermediate_form_FWI(SI, BUI)
                  if((BB-1.0).le.(0.0)) goto 98
                  SL = final_log_FWI(BB)
                  FWI = exp(SL)
                  goto 400
98                FWI = BB
400               IFWI = simplifiy_add_decimal(DC,FFM,DMC,SI,BUI,FWI,IFFM,IDMC,IDC,ISI,IBUI)
                  write(200,1001)j,i,TX,IH,IW,RAIN,IFFM,IDMC,IDC,ISI,IBUI,IFWI
                  FO = FFM
                  PO = DMC
                  DOT = DC
            enddo
      enddo

      ! close files
      close(200)
      close(100)

      ! formatting specifications for writing to output files
2000  stop      
100   format(i2,2f4.1)
1002  format(10(/),1x,'  DATE   TEMP  RH  WIND  RAIN   FFMC   DMC    DC   ISI   BUI   FWI')
101   format(f4.1,2i4,f4.1)
1001  format(1x,2i3,f6.1,i4,i6,f7.1,6i6)
end program file_read

! subprogram to get user input file
subroutine get_file_name(inputFile)
implicit none
      character(100) :: inputFile
      write(*,*) 'Enter the file to read: '
      read(*,'(A)') inputFile
      return
end subroutine get_file_name

! subroutine to get user output file
subroutine get_output_file_name(outputFile)
implicit none
      character(100) :: outputFile
      write(*,*) 'Enter file to write data to: '
      read(*,'(A)') outputFile
      return
end subroutine get_output_file_name

! check if file exists
subroutine check_file_exists(inputFile, lexist)
implicit none
      character(100) :: inputFile
      logical :: lexist
      inquire(file=inputFile, exist=lexist)
      if(.not. lexist)then
            write(*,*) 'File does NOT exist, Please re-enter correct fileName: '
      end if
      return
end subroutine check_file_exists