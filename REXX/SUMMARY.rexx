/* REXX */
/*===================================================================*/
/* SCRIPT: SUMMARY.REXX                                              */
/* PURPOSE: Processing Summary Generator                             */
/* READS ACTUAL OUTPUT FILES AND COMPUTES STATISTICS                  */
/*===================================================================*/
SIGNAL ON ERROR

SAY "============================================================"
SAY "  CENTRALIZED UNIVERSITY ADMISSION SYSTEM"
SAY "  FINAL PROCESSING SUMMARY REPORT"
SAY "============================================================"
SAY ""

/*-------------------------------------------------------------------*/
/* 1. APPLICATION PROCESSING SUMMARY                                 */
/*-------------------------------------------------------------------*/
SAY "1. APPLICATION PROCESSING"
SAY "------------------------------------------------------------"

/* Read raw applications */
rawFile = "USERID.ADMIT.DATA.APPLICANTS"
ADDRESS TSO "ALLOC FI(RAWIN) DA('"rawFile"') SHR REUSE"
ADDRESS TSO "EXECIO * DISKR RAWIN (STEM RAW. FINIS)"
totalApps = RAW.0
SAY "   Total Applications Received  :" RIGHT(totalApps, 6)
ADDRESS TSO "FREE FI(RAWIN)"

/* Read rejected applications */
rejFile = "USERID.ADMIT.OUTPUT.REJECTED"
ADDRESS TSO "ALLOC FI(REJIN) DA('"rejFile"') SHR REUSE"
ADDRESS TSO "EXECIO * DISKR REJIN (STEM REJ. FINIS)"
rejCount = REJ.0
SAY "   Invalid/Rejected Applications:" RIGHT(rejCount, 6)
ADDRESS TSO "FREE FI(REJIN)"

/* Read duplicates file */
dupFile = "USERID.ADMIT.OUTPUT.DUPES"
ADDRESS TSO "ALLOC FI(DUPIN) DA('"dupFile"') SHR REUSE"
ADDRESS TSO "EXECIO * DISKR DUPIN (STEM DUP. FINIS)"
dupCount = DUP.0
SAY "   Duplicate Applications Removed:" RIGHT(dupCount, 6)
ADDRESS TSO "FREE FI(DUPIN)"

/* Read clean applications */
cleanFile = "USERID.ADMIT.OUTPUT.CLEANAPP"
ADDRESS TSO "ALLOC FI(CLNIN) DA('"cleanFile"') SHR REUSE"
ADDRESS TSO "EXECIO * DISKR CLNIN (STEM CLN. FINIS)"
eligCount = CLN.0
SAY "   Eligible Candidates (Clean)  :" RIGHT(eligCount, 6)
ADDRESS TSO "FREE FI(CLNIN)"
SAY ""

/*-------------------------------------------------------------------*/
/* 2. CAP ROUND ALLOCATION SUMMARY                                   */
/*-------------------------------------------------------------------*/
SAY "2. CAP ROUND ALLOCATION"
SAY "------------------------------------------------------------"

/* Round 1 */
r1File = "USERID.ADMIT.OUTPUT.ALLOTR1"
ADDRESS TSO "ALLOC FI(R1IN) DA('"r1File"') SHR REUSE"
ADDRESS TSO "EXECIO * DISKR R1IN (STEM R1. FINIS)"
r1Allot = 0
r1Unallot = 0
DO I = 1 TO R1.0
   status = SUBSTR(R1.I, 122, 10)
   IF STRIP(status) = "ALLOTTED" THEN r1Allot = r1Allot + 1
   ELSE r1Unallot = r1Unallot + 1
END
SAY "   Round 1 - Allotted           :" RIGHT(r1Allot, 6)
SAY "   Round 1 - Unallotted         :" RIGHT(r1Unallot, 6)
ADDRESS TSO "FREE FI(R1IN)"

/* Round 2 */
r2File = "USERID.ADMIT.OUTPUT.ALLOTR2"
ADDRESS TSO "ALLOC FI(R2IN) DA('"r2File"') SHR REUSE"
ADDRESS TSO "EXECIO * DISKR R2IN (STEM R2. FINIS)"
r2Allot = 0
r2Unallot = 0
r2Better = 0
DO I = 1 TO R2.0
   status = SUBSTR(R2.I, 122, 10)
   IF STRIP(status) = "ALLOTTED" THEN r2Allot = r2Allot + 1
   ELSE IF STRIP(status) = "BETTERMENT" THEN DO
      r2Allot = r2Allot + 1
      r2Better = r2Better + 1
   END
   ELSE r2Unallot = r2Unallot + 1
END
SAY "   Round 2 - Allotted           :" RIGHT(r2Allot, 6)
SAY "   Round 2 - Unallotted         :" RIGHT(r2Unallot, 6)
SAY "   Round 2 - Betterment Cases   :" RIGHT(r2Better, 6)
ADDRESS TSO "FREE FI(R2IN)"

/* Round 3 */
r3File = "USERID.ADMIT.OUTPUT.ALLOTR3"
ADDRESS TSO "ALLOC FI(R3IN) DA('"r3File"') SHR REUSE"
ADDRESS TSO "EXECIO * DISKR R3IN (STEM R3. FINIS)"
r3Allot = 0
r3Unallot = 0
r3Better = 0
DO I = 1 TO R3.0
   status = SUBSTR(R3.I, 122, 10)
   IF STRIP(status) = "ALLOTTED" THEN r3Allot = r3Allot + 1
   ELSE IF STRIP(status) = "BETTERMENT" THEN DO
      r3Allot = r3Allot + 1
      r3Better = r3Better + 1
   END
   ELSE r3Unallot = r3Unallot + 1
END
SAY "   Round 3 - Allotted           :" RIGHT(r3Allot, 6)
SAY "   Round 3 - Unallotted         :" RIGHT(r3Unallot, 6)
SAY "   Round 3 - Betterment Cases   :" RIGHT(r3Better, 6)
ADDRESS TSO "FREE FI(R3IN)"
SAY ""

/*-------------------------------------------------------------------*/
/* 3. FINAL ALLOTMENT SUMMARY                                        */
/*-------------------------------------------------------------------*/
SAY "3. FINAL ALLOTMENT"
SAY "------------------------------------------------------------"

finFile = "USERID.ADMIT.OUTPUT.FINALLOT"
ADDRESS TSO "ALLOC FI(FNIN) DA('"finFile"') SHR REUSE"
ADDRESS TSO "EXECIO * DISKR FNIN (STEM FN. FINIS)"
finalAllot = FN.0
SAY "   Total Finally Allotted       :" RIGHT(finalAllot, 6)
ADDRESS TSO "FREE FI(FNIN)"

unFile = "USERID.ADMIT.OUTPUT.FINALUNA"
ADDRESS TSO "ALLOC FI(UNIN) DA('"unFile"') SHR REUSE"
ADDRESS TSO "EXECIO * DISKR UNIN (STEM UN. FINIS)"
finalUnallot = UN.0
SAY "   Total Finally Unallotted     :" RIGHT(finalUnallot, 6)
ADDRESS TSO "FREE FI(UNIN)"
SAY ""

/*-------------------------------------------------------------------*/
/* 4. FEE PROCESSING SUMMARY                                        */
/*-------------------------------------------------------------------*/
SAY "4. FEE PROCESSING"
SAY "------------------------------------------------------------"

feeFile = "USERID.ADMIT.OUTPUT.FEESTAT"
ADDRESS TSO "ALLOC FI(FEEIN) DA('"feeFile"') SHR REUSE"
ADDRESS TSO "EXECIO * DISKR FEEIN (STEM FEE. FINIS)"
feePaid = 0
feePartial = 0
feePending = 0
DO I = 1 TO FEE.0
   payStatus = SUBSTR(FEE.I, 88, 8)
   IF STRIP(payStatus) = "PAID" THEN feePaid = feePaid + 1
   ELSE IF STRIP(payStatus) = "PARTIAL" THEN feePartial = feePartial + 1
   ELSE IF STRIP(payStatus) = "PENDING" THEN feePending = feePending + 1
END
SAY "   PAID                         :" RIGHT(feePaid, 6)
SAY "   PARTIAL                      :" RIGHT(feePartial, 6)
SAY "   PENDING                      :" RIGHT(feePending, 6)
ADDRESS TSO "FREE FI(FEEIN)"
SAY ""

/*-------------------------------------------------------------------*/
/* 5. ACADEMIC RESULT SUMMARY                                        */
/*-------------------------------------------------------------------*/
SAY "5. ACADEMIC RESULTS"
SAY "------------------------------------------------------------"

resFile = "USERID.ADMIT.OUTPUT.ACADPROC"
ADDRESS TSO "ALLOC FI(RESIN) DA('"resFile"') SHR REUSE"
ADDRESS TSO "EXECIO * DISKR RESIN (STEM RES. FINIS)"
resPass = 0
resFail = 0
resBack = 0
resHeld = 0
DO I = 1 TO RES.0
   resStat = SUBSTR(RES.I, 83, 8)
   IF STRIP(resStat) = "PASS" THEN resPass = resPass + 1
   ELSE IF STRIP(resStat) = "FAIL" THEN resFail = resFail + 1
   ELSE IF STRIP(resStat) = "BACKLOG" THEN resBack = resBack + 1
   ELSE IF STRIP(resStat) = "WITHHELD" THEN resHeld = resHeld + 1
END
SAY "   PASS                         :" RIGHT(resPass, 6)
SAY "   FAIL                         :" RIGHT(resFail, 6)
SAY "   BACKLOG                      :" RIGHT(resBack, 6)
SAY "   WITHHELD                     :" RIGHT(resHeld, 6)
ADDRESS TSO "FREE FI(RESIN)"
SAY ""

SAY "============================================================"
SAY "  PROCESSING SUMMARY REPORT GENERATION COMPLETE"
SAY "============================================================"

EXIT 0

ERROR:
  SAY "ERROR GENERATING SUMMARY REPORT. RC =" RC
  EXIT 12
