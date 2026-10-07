/* REXX */
/*===================================================================*/
/* SCRIPT: ERRRPT.REXX                                               */
/* PURPOSE: Compile Error/Exception Report                           */
/*===================================================================*/
SIGNAL ON ERROR

SAY "--------------------------------------------------------"
SAY "               CONSOLIDATED ERROR REPORT                "
SAY "--------------------------------------------------------"

rejFile = "USERID.ADMIT.OUTPUT.REJECTED"
ADDRESS TSO "ALLOC FI(REJIN) DA('"rejFile"') SHR REUSE"

IF RC = 0 THEN DO
  ADDRESS TSO "EXECIO * DISKR REJIN (STEM REJ. FINIS)"
  SAY "REJECTED APPLICATIONS:"
  SAY "----------------------"
  DO I = 1 TO REJ.0
     line = REJ.I
     IF STRIP(line) <> "" THEN
       SAY "APP-ID: " SUBSTR(line, 1, 6) " - REASON: INVALID DATA"
  END
  ADDRESS TSO "FREE FI(REJIN)"
END
ELSE DO
  SAY "NO REJECTED DATA FOUND."
END

SAY "--------------------------------------------------------"
SAY "ERROR REPORT COMPLETE."
EXIT 0

ERROR:
  SAY "ERROR IN ERROR REPORT GENERATION."
  EXIT 12
