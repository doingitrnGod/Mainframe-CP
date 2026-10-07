/* REXX */
/*===================================================================*/
/* SCRIPT: VALIDATE.REXX                                             */
/* PURPOSE: Data Validation and Cross-Checking                       */
/*===================================================================*/
SIGNAL ON ERROR

SAY "--------------------------------------------------------"
SAY "      UNIVERSITY ADMISSION SYSTEM - VALIDATE DATA       "
SAY "--------------------------------------------------------"

/* Mainframe Execution Note: Use EXECIO for I/O             */
/* PC Execution Note: Uncomment DO WHILE LINES(file) > 0    */

fileName = "USERID.ADMIT.OUTPUT.CLEANAPP"
/* PC: fileName = "../OUTPUT/CLEAN-APPS.dat" */

totalCount = 0
validCount = 0
errCount = 0

/* Mainframe-style read */
ADDRESS TSO "ALLOC FI(INFILE) DA('"fileName"') SHR REUSE"
IF RC <> 0 THEN DO
  SAY "ERROR: UNABLE TO ALLOCATE " fileName
  EXIT 8
END

ADDRESS TSO "EXECIO * DISKR INFILE (STEM REC. FINIS)"

IF RC = 0 THEN DO
  DO I = 1 TO REC.0
     line = REC.I
     totalCount = totalCount + 1
     /* Check record length */
     IF LENGTH(STRIP(line, 'T')) < 50 THEN DO
        errCount = errCount + 1
        SAY "WARNING: SHORT RECORD AT LINE " I
     END
     ELSE DO
        validCount = validCount + 1
     END
  END
END

/* PC-style read alternative:
DO WHILE LINES(fileName) > 0
  line = LINEIN(fileName)
  totalCount = totalCount + 1
  ...
END
*/

SAY "RECORDS PROCESSED : " totalCount
SAY "VALID RECORDS     : " validCount
SAY "ERROR RECORDS     : " errCount
SAY "VALIDATION COMPLETE."
ADDRESS TSO "FREE FI(INFILE)"
EXIT 0

ERROR:
  SAY "AN ERROR OCCURRED DURING VALIDATION."
  EXIT 12
