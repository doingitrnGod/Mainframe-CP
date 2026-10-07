/* REXX */
/*===================================================================*/
/* SCRIPT: RPTGEN.REXX                                               */
/* PURPOSE: Report Generation Utility                                */
/*===================================================================*/
PARSE ARG RPTTYPE

IF RPTTYPE = "" THEN DO
  SAY "PLEASE SPECIFY REPORT TYPE: SEATMATRIX, ALLOTMENT, RESULT"
  EXIT 8
END

SIGNAL ON ERROR

SAY "GENERATING REPORT FOR: " RPTTYPE

SELECT
  WHEN RPTTYPE = "SEATMATRIX" THEN DO
    SAY "================================================"
    SAY "              SEAT MATRIX REPORT                "
    SAY "================================================"
    SAY "COLL-ID | COURSE | SEATS AVAILABLE | FILLED     "
    SAY "------------------------------------------------"
    /* Real implementation reads OUTPUT/SEATMATRIX-R3.dat */
    SAY "C001    | COMP   | 120             | 115        "
    SAY "C001    | IT     | 60              | 60         "
  END
  WHEN RPTTYPE = "ALLOTMENT" THEN DO
    SAY "================================================"
    SAY "              ALLOTMENT LIST                    "
    SAY "================================================"
    SAY "MERIT | STUD-ID  | COLLEGE | COURSE | STATUS    "
    SAY "------------------------------------------------"
    /* Real implementation reads OUTPUT/FINAL-ALLOT.dat */
  END
  WHEN RPTTYPE = "RESULT" THEN DO
    SAY "================================================"
    SAY "              ACADEMIC RESULTS                  "
    SAY "================================================"
    SAY "STUD-ID  | % SCORE | RESULT STATUS              "
    SAY "------------------------------------------------"
    /* Real implementation reads OUTPUT/RESULTS-SORTED.dat */
  END
  OTHERWISE DO
    SAY "UNKNOWN REPORT TYPE."
  END
END

SAY "================================================"
SAY "REPORT GENERATION SUCCESSFUL."
EXIT 0

ERROR:
  SAY "ERROR GENERATING REPORT."
  EXIT 12
