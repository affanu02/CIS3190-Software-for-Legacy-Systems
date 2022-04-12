module FFWIndices
      contains 
      !
      ! FINE FUEL MOISTURE CODE FUNCTIONS
      !
      real function FFMC_after_rain(FO, F, C)
      ! calculate and return FFMC after a rainfaill
      implicit none
            real,intent(in):: FO, F, C
            FFMC_after_rain = (FO/100.)*F+(1.0-C)
      end

      real function log_drying_rate_FFMC(Z, H, W, T)
      ! calculate log drying rate
      implicit none
            real,intent(in):: T
            integer,intent(in):: H,W
            real::Z
            Z = 0.424*(1.0-(H/100.)**1.7) + (0.069*(W**0.5))*(1.0 - (H/100.0)**8)
            log_drying_rate_FFMC = Z*(0.463*(exp(0.0365*T)))
      end

      real function final_moisture_content(ED, WMO, X)
      ! calculate final moisture content
      implicit none
            real,intent(in)::ED, WMO, X
            final_moisture_content = ED + (WMO-ED)/10.0**X
      end

      real function todays_final_moisture_content(EW, WMO)
      ! calculate to todays final moisture content
      implicit none
            real,intent(in):: EW, WMO
            todays_final_moisture_content = EW-(EW-WMO)/1.9953
      end

      real function todays_FFMC(WM)
      ! calculate todays fine fuel moisture code function
      implicit none
            real,intent(in):: WM
            todays_FFMC = 101.0-WM
      end

      real function starting_moisture_content(FR)
      ! calculate starting moisture content
      implicit none
            real,intent(in):: FR
            starting_moisture_content = 101.-FR
      end

      real function rainfall(ro)
      !	defining rain function in FFMC.
      implicit none
            real,intent(in)::ro ! ro is rainfall in open, measured at noon, mm
            if((0.50 < ro).and.(ro <= 1.45))then
                  rainfall = 123.85 - 55.6*alog(ro + 1.016)
            else if((1.45 < ro).and.(ro <= 5.75))then
                  rainfall = 57.87 - 18.2*alog(ro - 1.016)
            else if(ro > 5.75)then
                  rainfall = 40.69 - 8.25*alog(ro - 1.905)
            endif
      end
      
      real function correction(FO)
      !	function evaluates correction term in ffmc rain effect.
      implicit none
            real,intent(in):: FO
            correction = 8.73*exp(-0.1117*FO)
      end
      
      function fine_fuel_emc(H,T,condition) result(ffemc)
      implicit none
            integer,intent(in):: H
            real,intent(in)::T
            character*(*),intent(in):: condition
            real:: ffemc
            if(condition == "drying")then
                  ffemc = 0.942*H**0.679 + 11.0*exp((H-100.)/10.) + &
                  0.18*(21.1-T)*(1.0-exp(-0.115*H))
            else if(condition == "wetting")then
                  ffemc = 0.618*H**0.753 + 10.0*exp((H-100.0)/10.0) + &
                  0.18*(21.1-T)*(1.0-exp(-0.115*H))
            endif
      end
      
      !
      ! DUFF MOISTURE CODE
      !
      real function log_drying_rate(T, H, Le)
      ! find the log drying rate of the duff moisture code
      implicit none
            real,intent(in):: T, Le
            integer,intent(in):: H
            log_drying_rate = 1.894*(T+1.1)*(100.0-H)*(Le*0.0001)
      end

      real function effective_rainfall_Re(RA)
      ! calculate effective rainfall using rainfall in open, measured at noon in mm
      implicit none
            real,intent(in):: RA
            effective_rainfall_Re = 0.92*RA-1.27
      end
      
      real function slope(PO)
      ! calculate slope variable in DMC rain effect
      implicit none
            real,intent(in):: PO
            if(PO .le. 33.) goto 50
            if(PO-65.) 52,52,53
50          slope = 100.0/(0.5+0.3*PO)
            goto 55
52          slope = 14.0-1.3*alog(PO)
            goto 55
53          slope = 6.2*alog(PO)-17.2
55          return
      end

      real function duff_moisture_content(WMI, RW, B, PO)
      ! calculate the duff moisture content after rain
      implicit none
            real,intent(in):: RW, PO
            real:: B, WMI
            B = slope(PO)
            WMI = moisture_content(PO)
            duff_moisture_content = WMI + (1000.*RW)/(48.77+B*RW)
      end

      real function moisture_content(PO)
      ! calculate moisture content
      implicit none
            real,intent(in):: PO
            moisture_content = 20.0+280./exp(0.023*PO)
      end
      
      real function DMC_after_rain(WMR)
      ! Calculate Pr with DMC after rain
      implicit none
            real,intent(in):: WMR
            DMC_after_rain = 43.43*(5.6348-alog(WMR-20.0))
      end
      

      !
      ! DROUGHT CODE
      !
      real function calculate_Qo_from_Do(DOT)
      ! function cacluates and converts moisture equivalent of DC with DC
      implicit none
            real,intent(in)::DOT
            calculate_Qo_from_Do = 800.0*exp(-DOT/400.)
      end

      real function evaportranspiration(T, Lf)
      ! function calculates the potential evaportranspiration
      implicit none
            real,intent(in)::Lf
            real::T
            if((T+2.8).ge.(0.)) goto 65
            T = -2.8
65          evaportranspiration = (.36*(T+2.8)+Lf)/2.0
      end

      real function effective_rainfall(RA)
      ! calculate effective rainfall with rainfall in open, measured at noon in mm
      implicit none
            real,intent(in):: RA
            effective_rainfall = 0.83*RA-1.27
      end

      real function DC_after_rain(DOT, RW, SMI, RA)
      ! calculates Dr, the drought code (DC) after rain by calculating effective rainfall 
      ! and moisture equivalent of DC
      implicit none
            real,intent(in):: DOT, RA
            real:: SMI, RW
            RW = effective_rainfall(RA)
            SMI = calculate_Qo_from_Do(DOT)
            DC_after_rain = DOT - 400.0*alog(1.0+((3.937*RW)/SMI))
      end

      !
      ! INDEXES CODE FUNCTIONS
      !
      real function ISI_calculator(FM, FFM, SF, W)
      ! calculate ISI
      implicit none
            real,intent(in):: FFM
            integer,intent(in):: W
            real:: FM, SF
            FM = 101.0-FFM
            SF = 19.115*exp(-0.1386*FM)*(1.0+FM**4.65/7950000.)
            ISI_calculator = SF*exp(0.05039*W)
      end

      real function BUI_Calculator(DC, DMC)
      !calculates BUI for index functions
      implicit none
            real,intent(in):: DC, DMC
            BUI_Calculator = (0.8*DC*DMC)/(DMC+0.4*DC)
      end

      real function BUI_Recalculate(CC, DMC, P, BUI)
      ! recalculate BUI if BUI is greater than or equal
      implicit none
            real,intent(in):: DMC, BUI
            real:: CC, P
            P = (DMC-BUI)/DMC
            CC = 0.95+(0.0114*DMC)**1.7
            BUI_Recalculate = DMC-(CC*P)
      end

      real function intermediate_form_FWI(SI, BUI)
      ! calculate intermediate form of FWI
      implicit none
            real,intent(in):: SI, BUI
            if(BUI .lt. 0.0) goto 60
            intermediate_form_FWI = 0.1*SI*(0.626*BUI**0.809+2.0)
            goto 91
60          intermediate_form_FWI = 0.1*SI*(1000.0/(25.0+108.64/exp(0.023*BUI)))
91          return
      end

      real function final_log_FWI(BB)
      ! calculate final FWI using log
      implicit none
            real,intent(in):: BB
            final_log_FWI = 2.72*(0.43*alog(BB))**0.647
      end

      integer function simplifiy_add_decimal(DC,FFM,DMC,SI,BUI,FWI,IFFM,IDMC,IDC,ISI,IBUI)
      ! adds a decimal(0.5) to multiple variables to simplify the main program file
      implicit none
            real,intent(in):: DC,FFM,DMC,SI,BUI,FWI
            integer:: IFFM,IDMC,IDC,ISI,IBUI
            IDC = int(DC+0.5)
            IFFM = int(FFM+0.5)
            IDMC = int(DMC+0.5)
            ISI = int(SI+0.5)
            IBUI = int(BUI+0.5)
            simplifiy_add_decimal = int(FWI+0.5)
      end

end module FFWIndices
      