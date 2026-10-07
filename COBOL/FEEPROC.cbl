       IDENTIFICATION DIVISION.
       PROGRAM-ID. FEEPROC.
       AUTHOR. MAINFRAME-BUILDER.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ALLOT-FILE ASSIGN TO 'ALLOTIN'
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-ALLOT-STATUS.
               
           SELECT FEE-IN-FILE ASSIGN TO 'FEEPAYIN'
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-FEEIN-STATUS.
               
           SELECT FEE-OUT-FILE ASSIGN TO 'FEEOUT'
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-FEEOUT-STATUS.
               
           SELECT RPT-FILE ASSIGN TO 'RPTFILE'
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-RPT-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  ALLOT-FILE
           RECORD CONTAINS 250 CHARACTERS
           DATA RECORD IS ALLOT-REC.
       01  ALLOT-REC.
           05  ALLOT-APP-ID         PIC X(06).
           05  ALLOT-MERIT-RANK     PIC 9(04).
           05  ALLOT-STUDENT-ID     PIC X(08).
           05  FILLER               PIC X(103).
           05  ALLOT-STATUS         PIC X(10).
           05  FILLER               PIC X(119).

       FD  FEE-IN-FILE
           RECORD CONTAINS 200 CHARACTERS
           DATA RECORD IS FEE-IN-REC.
       01  FEE-IN-REC.
           05  FILLER               PIC X(200).

       FD  FEE-OUT-FILE
           RECORD CONTAINS 200 CHARACTERS
           DATA RECORD IS FEE-OUT-REC.
       01  FEE-OUT-REC.
           05  F-STUDENT-ID         PIC X(08).
           05  F-APP-ID             PIC X(06).
           05  F-STUDENT-NAME       PIC X(30).
           05  F-COLLEGE-ID         PIC X(04).
           05  F-COURSE-ID          PIC X(04).
           05  F-TUITION-FEE        PIC 9(07).
           05  F-OTHER-FEE          PIC 9(07).
           05  F-TOTAL-FEE          PIC 9(07).
           05  F-AMOUNT-PAID        PIC 9(07).
           05  F-OUTSTANDING        PIC 9(07).
           05  F-PAY-STATUS         PIC X(08).
           05  FILLER               PIC X(105).

       FD  RPT-FILE
           RECORD CONTAINS 132 CHARACTERS
           DATA RECORD IS RPT-REC.
       01  RPT-REC                  PIC X(132).

       WORKING-STORAGE SECTION.
       01  WS-FILE-STATUS-FLAGS.
           05  WS-ALLOT-STATUS      PIC X(02).
           05  WS-FEEIN-STATUS      PIC X(02).
           05  WS-FEEOUT-STATUS     PIC X(02).
           05  WS-RPT-STATUS        PIC X(02).

       01  WS-EOF-FLAGS.
           05  WS-ALLOT-EOF         PIC X(01) VALUE 'N'.
               88  END-OF-ALLOT     VALUE 'Y'.
           05  WS-FEE-EOF           PIC X(01) VALUE 'N'.
               88  END-OF-FEE       VALUE 'Y'.

       01  WS-STUDENT-TABLE.
           05  WS-STUDENT-COUNT     PIC 9(03) VALUE 0.
           05  WS-STUDENTS OCCURS 100 TIMES INDEXED BY IDX-STU.
               10  WS-STU-ID        PIC X(08).

       01  WS-WORK-AREAS.
           05  WS-MATCH-FOUND       PIC X(01) VALUE 'N'.
               88  MATCH-FOUND      VALUE 'Y'.
               88  MATCH-NOT-FOUND  VALUE 'N'.

       01  WS-COUNTERS.
           05  WS-TOT-PROCESSED     PIC 9(04) VALUE 0.
           05  WS-PAID-COUNT        PIC 9(04) VALUE 0.
           05  WS-PARTIAL-COUNT     PIC 9(04) VALUE 0.
           05  WS-PENDING-COUNT     PIC 9(04) VALUE 0.
           05  WS-TOT-PAID-AMT      PIC 9(09) VALUE 0.
           05  WS-TOT-PARTIAL-AMT   PIC 9(09) VALUE 0.
           05  WS-TOT-OUTSTANDING   PIC 9(09) VALUE 0.

       01  WS-FEE-WORK-REC.
           05  WF-STUDENT-ID        PIC X(08).
           05  WF-APP-ID            PIC X(06).
           05  WF-STUDENT-NAME      PIC X(30).
           05  WF-COLLEGE-ID        PIC X(04).
           05  WF-COURSE-ID         PIC X(04).
           05  WF-TUITION-FEE       PIC 9(07).
           05  WF-OTHER-FEE         PIC 9(07).
           05  WF-TOTAL-FEE         PIC 9(07).
           05  WF-AMOUNT-PAID       PIC 9(07).
           05  WF-OUTSTANDING       PIC 9(07).
           05  WF-PAY-STATUS        PIC X(08).
           05  WF-FILLER            PIC X(105).

       01  WS-REPORT-LINES.
           05  RPT-HEADER1.
               10  FILLER           PIC X(45) VALUE SPACES.
               10  FILLER           PIC X(25) VALUE 
                   'FEE PROCESSING REPORT'.
               10  FILLER           PIC X(62) VALUE SPACES.
           05  RPT-HEADER2.
               10  FILLER           PIC X(45) VALUE SPACES.
               10  FILLER           PIC X(25) VALUE 
                   '-------------------------'.
               10  FILLER           PIC X(62) VALUE SPACES.
           05  RPT-DETAIL-LINE.
               10  FILLER           PIC X(10) VALUE SPACES.
               10  RPT-DESC         PIC X(30).
               10  RPT-COUNT        PIC Z,ZZ9.
               10  FILLER           PIC X(10) VALUE SPACES.
               10  RPT-AMOUNT       PIC $$$,$$$,$$9.99.
               10  FILLER           PIC X(63) VALUE SPACES.

       PROCEDURE DIVISION.
       1000-MAIN.
           PERFORM 2000-INIT.
           PERFORM 3000-LOAD-ALLOT-TABLE.
           PERFORM 4000-PROCESS-FEE-RECORDS
               UNTIL END-OF-FEE.
           PERFORM 5000-GENERATE-REPORT.
           PERFORM 9000-CLEANUP.
           STOP RUN.

       2000-INIT.
           OPEN INPUT ALLOT-FILE
           OPEN INPUT FEE-IN-FILE
           OPEN OUTPUT FEE-OUT-FILE
           OPEN OUTPUT RPT-FILE.

       3000-LOAD-ALLOT-TABLE.
           READ ALLOT-FILE
               AT END SET END-OF-ALLOT TO TRUE
           END-READ
           PERFORM UNTIL END-OF-ALLOT
               IF ALLOT-STATUS = 'ALLOTTED  '
                   ADD 1 TO WS-STUDENT-COUNT
                   IF WS-STUDENT-COUNT <= 100
                       MOVE ALLOT-STUDENT-ID 
                         TO WS-STU-ID(WS-STUDENT-COUNT)
                   END-IF
               END-IF
               READ ALLOT-FILE
                   AT END SET END-OF-ALLOT TO TRUE
               END-READ
           END-PERFORM.

       4000-PROCESS-FEE-RECORDS.
           READ FEE-IN-FILE INTO WS-FEE-WORK-REC
               AT END SET END-OF-FEE TO TRUE
           END-READ
           IF NOT END-OF-FEE
               PERFORM 4100-MATCH-AND-PROCESS
           END-IF.

       4100-MATCH-AND-PROCESS.
           SET MATCH-NOT-FOUND TO TRUE
           PERFORM VARYING IDX-STU FROM 1 BY 1 
             UNTIL IDX-STU > WS-STUDENT-COUNT OR MATCH-FOUND
               IF WF-STUDENT-ID = WS-STU-ID(IDX-STU)
                   SET MATCH-FOUND TO TRUE
               END-IF
           END-PERFORM
           
           IF MATCH-FOUND
               COMPUTE WF-OUTSTANDING = WF-TOTAL-FEE - WF-AMOUNT-PAID
               
               IF WF-AMOUNT-PAID = WF-TOTAL-FEE
                   MOVE 'PAID    ' TO WF-PAY-STATUS
                   ADD 1 TO WS-PAID-COUNT
                   ADD WF-AMOUNT-PAID TO WS-TOT-PAID-AMT
               ELSE IF WF-AMOUNT-PAID = 0
                   MOVE 'PENDING ' TO WF-PAY-STATUS
                   ADD 1 TO WS-PENDING-COUNT
               ELSE
                   MOVE 'PARTIAL ' TO WF-PAY-STATUS
                   ADD 1 TO WS-PARTIAL-COUNT
                   ADD WF-AMOUNT-PAID TO WS-TOT-PARTIAL-AMT
               END-IF
               
               ADD 1 TO WS-TOT-PROCESSED
               ADD WF-OUTSTANDING TO WS-TOT-OUTSTANDING
               
               MOVE WS-FEE-WORK-REC TO FEE-OUT-REC
               WRITE FEE-OUT-REC
           END-IF.

       5000-GENERATE-REPORT.
           WRITE RPT-REC FROM RPT-HEADER1
           WRITE RPT-REC FROM RPT-HEADER2
           MOVE SPACES TO RPT-REC
           WRITE RPT-REC
           
           MOVE 'TOTAL STUDENTS PROCESSED:   ' TO RPT-DESC
           MOVE WS-TOT-PROCESSED TO RPT-COUNT
           MOVE ZEROES TO RPT-AMOUNT
           WRITE RPT-REC FROM RPT-DETAIL-LINE
           
           MOVE 'FULLY PAID COUNT & AMOUNT:  ' TO RPT-DESC
           MOVE WS-PAID-COUNT TO RPT-COUNT
           MOVE WS-TOT-PAID-AMT TO RPT-AMOUNT
           WRITE RPT-REC FROM RPT-DETAIL-LINE
           
           MOVE 'PARTIAL PAID COUNT & AMOUNT:' TO RPT-DESC
           MOVE WS-PARTIAL-COUNT TO RPT-COUNT
           MOVE WS-TOT-PARTIAL-AMT TO RPT-AMOUNT
           WRITE RPT-REC FROM RPT-DETAIL-LINE
           
           MOVE 'PENDING COUNT:              ' TO RPT-DESC
           MOVE WS-PENDING-COUNT TO RPT-COUNT
           MOVE ZEROES TO RPT-AMOUNT
           WRITE RPT-REC FROM RPT-DETAIL-LINE
           
           MOVE 'TOTAL OUTSTANDING AMOUNT:   ' TO RPT-DESC
           MOVE ZEROES TO RPT-COUNT
           MOVE WS-TOT-OUTSTANDING TO RPT-AMOUNT
           WRITE RPT-REC FROM RPT-DETAIL-LINE.

       9000-CLEANUP.
           CLOSE ALLOT-FILE
           CLOSE FEE-IN-FILE
           CLOSE FEE-OUT-FILE
           CLOSE RPT-FILE.
