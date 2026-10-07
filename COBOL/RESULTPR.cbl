       IDENTIFICATION DIVISION.
       PROGRAM-ID. RESULTPR.
       AUTHOR. MAINFRAME-BUILDER.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT RESULT-IN-FILE ASSIGN TO 'RESULTIN'
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-RESIN-STATUS.
               
           SELECT PASS-OUT-FILE ASSIGN TO 'PASSOUT'
               ORGANIZATION IS SEQUENTIAL.
               
           SELECT FAIL-OUT-FILE ASSIGN TO 'FAILOUT'
               ORGANIZATION IS SEQUENTIAL.
               
           SELECT BACKLOG-OUT-FILE ASSIGN TO 'BACKOUT'
               ORGANIZATION IS SEQUENTIAL.
               
           SELECT WITHHELD-OUT-FILE ASSIGN TO 'WITHHOLD'
               ORGANIZATION IS SEQUENTIAL.
               
           SELECT RPT-FILE ASSIGN TO 'RPTFILE'
               ORGANIZATION IS SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  RESULT-IN-FILE
           RECORD CONTAINS 250 CHARACTERS
           DATA RECORD IS RES-IN-REC.
       01  RES-IN-REC.
           05  IN-STUDENT-ID        PIC X(08).
           05  FILLER               PIC X(06).
           05  IN-STUDENT-NAME      PIC X(30).
           05  IN-COLLEGE-ID        PIC X(04).
           05  FILLER               PIC X(25).
           05  IN-PERCENTAGE        PIC 9(03)V9(02).
           05  IN-GRADE             PIC X(02).
           05  FILLER               PIC X(02).
           05  IN-RESULT-STATUS     PIC X(08).
           05  FILLER               PIC X(160).

       FD  PASS-OUT-FILE
           RECORD CONTAINS 250 CHARACTERS.
       01  PASS-REC                 PIC X(250).

       FD  FAIL-OUT-FILE
           RECORD CONTAINS 250 CHARACTERS.
       01  FAIL-REC                 PIC X(250).

       FD  BACKLOG-OUT-FILE
           RECORD CONTAINS 250 CHARACTERS.
       01  BACK-REC                 PIC X(250).

       FD  WITHHELD-OUT-FILE
           RECORD CONTAINS 250 CHARACTERS.
       01  WITH-REC                 PIC X(250).

       FD  RPT-FILE
           RECORD CONTAINS 132 CHARACTERS.
       01  RPT-REC                  PIC X(132).

       WORKING-STORAGE SECTION.
       01  WS-FILE-STATUS-FLAGS.
           05  WS-RESIN-STATUS      PIC X(02).

       01  WS-EOF-FLAGS.
           05  WS-RES-EOF           PIC X(01) VALUE 'N'.
               88  END-OF-RES       VALUE 'Y'.

       01  WS-STATS.
           05  WS-TOT-STUDENTS      PIC 9(04) VALUE 0.
           05  WS-PASS-CNT          PIC 9(04) VALUE 0.
           05  WS-FAIL-CNT          PIC 9(04) VALUE 0.
           05  WS-BACKLOG-CNT       PIC 9(04) VALUE 0.
           05  WS-WITHHELD-CNT      PIC 9(04) VALUE 0.
           05  WS-MAX-PCT           PIC 9(03)V9(02) VALUE 0.
           05  WS-MIN-PCT           PIC 9(03)V9(02) VALUE 999.99.
           
           05  WS-GRADE-O           PIC 9(04) VALUE 0.
           05  WS-GRADE-AP          PIC 9(04) VALUE 0.
           05  WS-GRADE-A           PIC 9(04) VALUE 0.
           05  WS-GRADE-BP          PIC 9(04) VALUE 0.
           05  WS-GRADE-B           PIC 9(04) VALUE 0.
           05  WS-GRADE-C           PIC 9(04) VALUE 0.
           05  WS-GRADE-F           PIC 9(04) VALUE 0.

       01  WS-COLLEGE-STATS.
           05  WS-COL-TABLE OCCURS 5 TIMES INDEXED BY IDX-COL.
               10  WS-COL-ID        PIC X(04).
               10  WS-COL-PASS      PIC 9(04) VALUE 0.
               10  WS-COL-FAIL      PIC 9(04) VALUE 0.

       01  WS-TOP-STUDENTS.
           05  WS-TOP-TABLE OCCURS 5 TIMES.
               10  WS-TOP-PCT       PIC 9(03)V9(02) VALUE 0.
               10  WS-TOP-NAME      PIC X(30) VALUE SPACES.

       01  WS-CALC.
           05  WS-PASS-PCT-DISP     PIC ZZZ.99.
           05  WS-FAIL-PCT-DISP     PIC ZZZ.99.
           05  WS-BACK-PCT-DISP     PIC ZZZ.99.
           
           05  WS-TEMP-PCT          PIC 9(03)V9(04).
           
       01  WS-REPORT-LINES.
           05  RPT-DETAIL-LINE.
               10  FILLER           PIC X(10) VALUE SPACES.
               10  RPT-DESC         PIC X(30).
               10  RPT-VAL          PIC X(20).
               10  FILLER           PIC X(72) VALUE SPACES.

       PROCEDURE DIVISION.
       1000-MAIN.
           PERFORM 2000-INIT.
           PERFORM 4000-PROCESS-RECORDS
               UNTIL END-OF-RES.
           PERFORM 5000-GENERATE-REPORT.
           PERFORM 9000-CLEANUP.
           STOP RUN.

       2000-INIT.
           OPEN INPUT RESULT-IN-FILE
           OPEN OUTPUT PASS-OUT-FILE
           OPEN OUTPUT FAIL-OUT-FILE
           OPEN OUTPUT BACKLOG-OUT-FILE
           OPEN OUTPUT WITHHELD-OUT-FILE
           OPEN OUTPUT RPT-FILE
           
           MOVE 'C001' TO WS-COL-ID(1)
           MOVE 'C002' TO WS-COL-ID(2)
           MOVE 'C003' TO WS-COL-ID(3)
           MOVE 'C004' TO WS-COL-ID(4)
           MOVE 'C005' TO WS-COL-ID(5).

       4000-PROCESS-RECORDS.
           READ RESULT-IN-FILE
               AT END SET END-OF-RES TO TRUE
           END-READ
           IF NOT END-OF-RES
               ADD 1 TO WS-TOT-STUDENTS
               
               EVALUATE IN-RESULT-STATUS
                   WHEN 'PASS    '
                       WRITE PASS-REC FROM RES-IN-REC
                       ADD 1 TO WS-PASS-CNT
                   WHEN 'FAIL    '
                       WRITE FAIL-REC FROM RES-IN-REC
                       ADD 1 TO WS-FAIL-CNT
                   WHEN 'BACKLOG '
                       WRITE BACK-REC FROM RES-IN-REC
                       ADD 1 TO WS-BACKLOG-CNT
                   WHEN 'WITHHELD'
                       WRITE WITH-REC FROM RES-IN-REC
                       ADD 1 TO WS-WITHHELD-CNT
               END-EVALUATE
               
               IF IN-PERCENTAGE > WS-MAX-PCT
                   MOVE IN-PERCENTAGE TO WS-MAX-PCT
               END-IF
               IF IN-PERCENTAGE < WS-MIN-PCT
                   MOVE IN-PERCENTAGE TO WS-MIN-PCT
               END-IF
               
               EVALUATE IN-GRADE
                   WHEN 'O ' ADD 1 TO WS-GRADE-O
                   WHEN 'A+' ADD 1 TO WS-GRADE-AP
                   WHEN 'A ' ADD 1 TO WS-GRADE-A
                   WHEN 'B+' ADD 1 TO WS-GRADE-BP
                   WHEN 'B ' ADD 1 TO WS-GRADE-B
                   WHEN 'C ' ADD 1 TO WS-GRADE-C
                   WHEN 'F ' ADD 1 TO WS-GRADE-F
               END-EVALUATE
               
               PERFORM VARYING IDX-COL FROM 1 BY 1
                 UNTIL IDX-COL > 5
                   IF IN-COLLEGE-ID = WS-COL-ID(IDX-COL)
                       IF IN-RESULT-STATUS = 'PASS    '
                           ADD 1 TO WS-COL-PASS(IDX-COL)
                       ELSE IF IN-RESULT-STATUS = 'FAIL    '
                           ADD 1 TO WS-COL-FAIL(IDX-COL)
                       END-IF
                   END-IF
               END-PERFORM
               
           END-IF.

       5000-GENERATE-REPORT.
           COMPUTE WS-TEMP-PCT = (WS-PASS-CNT / WS-TOT-STUDENTS) * 100
           MOVE WS-TEMP-PCT TO WS-PASS-PCT-DISP
           
           COMPUTE WS-TEMP-PCT = (WS-FAIL-CNT / WS-TOT-STUDENTS) * 100
           MOVE WS-TEMP-PCT TO WS-FAIL-PCT-DISP
           
           COMPUTE WS-TEMP-PCT = (WS-BACKLOG-CNT / WS-TOT-STUDENTS) * 100
           MOVE WS-TEMP-PCT TO WS-BACK-PCT-DISP

           MOVE SPACES TO RPT-REC
           WRITE RPT-REC
           
           MOVE 'TOTAL STUDENTS:               ' TO RPT-DESC
           MOVE WS-TOT-STUDENTS TO RPT-VAL
           WRITE RPT-REC FROM RPT-DETAIL-LINE
           
           MOVE 'PASS COUNT & PCT:             ' TO RPT-DESC
           STRING WS-PASS-CNT ' (' WS-PASS-PCT-DISP '%)' 
             DELIMITED BY SIZE INTO RPT-VAL
           WRITE RPT-REC FROM RPT-DETAIL-LINE
           
           MOVE 'FAIL COUNT & PCT:             ' TO RPT-DESC
           STRING WS-FAIL-CNT ' (' WS-FAIL-PCT-DISP '%)' 
             DELIMITED BY SIZE INTO RPT-VAL
           WRITE RPT-REC FROM RPT-DETAIL-LINE
           
           MOVE 'BACKLOG COUNT & PCT:          ' TO RPT-DESC
           STRING WS-BACKLOG-CNT ' (' WS-BACK-PCT-DISP '%)' 
             DELIMITED BY SIZE INTO RPT-VAL
           WRITE RPT-REC FROM RPT-DETAIL-LINE
           
           MOVE 'WITHHELD COUNT:               ' TO RPT-DESC
           MOVE WS-WITHHELD-CNT TO RPT-VAL
           WRITE RPT-REC FROM RPT-DETAIL-LINE.

       9000-CLEANUP.
           CLOSE RESULT-IN-FILE
           CLOSE PASS-OUT-FILE
           CLOSE FAIL-OUT-FILE
           CLOSE BACKLOG-OUT-FILE
           CLOSE WITHHELD-OUT-FILE
           CLOSE RPT-FILE.
