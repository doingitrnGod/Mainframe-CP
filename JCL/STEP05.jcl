//STEP05   JOB (ACCT),'CAP R3 FIN',CLASS=A,MSGCLASS=X,MSGLEVEL=(1,1)
//*===================================================================
//* STEP 5: CAP ROUND 3 & FINAL LISTS
//*===================================================================
//JOBLIB   DD DSN=USERID.ADMIT.LOADLIB,DISP=SHR
//*
//*-------------------------------------------------------------------
//* STEP010: EXECUTE CAPALLOC FOR ROUND 3
//*-------------------------------------------------------------------
//STEP010  EXEC PGM=CAPALLOC
//MERITIN  DD DSN=USERID.ADMIT.OUTPUT.MERITLST,DISP=SHR
//SEATIN   DD DSN=USERID.ADMIT.OUTPUT.SMATXR2,DISP=SHR
//PREFIN   DD DSN=USERID.ADMIT.DATA.PREFS,DISP=SHR
//PREVALLT DD DSN=USERID.ADMIT.OUTPUT.ALR2SORT,DISP=SHR
//ACCEPTIN DD DSN=USERID.ADMIT.DATA.ACCEPT2,DISP=SHR
//ALLOTOUT DD DSN=USERID.ADMIT.OUTPUT.ALLOTR3,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(5,2),RLSE),
//            DCB=(LRECL=250,RECFM=FB,BLKSIZE=25000)
//SEATOUT  DD DSN=USERID.ADMIT.OUTPUT.SMATXR3,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(1,1),RLSE),
//            DCB=(LRECL=200,RECFM=FB,BLKSIZE=20000)
//UNALLOT  DD DSN=USERID.ADMIT.OUTPUT.UNALTR3,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(2,1),RLSE),
//            DCB=(LRECL=200,RECFM=FB,BLKSIZE=20000)
//RPTFILE  DD DSN=USERID.ADMIT.OUTPUT.CAP3RPT,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(TRK,(5,1),RLSE),
//            DCB=(LRECL=132,RECFM=FBA,BLKSIZE=13200)
//SYSOUT   DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//*
//*-------------------------------------------------------------------
//* STEP020: SORT ROUND 3 ALLOTMENT BY MERIT RANK
//*-------------------------------------------------------------------
//STEP020  EXEC PGM=SORT,COND=(4,LT)
//SYSOUT   DD SYSOUT=*
//SORTIN   DD DSN=USERID.ADMIT.OUTPUT.ALLOTR3,DISP=SHR
//SORTOUT  DD DSN=USERID.ADMIT.OUTPUT.ALR3SORT,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(5,2),RLSE),
//            DCB=(LRECL=250,RECFM=FB,BLKSIZE=25000)
//SYSIN    DD *
  SORT FIELDS=(7,4,CH,A)
/*
//*
//*-------------------------------------------------------------------
//* STEP030: GENERATE FINAL ALLOTMENT (EXTRACT ALLOTTED)
//*-------------------------------------------------------------------
//STEP030  EXEC PGM=SORT,COND=(4,LT)
//SYSOUT   DD SYSOUT=*
//SORTIN   DD DSN=USERID.ADMIT.OUTPUT.ALR3SORT,DISP=SHR
//SORTOUT  DD DSN=USERID.ADMIT.OUTPUT.FINALLOT,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(5,2),RLSE),
//            DCB=(LRECL=250,RECFM=FB,BLKSIZE=25000)
//SYSIN    DD *
  SORT FIELDS=COPY
  INCLUDE COND=(122,10,CH,EQ,C'ALLOTTED  ')
/*
//*
//*-------------------------------------------------------------------
//* STEP040: GENERATE UNALLOTTED LIST
//*-------------------------------------------------------------------
//STEP040  EXEC PGM=SORT,COND=(4,LT)
//SYSOUT   DD SYSOUT=*
//SORTIN   DD DSN=USERID.ADMIT.OUTPUT.ALR3SORT,DISP=SHR
//SORTOUT  DD DSN=USERID.ADMIT.OUTPUT.FINUNAL,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(2,1),RLSE),
//            DCB=(LRECL=250,RECFM=FB,BLKSIZE=25000)
//SYSIN    DD *
  SORT FIELDS=COPY
  INCLUDE COND=(122,10,CH,EQ,C'UNALLOTTED')
/*
//*
//*-------------------------------------------------------------------
//* STEP050: GENERATE REMAINING VACANCY
//*-------------------------------------------------------------------
//STEP050  EXEC PGM=IEBGENER,COND=(4,LT)
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD DSN=USERID.ADMIT.OUTPUT.SMATXR3,DISP=SHR
//SYSUT2   DD DSN=USERID.ADMIT.OUTPUT.VACANCY,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(1,1),RLSE),
//            DCB=(LRECL=200,RECFM=FB,BLKSIZE=20000)
//SYSIN    DD DUMMY
