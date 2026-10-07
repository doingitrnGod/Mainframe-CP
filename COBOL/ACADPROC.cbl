       IDENTIFICATION DIVISION.
       PROGRAM-ID. ACADPROC.
       AUTHOR. MAINFRAME-BUILDER.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACAD-IN-FILE ASSIGN TO 'ACADIN'
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-ACADIN-STATUS.
               
           SELECT FEE-IN-FILE ASSIGN TO 'FEEIN'
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-FEEIN-STATUS.
               
           SELECT ACAD-OUT-FILE ASSIGN TO 'ACADOUT'
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-ACADOUT-STATUS.
               
           SELECT RPT-FILE ASSIGN TO 'RPTFILE'
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-RPT-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  ACAD-IN-FILE
           RECORD CONTAINS 250 CHARACTERS
           DATA RECORD IS ACAD-IN-REC.
       01  ACAD-IN-REC              PIC X(250).

       FD  FEE-IN-FILE
           RECORD CONTAINS 200 CHARACTERS
           DATA RECORD IS FEE-IN-REC.
       01  FEE-IN-REC.
           05  FEE-STUDENT-ID       PIC X(08).
           05  FILLER               PIC X(79).
           05  FEE-PAY-STATUS       PIC X(08).
           05  FILLER               PIC X(105).

       FD  ACAD-OUT-FILE
           RECORD CONTAINS 250 CHARACTERS
           DATA RECORD IS ACAD-OUT-REC.
       01  ACAD-OUT-REC             PIC X(250).

       FD  RPT-FILE
           RECORD CONTAINS 132 CHARACTERS
           DATA RECORD IS RPT-REC.
       01  RPT-REC                  PIC X(132).

       WORKING-STORAGE SECTION.
       01  WS-FILE-STATUS-FLAGS.
           05  WS-ACADIN-STATUS     PIC X(02).
           05  WS-FEEIN-STATUS      PIC X(02).
           05  WS-ACADOUT-STATUS    PIC X(02).
           05  WS-RPT-STATUS        PIC X(02).

       01  WS-EOF-FLAGS.
           05  WS-ACAD-EOF          PIC X(01) VALUE 'N'.
               88  END-OF-ACAD      VALUE 'Y'.
           05  WS-FEE-EOF           PIC X(01) VALUE 'N'.
               88  END-OF-FEE       VALUE 'Y'.

       01  WS-FEE-TABLE.
           05  WS-FEE-COUNT         PIC 9(03) VALUE 0.
           05  WS-FEES OCCURS 100 TIMES INDEXED BY IDX-FEE.
               10  WS-F-STU-ID      PIC X(08).
               10  WS-F-STATUS      PIC X(08).

       01  WS-WORK-AREAS.
           05  WS-MATCH-FOUND       PIC X(01) VALUE 'N'.
               88  FEE-MATCH-FOUND  VALUE 'Y'.
               88  FEE-NOT-FOUND    VALUE 'N'.

       01  WS-ACAD-WORK-REC.
           05  WA-STUDENT-ID        PIC X(08).
           05  WA-APP-ID            PIC X(06).
           05  WA-STUDENT-NAME      PIC X(30).
           05  WA-COLLEGE-ID        PIC X(04).
           05  WA-COURSE-ID         PIC X(04).
           05  WA-SEMESTER          PIC 9(02).
           05  WA-IA1-MARKS         PIC 9(03).
           05  WA-IA2-MARKS         PIC 9(03).
           05  WA-PRACT-MARKS       PIC 9(03).
           05  WA-ENDSEM-MARKS      PIC 9(03).
           05  WA-ATTENDANCE        PIC 9(03).
           05  WA-TOTAL-MARKS       PIC 9(04).
           05  WA-PERCENTAGE        PIC 9(03)V9(02).
           05  WA-GRADE             PIC X(02).
           05  WA-BACKLOG-CNT       PIC 9(02).
           05  WA-RESULT-STATUS     PIC X(08).
           05  WA-FEE-STATUS        PIC X(08).
           05  WA-FILLER            PIC X(152).

       01  WS-CALCULATIONS.
           05  WS-TEMP-PCT          PIC 9(03)V9(04).

       01  WS-COUNTERS.
           05  WS-TOT-STUDENTS      PIC 9(04) VALUE 0.
           05  WS-PASS-COUNT        PIC 9(04) VALUE 0.
           05  WS-FAIL-COUNT        PIC 9(04) VALUE 0.
           05  WS-BACKLOG-COUNT     PIC 9(04) VALUE 0.
           05  WS-WITHHELD-COUNT    PIC 9(04) VALUE 0.

       01  WS-REPORT-LINES.
           05  RPT-HEADER1.
               10  FILLER           PIC X(45) VALUE SPACES.
               10  FILLER           PIC X(25) VALUE 
                   'ACADEMIC RECORD REPORT'.
               10  FILLER           PIC X(62) VALUE SPACES.
           05  RPT-HEADER2.
               10  FILLER           PIC X(45) VALUE SPACES.
               10  FILLER           PIC X(25) VALUE 
                   '----------------------'.
               10  FILLER           PIC X(62) VALUE SPACES.
           05  RPT-DETAIL-LINE.
               10  FILLER           PIC X(10) VALUE SPACES.
               10  RPT-DESC         PIC X(30).
               10  RPT-COUNT        PIC Z,ZZ9.
               10  FILLER           PIC X(88) VALUE SPACES.

       PROCEDURE DIVISION.
       1000-MAIN.
           PERFORM 2000-INIT.
           PERFORM 3000-LOAD-FEE-TABLE.
           PERFORM 4000-PROCESS-ACAD-RECORDS
               UNTIL END-OF-ACAD.
           PERFORM 5000-GENERATE-REPORT.
           PERFORM 9000-CLEANUP.
           STOP RUN.

       2000-INIT.
           OPEN INPUT ACAD-IN-FILE
           OPEN INPUT FEE-IN-FILE
           OPEN OUTPUT ACAD-OUT-FILE
           OPEN OUTPUT RPT-FILE.

       3000-LOAD-FEE-TABLE.
           READ FEE-IN-FILE
               AT END SET END-OF-FEE TO TRUE
           END-READ
           PERFORM UNTIL END-OF-FEE
               ADD 1 TO WS-FEE-COUNT
               IF WS-FEE-COUNT <= 100
                   MOVE FEE-STUDENT-ID TO WS-F-STU-ID(WS-FEE-COUNT)
                   MOVE FEE-PAY-STATUS TO WS-F-STATUS(WS-FEE-COUNT)
               END-IF
               READ FEE-IN-FILE
                   AT END SET END-OF-FEE TO TRUE
               END-READ
           END-PERFORM.

       4000-PROCESS-ACAD-RECORDS.
           READ ACAD-IN-FILE INTO WS-ACAD-WORK-REC
               AT END SET END-OF-ACAD TO TRUE
           END-READ
           IF NOT END-OF-ACAD
               PERFORM 4100-CALCULATE-MARKS
               PERFORM 4200-DETERMINE-GRADE
               PERFORM 4300-CHECK-BACKLOGS
               PERFORM 4400-LOOKUP-FEE
               PERFORM 4500-DETERMINE-RESULT
               PERFORM 4600-WRITE-OUTPUT
           END-IF.

       4100-CALCULATE-MARKS.
           COMPUTE WA-TOTAL-MARKS = WA-IA1-MARKS + WA-IA2-MARKS +
                                    WA-PRACT-MARKS + WA-ENDSEM-MARKS
           COMPUTE WS-TEMP-PCT = (WA-TOTAL-MARKS / 200) * 100
           MOVE WS-TEMP-PCT TO WA-PERCENTAGE.

       4200-DETERMINE-GRADE.
           IF WA-PERCENTAGE >= 80.00
               MOVE 'O ' TO WA-GRADE
           ELSE IF WA-PERCENTAGE >= 70.00
               MOVE 'A+' TO WA-GRADE
           ELSE IF WA-PERCENTAGE >= 60.00
               MOVE 'A ' TO WA-GRADE
           ELSE IF WA-PERCENTAGE >= 50.00
               MOVE 'B+' TO WA-GRADE
           ELSE IF WA-PERCENTAGE >= 45.00
               MOVE 'B ' TO WA-GRADE
           ELSE IF WA-PERCENTAGE >= 40.00
               MOVE 'C ' TO WA-GRADE
           ELSE
               MOVE 'F ' TO WA-GRADE
           END-IF.

       4300-CHECK-BACKLOGS.
           MOVE 0 TO WA-BACKLOG-CNT
           IF WA-IA1-MARKS < 8
               ADD 1 TO WA-BACKLOG-CNT
           END-IF
           IF WA-IA2-MARKS < 8
               ADD 1 TO WA-BACKLOG-CNT
           END-IF
           IF WA-PRACT-MARKS < 20
               ADD 1 TO WA-BACKLOG-CNT
           END-IF
           IF WA-ENDSEM-MARKS < 35
               ADD 1 TO WA-BACKLOG-CNT
           END-IF.

       4400-LOOKUP-FEE.
           MOVE SPACES TO WA-FEE-STATUS
           SET FEE-NOT-FOUND TO TRUE
           PERFORM VARYING IDX-FEE FROM 1 BY 1
             UNTIL IDX-FEE > WS-FEE-COUNT OR FEE-MATCH-FOUND
               IF WA-STUDENT-ID = WS-F-STU-ID(IDX-FEE)
                   MOVE WS-F-STATUS(IDX-FEE) TO WA-FEE-STATUS
                   SET FEE-MATCH-FOUND TO TRUE
               END-IF
           END-PERFORM.

       4500-DETERMINE-RESULT.
           IF WA-ATTENDANCE < 75
               MOVE 'FAIL    ' TO WA-RESULT-STATUS
               ADD 1 TO WS-FAIL-COUNT
           ELSE IF WA-BACKLOG-CNT > 0
               MOVE 'BACKLOG ' TO WA-RESULT-STATUS
               ADD 1 TO WS-BACKLOG-COUNT
           ELSE IF WA-PERCENTAGE < 40.00
               MOVE 'FAIL    ' TO WA-RESULT-STATUS
               ADD 1 TO WS-FAIL-COUNT
           ELSE IF WA-FEE-STATUS = 'PENDING '
               MOVE 'WITHHELD' TO WA-RESULT-STATUS
               ADD 1 TO WS-WITHHELD-COUNT
           ELSE
               MOVE 'PASS    ' TO WA-RESULT-STATUS
               ADD 1 TO WS-PASS-COUNT
           END-IF
           ADD 1 TO WS-TOT-STUDENTS.

       4600-WRITE-OUTPUT.
           MOVE WS-ACAD-WORK-REC TO ACAD-OUT-REC
           WRITE ACAD-OUT-REC.

       5000-GENERATE-REPORT.
           WRITE RPT-REC FROM RPT-HEADER1
           WRITE RPT-REC FROM RPT-HEADER2
           MOVE SPACES TO RPT-REC
           WRITE RPT-REC
           
           MOVE 'TOTAL STUDENTS PROCESSED:   ' TO RPT-DESC
           MOVE WS-TOT-STUDENTS TO RPT-COUNT
           WRITE RPT-REC FROM RPT-DETAIL-LINE
           
           MOVE 'PASS COUNT:                 ' TO RPT-DESC
           MOVE WS-PASS-COUNT TO RPT-COUNT
           WRITE RPT-REC FROM RPT-DETAIL-LINE
           
           MOVE 'FAIL COUNT:                 ' TO RPT-DESC
           MOVE WS-FAIL-COUNT TO RPT-COUNT
           WRITE RPT-REC FROM RPT-DETAIL-LINE
           
           MOVE 'BACKLOG COUNT:              ' TO RPT-DESC
           MOVE WS-BACKLOG-COUNT TO RPT-COUNT
           WRITE RPT-REC FROM RPT-DETAIL-LINE
           
           MOVE 'WITHHELD COUNT:             ' TO RPT-DESC
           MOVE WS-WITHHELD-COUNT TO RPT-COUNT
           WRITE RPT-REC FROM RPT-DETAIL-LINE.

       9000-CLEANUP.
           CLOSE ACAD-IN-FILE
           CLOSE FEE-IN-FILE
           CLOSE ACAD-OUT-FILE
           CLOSE RPT-FILE.
