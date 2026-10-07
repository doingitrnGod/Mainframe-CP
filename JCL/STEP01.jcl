//STEP01   JOB (ACCT),'APP PROC',CLASS=A,MSGCLASS=X,MSGLEVEL=(1,1)
//*===================================================================
//* STEP 1: APPLICATION PROCESSING
//*===================================================================
//JOBLIB   DD DSN=USERID.ADMIT.LOADLIB,DISP=SHR
//*
//*-------------------------------------------------------------------
//* STEP010: EXECUTE APPVALID COBOL PROGRAM
//*-------------------------------------------------------------------
//STEP010  EXEC PGM=APPVALID
//* Input: DATA/APPLICANTS.dat
//APPIN    DD DSN=USERID.ADMIT.DATA.APPLICANTS,DISP=SHR
//* Output: OUTPUT/VALID-APPS.dat
//VALIDOUT DD DSN=USERID.ADMIT.OUTPUT.VALIDAPP,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(5,2),RLSE),
//            DCB=(LRECL=200,RECFM=FB,BLKSIZE=20000)
//* Output: OUTPUT/REJECTED.dat
//REJECTOT DD DSN=USERID.ADMIT.OUTPUT.REJECTED,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(1,1),RLSE),
//            DCB=(LRECL=200,RECFM=FB,BLKSIZE=20000)
//* Report: OUTPUT/VALID-RPT.txt
//RPTFILE  DD DSN=USERID.ADMIT.OUTPUT.VALIDRPT,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(TRK,(5,1),RLSE),
//            DCB=(LRECL=132,RECFM=FBA,BLKSIZE=13200)
//SYSOUT   DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//CEEDUMP  DD SYSOUT=*
//*
//*-------------------------------------------------------------------
//* STEP020: SORT TO REMOVE DUPLICATES (STUDENT-ID Pos 7-14)
//*-------------------------------------------------------------------
//STEP020  EXEC PGM=SORT,COND=(4,LT)
//SYSOUT   DD SYSOUT=*
//* Input: OUTPUT/VALID-APPS.dat
//SORTIN   DD DSN=USERID.ADMIT.OUTPUT.VALIDAPP,DISP=SHR
//* Output: OUTPUT/CLEAN-APPS.dat
//CLEANOUT DD DSN=USERID.ADMIT.OUTPUT.CLEANAPP,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(5,2),RLSE),
//            DCB=(LRECL=200,RECFM=FB,BLKSIZE=20000)
//* Output: OUTPUT/DUPES.dat
//DUPEOUT  DD DSN=USERID.ADMIT.OUTPUT.DUPES,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(1,1),RLSE),
//            DCB=(LRECL=200,RECFM=FB,BLKSIZE=20000)
//SYSIN    DD *
  SORT FIELDS=(7,8,CH,A)
  SUM FIELDS=NONE
  OUTFIL FNAMES=CLEANOUT,NODUPS
  OUTFIL FNAMES=DUPEOUT,SAVE
/*
//*
//*-------------------------------------------------------------------
//* STEP030: EXECUTE REXX DUPECHECK FOR DUPLICATE REPORT
//*-------------------------------------------------------------------
//STEP030  EXEC PGM=IKJEFT01,PARM='%DUPECHECK',COND=(4,LT)
//SYSPROC  DD DSN=USERID.ADMIT.REXX,DISP=SHR
//DUPEIN   DD DSN=USERID.ADMIT.OUTPUT.DUPES,DISP=SHR
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD DUMMY
