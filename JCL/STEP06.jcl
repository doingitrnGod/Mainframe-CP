//STEP06   JOB (ACCT),'FEE PROC',CLASS=A,MSGCLASS=X,MSGLEVEL=(1,1)
//*===================================================================
//* STEP 6: FEE PROCESSING
//*===================================================================
//JOBLIB   DD DSN=USERID.ADMIT.LOADLIB,DISP=SHR
//*
//*-------------------------------------------------------------------
//* STEP010: SORT FEE PAYMENT FILE BY STUDENT-ID
//*-------------------------------------------------------------------
//STEP010  EXEC PGM=SORT
//SYSOUT   DD SYSOUT=*
//SORTIN   DD DSN=USERID.ADMIT.DATA.FEEPAY,DISP=SHR
//SORTOUT  DD DSN=USERID.ADMIT.OUTPUT.FEESORT,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(2,1),RLSE),
//            DCB=(LRECL=80,RECFM=FB,BLKSIZE=8000)
//SYSIN    DD *
  SORT FIELDS=(1,8,CH,A)
/*
//*
//*-------------------------------------------------------------------
//* STEP020: EXECUTE FEEPROC COBOL PROGRAM
//*-------------------------------------------------------------------
//STEP020  EXEC PGM=FEEPROC,COND=(4,LT)
//ALLOTIN  DD DSN=USERID.ADMIT.OUTPUT.FINALLOT,DISP=SHR
//FEEPAYIN DD DSN=USERID.ADMIT.OUTPUT.FEESORT,DISP=SHR
//FEEOUT   DD DSN=USERID.ADMIT.OUTPUT.FEESTAT,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(5,2),RLSE),
//            DCB=(LRECL=200,RECFM=FB,BLKSIZE=20000)
//RPTFILE  DD DSN=USERID.ADMIT.OUTPUT.FEERPT,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(TRK,(5,1),RLSE),
//            DCB=(LRECL=132,RECFM=FBA,BLKSIZE=13200)
//SYSOUT   DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
