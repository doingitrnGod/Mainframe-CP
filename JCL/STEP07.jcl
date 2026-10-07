//STEP07   JOB (ACCT),'ACAD PROC',CLASS=A,MSGCLASS=X,MSGLEVEL=(1,1)
//*===================================================================
//* STEP 7: ACADEMIC PROCESSING & RESULTS
//*===================================================================
//JOBLIB   DD DSN=USERID.ADMIT.LOADLIB,DISP=SHR
//*
//*-------------------------------------------------------------------
//* STEP010: EXECUTE ACADPROC COBOL PROGRAM
//*-------------------------------------------------------------------
//STEP010  EXEC PGM=ACADPROC
//ACADIN   DD DSN=USERID.ADMIT.DATA.ACADEMIC,DISP=SHR
//FEEIN    DD DSN=USERID.ADMIT.OUTPUT.FEESTAT,DISP=SHR
//ACADOUT  DD DSN=USERID.ADMIT.OUTPUT.ACADPROC,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(5,2),RLSE),
//            DCB=(LRECL=200,RECFM=FB,BLKSIZE=20000)
//RPTFILE  DD DSN=USERID.ADMIT.OUTPUT.ACADRPT,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(TRK,(5,1),RLSE),
//            DCB=(LRECL=132,RECFM=FBA,BLKSIZE=13200)
//SYSOUT   DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//*
//*-------------------------------------------------------------------
//* STEP020: EXECUTE RESULTPR COBOL PROGRAM
//*-------------------------------------------------------------------
//STEP020  EXEC PGM=RESULTPR,COND=(4,LT)
//RESULTIN DD DSN=USERID.ADMIT.OUTPUT.ACADPROC,DISP=SHR
//PASSOUT  DD DSN=USERID.ADMIT.OUTPUT.RESLTPAS,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(2,1),RLSE),
//            DCB=(LRECL=200,RECFM=FB,BLKSIZE=20000)
//FAILOUT  DD DSN=USERID.ADMIT.OUTPUT.RESLTFAI,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(1,1),RLSE),
//            DCB=(LRECL=200,RECFM=FB,BLKSIZE=20000)
//BACKOUT  DD DSN=USERID.ADMIT.OUTPUT.RESLTBAC,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(1,1),RLSE),
//            DCB=(LRECL=200,RECFM=FB,BLKSIZE=20000)
//WITHHOLD DD DSN=USERID.ADMIT.OUTPUT.RESLTWIT,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(1,1),RLSE),
//            DCB=(LRECL=200,RECFM=FB,BLKSIZE=20000)
//RPTFILE  DD DSN=USERID.ADMIT.OUTPUT.RESLTRPT,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(TRK,(5,1),RLSE),
//            DCB=(LRECL=132,RECFM=FBA,BLKSIZE=13200)
//SYSOUT   DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//*
//*-------------------------------------------------------------------
//* STEP030: SORT RESULTS BY PERCENTAGE DESCENDING (Pos 74-78)
//*-------------------------------------------------------------------
//STEP030  EXEC PGM=SORT,COND=(4,LT)
//SYSOUT   DD SYSOUT=*
//SORTIN   DD DSN=USERID.ADMIT.OUTPUT.ACADPROC,DISP=SHR
//SORTOUT  DD DSN=USERID.ADMIT.OUTPUT.RESLTSRT,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(5,2),RLSE),
//            DCB=(LRECL=200,RECFM=FB,BLKSIZE=20000)
//SYSIN    DD *
  SORT FIELDS=(74,5,ZD,D)
/*
