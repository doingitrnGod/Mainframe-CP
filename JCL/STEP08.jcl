//STEP08   JOB (ACCT),'FINAL RPT',CLASS=A,MSGCLASS=X,MSGLEVEL=(1,1)
//*===================================================================
//* STEP 8: FINAL REPORTS
//*===================================================================
//JOBLIB   DD DSN=USERID.ADMIT.LOADLIB,DISP=SHR
//*
//*-------------------------------------------------------------------
//* STEP010: EXECUTE FINALRPT COBOL PROGRAM
//*-------------------------------------------------------------------
//STEP010  EXEC PGM=FINALRPT
//APPIN    DD DSN=USERID.ADMIT.DATA.APPLICANTS,DISP=SHR
//ALLOTIN  DD DSN=USERID.ADMIT.OUTPUT.FINALLOT,DISP=SHR
//FEESTAT  DD DSN=USERID.ADMIT.OUTPUT.FEESTAT,DISP=SHR
//RSLTIN   DD DSN=USERID.ADMIT.OUTPUT.ACADPROC,DISP=SHR
//RPTFILE  DD DSN=USERID.ADMIT.OUTPUT.FINALSUM,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(TRK,(10,2),RLSE),
//            DCB=(LRECL=132,RECFM=FBA,BLKSIZE=13200)
//SYSOUT   DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//*
//*-------------------------------------------------------------------
//* STEP020: EXECUTE REXX SUMMARY SCRIPT
//*-------------------------------------------------------------------
//STEP020  EXEC PGM=IKJEFT01,PARM='%SUMMARY',COND=(4,LT)
//SYSPROC  DD DSN=USERID.ADMIT.REXX,DISP=SHR
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD DUMMY
