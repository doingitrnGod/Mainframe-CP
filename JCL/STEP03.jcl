//STEP03   JOB (ACCT),'CAP R1',CLASS=A,MSGCLASS=X,MSGLEVEL=(1,1)
//*===================================================================
//* STEP 3: CAP ROUND 1 ALLOTMENT
//*===================================================================
//JOBLIB   DD DSN=USERID.ADMIT.LOADLIB,DISP=SHR
//*
//*-------------------------------------------------------------------
//* STEP010: COPY INITIAL SEAT MATRIX
//*-------------------------------------------------------------------
//STEP010  EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//* Input: DATA/COLLEGES.dat
//SYSUT1   DD DSN=USERID.ADMIT.DATA.COLLEGES,DISP=SHR
//* Output: OUTPUT/SEATMATRIX-R0.dat
//SYSUT2   DD DSN=USERID.ADMIT.OUTPUT.SMATXR0,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(1,1),RLSE),
//            DCB=(LRECL=200,RECFM=FB,BLKSIZE=20000)
//SYSIN    DD DUMMY
//*
//*-------------------------------------------------------------------
//* STEP020: EXECUTE CAPALLOC FOR ROUND 1
//*-------------------------------------------------------------------
//STEP020  EXEC PGM=CAPALLOC,COND=(4,LT)
//MERITIN  DD DSN=USERID.ADMIT.OUTPUT.MERITLST,DISP=SHR
//SEATIN   DD DSN=USERID.ADMIT.OUTPUT.SMATXR0,DISP=SHR
//PREFIN   DD DSN=USERID.ADMIT.DATA.PREFS,DISP=SHR
//PREVALLT DD DUMMY
//ACCEPTIN DD DUMMY
//ALLOTOUT DD DSN=USERID.ADMIT.OUTPUT.ALLOTR1,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(5,2),RLSE),
//            DCB=(LRECL=250,RECFM=FB,BLKSIZE=25000)
//SEATOUT  DD DSN=USERID.ADMIT.OUTPUT.SMATXR1,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(1,1),RLSE),
//            DCB=(LRECL=200,RECFM=FB,BLKSIZE=20000)
//UNALLOT  DD DSN=USERID.ADMIT.OUTPUT.UNALTR1,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(2,1),RLSE),
//            DCB=(LRECL=200,RECFM=FB,BLKSIZE=20000)
//RPTFILE  DD DSN=USERID.ADMIT.OUTPUT.CAP1RPT,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(TRK,(5,1),RLSE),
//            DCB=(LRECL=132,RECFM=FBA,BLKSIZE=13200)
//SYSOUT   DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//*
//*-------------------------------------------------------------------
//* STEP030: SORT ALLOTMENT BY MERIT RANK
//*-------------------------------------------------------------------
//STEP030  EXEC PGM=SORT,COND=(4,LT)
//SYSOUT   DD SYSOUT=*
//SORTIN   DD DSN=USERID.ADMIT.OUTPUT.ALLOTR1,DISP=SHR
//SORTOUT  DD DSN=USERID.ADMIT.OUTPUT.ALR1SORT,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(5,2),RLSE),
//            DCB=(LRECL=250,RECFM=FB,BLKSIZE=25000)
//SYSIN    DD *
  SORT FIELDS=(7,4,CH,A)
/*
