      SUBROUTINE SETHALL(ITYPE,INUM,IHALL,TSEC,WIDTH,
     .                   HTEMP,HVEL,HDEPTH)
      include "precis.fi"
      include "cfast.fi"
      include "cenviro.fi"
      include "sizes.fi"
      include "vents.fi"
      include "dervs.fi"

      XX0 = 0.0D0
      HHTEMP = HTEMP - ZZTEMP(IHALL,LOWER)

C*** This routine is only executed if 1) hall flow has not started
C    yet or 2)  hall flow has started and it is coming from the
C    IVENT'th vent

C     gpfrn 4/21/98: change the flow coefficient, based on latest les3d results

      IF(IZHALL(IHALL,IHVENTNUM).NE.0.AND.
     .             IZHALL(IHALL,IHVENTNUM).NE.INUM)RETURN
      ROOMWIDTH = MIN(BR(IHALL),DR(IHALL))
      ROOMLENGTH = MAX(BR(IHALL),DR(IHALL))
      VENTWIDTH = MIN(WIDTH,ROOMWIDTH)
      OTHIRD = 1.0D0/3.0D0
      FRACTION = (VENTWIDTH/ROOMWIDTH)**OTHIRD
      HALLDEPTH = HDEPTH*FRACTION**2
      HALLVEL = HVEL*FRACTION

C*** hall flow has not started yet

      IF(IZHALL(IHALL,IHVENTNUM).EQ.0)THEN

C*** flow is going into the hall room and flow is below the soffit

        IF(HALLVEL.GT.XX0.AND.HALLDEPTH.GT.XX0)THEN
          IZHALL(IHALL,IHVENTNUM) = INUM
          IZHALL(IHALL,IHMODE) = IHDURING
          ZZHALL(IHALL,IHTIME0) = TSEC
          ZZHALL(IHALL,IHTEMP) = HHTEMP
          ZZHALL(IHALL,IHDIST) = 0.0D0
          IF(IZHALL(IHALL,IHVELFLAG).EQ.0)ZZHALL(IHALL,IHVEL) = HALLVEL
          IF(IZHALL(IHALL,IHDEPTHFLAG).EQ.0)THEN
            ZZHALL(IHALL,IHDEPTH) = HALLDEPTH
          ENDIF
          VENTDIST0 = -1.

C*** corridor flow coming from a vent 

          IF(ITYPE.EQ.1)THEN
            IF(IZVENT(INUM,1).EQ.IHALL)THEN
              VENTDIST0 = ZZVENT(INUM,4)
             ELSEIF(IZVENT(INUM,2).EQ.IHALL)THEN
              VENTDIST0 = ZZVENT(INUM,5)
            ENDIF
          ENDIF

C*** corridor flow coming from the main fire.
C    this is a restriction, but lets get it right for the main
C    fire before we worry about objects

          IF(ITYPE.EQ.2)THEN
            IF(IZHALL(IHALL,IHXY).EQ.1)THEN
              VENTDIST0 = XFIRE(1,1)
             ELSE
              VENTDIST0 = XFIRE(1,2)
            ENDIF
          ENDIF
          ZZHALL(IHALL,IHORG) = VENTDIST0

          VENTDIST = -1.0D0
          VENTDISTMAX = VENTDIST 

C*** compute distances relative to vent where flow is coming from.
C    also compute the maximum distance

          DO 10 I = 1, NVENTS
            IF(IZVENT(I,1).EQ.IHALL)THEN

C*** if distances are not defined for the origin or destination vent
C    then assume that the vent at the "far" end of the corridor

              IF(ZZVENT(I,4).GT.0.0D0.AND.VENTDIST0.GE.0.0D0)THEN
                VENTDIST = ABS(ZZVENT(I,4) - VENTDIST0)
               ELSE
                VENTDIST = ROOMLENGTH - VENTDIST0
              ENDIF
              ZZVENTDIST(IHALL,I) = VENTDIST
             ELSEIF(IZVENT(I,2).EQ.IHALL)THEN

C*** if distances are not defined for the origin or destination vent
C    then assume that the vent at the "far" end of the corridor

              IF(ZZVENT(I,5).GT.0.0D0.AND.VENTDIST0.GE.0.0D0)THEN
                VENTDIST = ABS(ZZVENT(I,5) - VENTDIST0)
               ELSE
                VENTDIST = ROOMLENGTH - VENTDIST0
              ENDIF
              ZZVENTDIST(IHALL,I) = VENTDIST
             ELSE
              VENTDIST = -1.0D0
              ZZVENTDIST(IHALL,I) = VENTDIST
            ENDIF
   10     CONTINUE

C***      let the maximum distance that flow in a corridor can flow be
C         the width of the room, ie:

          ZZHALL(IHALL,IHMAXLEN) = ROOMLENGTH - VENTDIST0

          RETURN
        ENDIF
        RETURN
      ENDIF

C*** hall flow is coming from a vent or a fire

      IF(IZHALL(IHALL,IHVENTNUM).EQ.INUM)THEN
        THALL0 = ZZHALL(IHALL,IHTIME0)
        F1 = (TOLD - THALL0)/(STIME-THALL0)
        F2 = (STIME - TOLD)/(STIME-THALL0)
        IF(IZHALL(IHALL,IHVELFLAG).EQ.0)THEN
          ZZHALL(IHALL,IHVEL) = ZZHALL(IHALL,IHVEL)*F1 + ABS(HALLVEL)*F2
        ENDIF
        IF(IZHALL(IHALL,IHDEPTHFLAG).EQ.0)THEN
          ZZHALL(IHALL,IHDEPTH) = ZZHALL(IHALL,IHDEPTH)*F1 + 
     .                            HALLDEPTH*F2
        ENDIF
        ZZHALL(IHALL,IHTEMP) = ZZHALL(IHALL,IHTEMP)*F1 + HHTEMP*F2
        VENTDISTMAX = ZZHALL(IHALL,IHMAXLEN)
        VENTDISTMIN = ROOMLENGTH - VENTDISTMAX
        CJETDIST = ZZHALL(IHALL,IHDIST) + DT*ZZHALL(IHALL,IHVEL)


C*** If ceiling jet has reached the end of the hall then 
C    indicate this fact in IZHALL  

        IF(CJETDIST.GE.VENTDISTMAX)THEN
          IZHALL(IHALL,IHMODE) = IHAFTER
          CJETDIST = VENTDISTMAX
        ENDIF
        ZZHALL(IHALL,IHDIST) = CJETDIST

      ENDIF
      RETURN
      END
