      subroutine SpreadSheetNormal (time, errorcode)

! This routine writes to the {project}_n.csv file, the compartment information and the fires

      use cparams
      use dsize
      use iofiles
      include "precis.fi"
      include "cfast.fi"
      include "cenviro.fi"
      include "cshell.fi"
      include "fltarget.fi"
      include "objects1.fi"

	parameter (maxhead = 1+7*nr+5+7*mxfire)
	character*16 headline(3,maxhead)
	character*16 compartmentlabel(7)
	character*16 firelabel(7)
	real*8 time, outarray(maxhead)
	logical firstc
	integer position, errorcode

	data firstc/.true./
	save firstc

      ! headers
	if (firstc) then
        call ssHeadersNormal
	  firstc = .false.
	endif

	position = 0
      CALL ssaddtolist (position,TIME,outarray)

      ! compartment information
      do i = 1, nm1
          itarg = ntarg - nm1 + i
          izzvol = zzvol(i,upper)/vr(i)*100.d0+0.5d0
          call ssaddtolist (position,zztemp(i,upper)-273.15,outarray)
          if (izshaft(i)==0) then
              call ssaddtolist(position,zztemp(i,lower)-273.15,outarray)
              call ssaddtolist (position,zzhlay(i,lower),outarray)
          endif
          call ssaddtolist (position,zzvol(i,upper),outarray)
          call ssaddtolist (position,zzrelp(i) - pamb(i),outarray)
          call ssaddtolist (position,ontarget(i),outarray)
          call ssaddtolist (position,xxtarg(trgnfluxf,itarg),outarray)
      end do

      ! Fires
      xx0 = 0.0d0
      if (lfmax>0.and.lfbt>0.and.lfbo>0) then
          call flamhgt (fqf(0),farea(0),fheight)
          call ssaddtolist (position,fems(0),outarray)
          call ssaddtolist (position,femp(0),outarray)
          call ssaddtolist (position,fqf(0),outarray)
          call ssaddtolist (position,fheight,outarray)
          call ssaddtolist (position,fqfc(0),outarray)
          call ssaddtolist (position,objmaspy(0),outarray)
          call ssaddtolist (position,radio(0),outarray)
      endif

      if (numobjl/=0) then
          do i = 1, numobjl
              call flamhgt (fqf(i),farea(i),fheight)
              call ssaddtolist (position,fems(i),outarray)
              call ssaddtolist (position,femp(i),outarray)
              call ssaddtolist (position,fqf(i),outarray)
              call ssaddtolist (position,fheight,outarray)
              call ssaddtolist (position,fqfc(i),outarray)
              call ssaddtolist (position,objmaspy(i),outarray)
              call ssaddtolist (position,radio(i),outarray)
          end do
      endif

      CALL SSprintresults (21, position, outarray)

      return
      end subroutine spreadsheetnormal

      subroutine SSaddtolist (ic, valu, array)

      use cparams
      use dsize
      include "precis.fi"
      include "cfast.fi"
      include "cenviro.fi"
      include "cshell.fi"
      include "cfin.fi"

	real*8 array(*), valu
	integer ic

      ic = ic + 1
      ! We are imposing an arbitrary limit of 32000 columns
	if (ic>32000) return
      if (abs(valu)<=1.0d-100) then
          array(ic) = 0.0d0
      else
          array(ic) = valu
      end if
      return
      
      entry SSprintresults (iounit,ic,array)
      
      write (iounit,"(1024(e12.6,','))" ) (array(i),i=1,ic)
      return
      end subroutine SSaddtolist

      SUBROUTINE SpreadSheetFlow (Time, errorcode)

!	Routine to output the flow data to the flow spreadsheet {project}_f.csv

      use cparams
      use dsize
      include "precis.fi"
      include "cfast.fi"
      include "cenviro.fi"
      include "cshell.fi"
      include "vents.fi"

      parameter (maxoutput = 512)
      real*8 time, outarray(maxoutput),sum1,sum2,sum3,sum4,
     .sum5,sum6, flow(6), sumin, sumout
      logical firstc/.true./
      integer position, errorcode
      save firstc

      if (firstc) then
          call ssheadersflow
          firstc = .false.
      endif

      xx0 = 0.0d0
      position = 0

      ! first the time
      call ssaddtolist (position,time,outarray)

      do irm = 1, n

          ! next the horizontal flow through vertical vents
          do j = 1, n
              do k = 1, mxccv
                  i = irm
                  if (iand(1,ishft(nw(i,j),-k))/=0) then
                      iijk = ijk(i,j,k)
                      if (i<j)then
                          sum1 = ss2(iijk) + sa2(iijk)
                          sum2 = ss1(iijk) + sa1(iijk)
                          sum3 = aa2(iijk) + as2(iijk)
                          sum4 = aa1(iijk) + as1(iijk)
                      else
                          sum1 = ss1(iijk) + sa1(iijk)
                          sum2 = ss2(iijk) + sa2(iijk)
                          sum3 = aa1(iijk) + as1(iijk)
                          sum4 = aa2(iijk) + as2(iijk)
                      endif
                      if (j==n) then
                          sumin = sum1 + sum3
                          sumout = sum2 + sum4
                          call ssaddtolist (position,sumin,outarray)
                          call ssaddtolist (position,sumout,outarray)
                      else
                          if (i<j)then
                              sum5 = sau2(iijk)
                              sum6 = asl2(iijk)
                          else
                              sum5 = sau1(iijk)
                              sum6 = asl1(iijk)
                          endif
                          ! we show only net flow in the spreadsheets
                          sumin = sum1 + sum3
                          sumout = sum2 + sum4
                          call ssaddtolist (position,sumin,outarray)
                          call ssaddtolist (position,sumout,outarray)
                          call ssaddtolist (position,sum5,outarray)
                          call ssaddtolist (position,sum6,outarray)
                      endif
                  endif
              end do
          end do

          ! next natural flow through horizontal vents (vertical flow)
          do j = 1, n
              if (nwv(i,j)/=0.or.nwv(j,i)/=0) then
                  do ii = 1, 6
                      flow(ii) = xx0
                  end do
                  if (vmflo(j,i,upper)>=xx0) flow(1) = vmflo(j,i,upper)
                  if (vmflo(j,i,upper)<xx0) flow(2) = -vmflo(j,i,upper)
                  if (vmflo(j,i,lower)>=xx0) flow(3) = vmflo(j,i,lower)
                  if (vmflo(j,i,lower)<xx0) flow(4) = -vmflo(j,i,lower)
                  ! we show only net flow in the spreadsheets
                  sumin = flow(1) + flow(3)
                  sumout = flow(2) + flow(4)
                  call ssaddtolist (position,sumin,outarray)
                  call ssaddtolist (position,sumout,outarray)
              endif
          end do

          ! finally, mechanical ventilation
          if (nnode/=0.and.next/=0) then
              do i = 1, next
                  ii = hvnode(1,i)
                  if (ii==irm) then
                      inode = hvnode(2,i)
                      do iii = 1, 6
                          flow(iii) = xx0
                      end do
                      if (hveflo(upper,i)>=xx0) flow(1)=hveflo(upper,i)
                      if (hveflo(upper,i)<xx0) flow(2)=-hveflo(upper,i)
                      if (hveflo(lower,i)>=xx0) flow(3)=hveflo(lower,i)
                      if (hveflo(lower,i)<xx0) flow(4)=-hveflo(lower,i)
                      sumin = flow(1) + flow(3)
                      sumout = flow(2) + flow(4)
                      flow(5) =abs(tracet(upper,i))+abs(tracet(lower,i))
                      flow(6) =abs(traces(upper,i))+abs(traces(lower,i))
                      call ssaddtolist (position, sumin, outarray)
                      call ssaddtolist (position, sumout, outarray)
                      call ssaddtolist (position, flow(5), outarray)
                      call ssaddtolist (position, flow(6), outarray)
                  endif
              end do
          endif

      end do

	call ssprintresults(22, position, outarray)
	return

	end subroutine SpreadSheetFlow

	subroutine SpreadSheetFlux (Time, errorcode)
	
!     Output the temperatures and fluxes on surfaces and targets at the current time

      use cparams
      use dsize
      include "precis.fi"
      include "cfast.fi"
      include "cenviro.fi"
      include "cshell.fi"
      include "fltarget.fi"

	parameter (maxoutput=512)
	real*8 outarray(maxoutput), time, xiroom, zdetect,
     . tjet, vel, tlink, xact, rtotal, ftotal, wtotal, gtotal,
     . ctotal, tttemp, tctemp, tlay
      integer iwptr(4), errorcode, position
      external length
      data iwptr /1, 3, 4, 2/
      character ctype*5, cact*3
	logical firstc/.true./
	save firstc

	if (firstc) then
		 call ssHeadersFlux
		 firstc = .false.
	endif

      xx0 = 0.0d0
      x100 = 100.0d0

	position = 0

!	First the time

      CALL SSaddtolist (position,TIME,outarray)

!     First the temperatures for each compartment

      do i=1,nm1
        do iw = 1, 4
          call ssaddtolist (position,twj(1,i,iwptr(iw))-273.15,outarray)
        end do
      end do

      ! now do the additional targets if defined
      do i = 1, nm1
          if (ntarg>nm1) then
              do itarg = 1, ntarg-nm1
                  if (ixtarg(trgroom,itarg)==i) then
                      tgtemp = tgtarg(itarg)
                      if (ixtarg(trgeq,itarg)==cylpde) then
                          tttemp = xxtarg(trgtempb,itarg)
                          itctemp = trgtempf+ xxtarg(trginterior,itarg)*
     +                    (trgtempb-trgtempf)
                          tctemp = xxtarg(itctemp,itarg)
                      else
                          tttemp = xxtarg(trgtempf,itarg)
                          itctemp = (trgtempf+trgtempb)/2
                          tctemp = xxtarg(itctemp,itarg)
                      endif
                      if (ixtarg(trgeq,itarg)==ode) tctemp = tttemp
                      if (ixtarg(trgmeth,itarg)==steady) tctemp = tttemp
                      if (validate.or.netheatflux) then
                          total = gtflux(itarg,1) /1000.d0
                          ftotal = gtflux(itarg,2) /1000.d0
                          wtotal = gtflux(itarg,3) /1000.d0
                          gtotal = gtflux(itarg,4) /1000.d0
                          ctotal = gtflux(itarg,5) /1000.d0
                          rtotal = total - ctotal
                      else
                          total = xxtarg(trgtfluxf,itarg)
                          ftotal = qtfflux(itarg,1)
                          wtotal = qtwflux(itarg,1)
                          gtotal = qtgflux(itarg,1)
                          ctotal = qtcflux(itarg,1)
                          rtotal = total - ctotal
                      endif
                      call ssaddtolist (position, tgtemp-273.15, 
     *                 outarray)
                      call ssaddtolist (position, tttemp-273.15, 
     *                 outarray)
                      call ssaddtolist (position, tctemp-273.15, 
     *                 outarray)
                      call ssaddtolist (position, total, outarray)
                      call ssaddtolist (position, ctotal, outarray)
                      call ssaddtolist (position, rtotal, outarray)
                      call ssaddtolist (position, ftotal, outarray)
                      call ssaddtolist (position, wtotal, outarray)
                      call ssaddtolist (position, gtotal, outarray)
                  endif
              end do
          endif
      end do

!     Hallways

c      DO 40 I = 1, NM1
c        IF(IZHALL(I,IHROOM)==0)GO TO 40
c        TSTART = ZZHALL(I,IHTIME0)
c        VEL = ZZHALL(I,IHVEL)
c        DEPTH = ZZHALL(I,IHDEPTH)
c        DIST = ZZHALL(I,IHDIST)
c        IF(DIST>ZZHALL(I,IHMAXLEN))DIST = ZZHALL(I,IHMAXLEN)
c        WRITE(IOFILO,5050)I,TSTART,VEL,DEPTH,DIST
c   40 CONTINUE

      ! detectors (including sprinklers)
      cjetmin = 0.10d0
      do i = 1, ndtect
          iroom = ixdtect(i,droom)
          zdetect = xdtect(i,dzloc)
          if(zdetect>zzhlay(iroom,lower))then
              tlay = zztemp(iroom,upper)
          else	
              tlay = zztemp(iroom,lower)
          endif
          xact = ixdtect(i,dact)
          tjet = max(xdtect(i,dtjet),tlay)
          vel = max(xdtect(i,dvel),cjetmin)
          tlink =  xdtect(i,dtemp)
          call ssaddtolist(position, tlink-273.15, outarray)
          call ssaddtolist(position, xact, outarray)
          call ssaddtolist(position, tjet-273.15, outarray)
          call ssaddtolist(position, vel, outarray)
      end do

	call ssprintresults (24, position, outarray)
      return

 5050 format(4x,i2,7x,1pg10.3,5x,1pg10.3,3x,1pg10.3,5x,1pg10.3)
      end subroutine spreadsheetflux
	
      SUBROUTINE SpreadSheetSpecies (time, errorcode)

!	Write out the species to the spread sheet file

      use cparams
      use dsize
      include "precis.fi"
      include "cfast.fi"
      include "cenviro.fi"
      include "cshell.fi"

	parameter (maxhead = 1+22*nr)
	character*16 heading(3,maxhead)
	real*8 time, outarray(maxhead)
	integer position, errorcode

	integer layer
      logical tooutput(NS)/.false.,5*.true.,.false.,4*.true. /,
     *        firstc/.true./
      logical molfrac(NS) /3*.true.,3*.false.,2*.true.,3*.false./
	
	save outarray, firstc

      ! If there are no species, then don't do the output
	if (nlspct==0) return

      ! Set up the headings
	if (firstc) then
	  call ssHeadersSpecies
		firstc = .false.
	endif

      ! From now on, just the data, please
	position = 0
      CALL SSaddtolist (position,TIME,outarray)

      do i = 1, nm1
          do layer = upper, lower
              do lsp = 1, ns
                  if (layer==upper.or.izshaft(i)==0) then
                      if (tooutput(lsp)) then
                          ssvalue = toxict(i,layer,lsp)
                          if (validate.and.molfrac(lsp)) 
     *                    ssvalue = ssvalue*0.01d0 ! converts ppm to  molar fraction
                          if (validate.and.lsp==9) 
     *                    ssvalue = ssvalue *264.6903 ! converts od to mg/m^3 (see toxict od calculation)
                          call ssaddtolist (position,ssvalue,outarray)
! we can only output to the maximum array size; this is not deemed to be a fatal error!
                          if (position>=maxhead) go to 90
                      endif
                  endif
              end do
          end do
      end do

   90	call SSprintresults (23,position, outarray)

      RETURN

  110	format('Exceeded size of output files in species spread sheet')
      END subroutine SpreadSheetSpecies
      
      SUBROUTINE SpreadSheetSMV (time, errorcode)

! This routine writes to the {project}_zone.csv file, the smokeview information

      use cparams
      use dsize
      use iofiles
      include "precis.fi"
      include "cfast.fi"
      include "cenviro.fi"
      include "cshell.fi"
      include "fltarget.fi"
      include "objects1.fi"
      include "vents.fi"

	parameter (maxhead = 1+7*nr+5+7*mxfire)
	character*16 headline(3,maxhead)
	real*8 time, outarray(maxhead)
	logical firstc
	integer position, errorcode
      integer toprm, botrm
      data toprm /1/, botrm /2/

	data firstc/.true./
	save firstc

      ! Headers
	if (firstc) then
        call ssHeadersSMV(.true.)
	  firstc = .false.
	endif

	position = 0
      CALL SSaddtolist (position,TIME,outarray)

      ! compartment information
      do i = 1, nm1
          itarg = ntarg - nm1 + i
          izzvol = zzvol(i,upper)/vr(i)*100.d0+0.5d0
          call ssaddtolist(position,zztemp(i,upper)-273.15,outarray)
          if (izshaft(i)==0) then
              call ssaddtolist(position,zztemp(i,lower)-273.15,outarray)
              call ssaddtolist(position,zzhlay(i,lower),outarray)
          endif
          call ssaddtolist(position,zzrelp(i) - pamb(i),outarray)
          call ssaddtolist(position,toxict(i,upper,9),outarray)
          if (izshaft(i)==0) then
              call ssaddtolist(position,toxict(i,lower,9),outarray)
          endif
      end do

      ! fires
      xx0 = 0.0d0
      nfire = 0
      if (lfmax>0.and.lfbt>0.and.lfbo>0) then
          nfire = nfire + 1
          call flamhgt (fqf(0),farea(0),fheight)
          call ssaddtolist (position,fqf(0)/1000.,outarray)
          call ssaddtolist (position,fheight,outarray)
          call ssaddtolist (position,xfire(1,3),outarray)
          call ssaddtolist (position,farea(0),outarray)
      endif

      if (numobjl/=0) then
          do i = 1, numobjl
              nfire = nfire + 1
              call flamhgt (fqf(i),farea(i),fheight)
              call ssaddtolist (position,fqf(i)/1000.,outarray)
              call ssaddtolist (position,fheight,outarray)
              call ssaddtolist (position,xfire(nfire,3),outarray)
              call ssaddtolist (position,farea(i),outarray)          
          end do
      endif

      ! vents
      do i = 1, nvents
          iroom1 = izvent(i,1)
          iroom2 = izvent(i,2)
          ik = izvent(i,3)
          im = min(iroom1,iroom2)
          ix = max(iroom1,iroom2)
          factor2 = qchfraction (qcvh, ijk(im,ix,ik),time)
          height = zzvent(i,2) - zzvent(i,1)
          width = zzvent(i,3)
          avent = factor2 * height * width
          call ssaddtolist (position,avent,outarray)       
      end do

      do i = 1, nvvent
          itop = ivvent(i,toprm)
          ibot = ivvent(i,botrm)
          avent = qcvfraction(qcvv, i, tsec) * vvarea(itop,ibot)
          call ssaddtolist (position,avent,outarray)
      end do

      call ssprintresults (15, position, outarray)

      return
      end subroutine SpreadSheetSMV

      integer function rev_outputspreadsheet
          
      INTEGER :: MODULE_REV
      CHARACTER(255) :: MODULE_DATE 
      CHARACTER(255), PARAMETER :: 
     * mainrev='$Revision$'
      CHARACTER(255), PARAMETER :: 
     * maindate='$Date$'
      
      WRITE(module_date,'(A)') 
     *    mainrev(INDEX(mainrev,':')+1:LEN_TRIM(mainrev)-2)
      READ (MODULE_DATE,'(I5)') MODULE_REV
      rev_outputspreadsheet = module_rev
      WRITE(MODULE_DATE,'(A)') maindate
      return
      end function rev_outputspreadsheet