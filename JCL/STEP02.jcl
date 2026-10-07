//STEP02   JOB (ACCT),'MERIT GEN',CLASS=A,MSGCLASS=X,MSGLEVEL=(1,1)
//*===================================================================
//* STEP 2: MERIT LIST GENERATION
//*===================================================================
//JOBLIB   DD DSN=USERID.ADMIT.LOADLIB,DISP=SHR
//*
//*-------------------------------------------------------------------
//* STEP010: SORT CLEAN APPLICATIONS BY CET-SCORE DESC, ID ASC
//*-------------------------------------------------------------------
//STEP010  EXEC PGM=SORT
//SYSOUT   DD SYSOUT=*
//* Input: OUTPUT/CLEAN-APPS.dat
//SORTIN   DD DSN=USERID.ADMIT.OUTPUT.CLEANAPP,DISP=SHR
//* Output: OUTPUT/SORTED-APPS.dat
//SORTOUT  DD DSN=USERID.ADMIT.OUTPUT.SORTAPP,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(5,2),RLSE),
//            DCB=(LRECL=200,RECFM=FB,BLKSIZE=20000)
//SYSIN    DD *
  SORT FIELDS=(45,3,ZD,D,7,8,CH,A)
/*
//*
//*-------------------------------------------------------------------
//* STEP020: EXECUTE MERITGEN COBOL PROGRAM
//*-------------------------------------------------------------------
//STEP020  EXEC PGM=MERITGEN,COND=(4,LT)
//* Input: OUTPUT/SORTED-APPS.dat
//MERITIN  DD DSN=USERID.ADMIT.OUTPUT.SORTAPP,DISP=SHR
//* Output: OUTPUT/MERITLIST.dat
//MERITOUT DD DSN=USERID.ADMIT.OUTPUT.MERITLST,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(5,2),RLSE),
//            DCB=(LRECL=200,RECFM=FB,BLKSIZE=20000)
//* Report: OUTPUT/MERIT-RPT.txt
//MERITRPT DD DSN=USERID.ADMIT.OUTPUT.MERITRPT,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(TRK,(5,1),RLSE),
//            DCB=(LRECL=132,RECFM=FBA,BLKSIZE=13200)
//SYSOUT   DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//CEEDUMP  DD SYSOUT=*
