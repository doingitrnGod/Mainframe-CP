/* REXX */
/*===================================================================*/
/* SCRIPT: DUPECHECK.REXX                                            */
/* PURPOSE: Duplicate Detection Report                               */
/*===================================================================*/
SIGNAL ON ERROR

SAY "--------------------------------------------------------"
SAY "        DUPLICATE APPLICATIONS DETECTION REPORT         "
SAY "--------------------------------------------------------"

dupeFile = "USERID.ADMIT.OUTPUT.DUPES"
/* PC: dupeFile = "../OUTPUT/DUPES.dat" */

ADDRESS TSO "ALLOC FI(DUPEIN) DA('"dupeFile"') SHR REUSE"
IF RC <> 0 THEN DO
  SAY "NO DUPLICATES FILE FOUND OR ALLOC FAILED."
  EXIT 0
END

ADDRESS TSO "EXECIO * DISKR DUPEIN (STEM DUP. FINIS)"
totalDupes = 0

SAY "  STUDENT ID    |   ORIG APP-ID   "
SAY "----------------------------------"

IF RC = 0 THEN DO
  DO I = 1 TO DUP.0
     line = DUP.I
     IF STRIP(line) <> "" THEN DO
        appId = SUBSTR(line, 1, 6)
        studentId = SUBSTR(line, 7, 8)
        SAY "  " studentId "  |   " appId
        totalDupes = totalDupes + 1
     END
  END
END

SAY "----------------------------------"
SAY "TOTAL DUPLICATES FOUND: " totalDupes
SAY "DUPLICATE CHECK COMPLETE."

ADDRESS TSO "FREE FI(DUPEIN)"
EXIT 0

ERROR:
  SAY "ERROR OCCURRED IN DUPECHECK."
  EXIT 12
