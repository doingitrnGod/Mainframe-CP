       IDENTIFICATION DIVISION.
       PROGRAM-ID. FINALRPT.
       AUTHOR. MAINFRAME-BUILDER.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT MERIT-FILE ASSIGN TO 'MERITFL'
               ORGANIZATION IS SEQUENTIAL.
           SELECT ALLOT1-FILE ASSIGN TO 'ALLOT1'
               ORGANIZATION IS SEQUENTIAL.
           SELECT ALLOT2-FILE ASSIGN TO 'ALLOT2'
               ORGANIZATION IS SEQUENTIAL.
           SELECT ALLOT3-FILE ASSIGN TO 'ALLOT3'
               ORGANIZATION IS SEQUENTIAL.
           SELECT FINAL-FILE ASSIGN TO 'FINALFL'
               ORGANIZATION IS SEQUENTIAL.
           SELECT VACANCY-FILE ASSIGN TO 'VACANCYFL'
               ORGANIZATION IS SEQUENTIAL.
           SELECT RESULT-FILE ASSIGN TO 'RESULTFL'
               ORGANIZATION IS SEQUENTIAL.
           SELECT RPT-FILE ASSIGN TO 'RPTFILE'
               ORGANIZATION IS SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  MERIT-FILE
           RECORD CONTAINS 200 CHARACTERS.
       01  MERIT-REC                PIC X(200).

       FD  ALLOT1-FILE
           RECORD CONTAINS 250 CHARACTERS.
       01  ALLOT1-REC.
           05  A1-FILLER1           PIC X(121).
           05  A1-STATUS            PIC X(10).
           05  A1-FILLER2           PIC X(119).

       FD  ALLOT2-FILE
           RECORD CONTAINS 250 CHARACTERS.
       01  ALLOT2-REC.
           05  A2-FILLER1           PIC X(121).
           05  A2-STATUS            PIC X(10).
           05  A2-FILLER2           PIC X(119).

       FD  ALLOT3-FILE
           RECORD CONTAINS 250 CHARACTERS.
       01  ALLOT3-REC.
           05  A3-FILLER1           PIC X(121).
           05  A3-STATUS            PIC X(10).
           05  A3-FILLER2           PIC X(119).

       FD  FINAL-FILE
           RECORD CONTAINS 250 CHARACTERS.
       01  FINAL-REC.
           05  F-FILLER1            PIC X(121).
           05  F-STATUS             PIC X(10).
           05  F-FILLER2            PIC X(03).
           05  F-ACCEPT             PIC X(01).
           05  F-FILLER3            PIC X(115).

       FD  VACANCY-FILE
           RECORD CONTAINS 200 CHARACTERS.
       01  VACANCY-REC.
           05  V-FILLER1            PIC X(73).
           05  V-TOT-SEATS          PIC 9(03).
           05  V-AVAIL-SEATS        PIC 9(03).
           05  V-FILLER2            PIC X(121).

       FD  RESULT-FILE
           RECORD CONTAINS 250 CHARACTERS.
       01  RESULT-REC.
           05  R-FILLER1            PIC X(82).
           05  R-STATUS             PIC X(08).
           05  R-FEE-STATUS         PIC X(08).
           05  R-FILLER2            PIC X(152).

       FD  RPT-FILE
           RECORD CONTAINS 132 CHARACTERS.
       01  RPT-REC                  PIC X(132).

       WORKING-STORAGE SECTION.
       01  WS-EOF-FLAGS.
           05  WS-MERIT-EOF         PIC X(1) VALUE 'N'.
           05  WS-ALLOT1-EOF        PIC X(1) VALUE 'N'.
           05  WS-ALLOT2-EOF        PIC X(1) VALUE 'N'.
           05  WS-ALLOT3-EOF        PIC X(1) VALUE 'N'.
           05  WS-FINAL-EOF         PIC X(1) VALUE 'N'.
           05  WS-VACANCY-EOF       PIC X(1) VALUE 'N'.
           05  WS-RESULT-EOF        PIC X(1) VALUE 'N'.

       01  WS-COUNTERS.
           05  WS-ELIGIBLE-CAND     PIC 9(04) VALUE 0.
           05  WS-R1-ALLOT          PIC 9(04) VALUE 0.
           05  WS-R2-ALLOT          PIC 9(04) VALUE 0.
           05  WS-R3-ALLOT          PIC 9(04) VALUE 0.
           05  WS-FINAL-ALLOT       PIC 9(04) VALUE 0.
           05  WS-FINAL-UNALLOT     PIC 9(04) VALUE 0.
           05  WS-FINAL-FROZEN      PIC 9(04) VALUE 0.
           05  WS-TOT-SEATS         PIC 9(04) VALUE 0.
           05  WS-AVAIL-SEATS       PIC 9(04) VALUE 0.
           05  WS-R-PASS            PIC 9(04) VALUE 0.
           05  WS-R-FAIL            PIC 9(04) VALUE 0.
           05  WS-R-BACKLOG         PIC 9(04) VALUE 0.
           05  WS-R-WITHHELD        PIC 9(04) VALUE 0.
           05  WS-FEE-PAID          PIC 9(04) VALUE 0.
           05  WS-FEE-PART          PIC 9(04) VALUE 0.
           05  WS-FEE-PEND          PIC 9(04) VALUE 0.

       01  WS-RPT-LINE.
           05  RPT-TEXT             PIC X(40).
           05  RPT-VALUE            PIC Z,ZZ9.
           05  FILLER               PIC X(87) VALUE SPACES.

       PROCEDURE DIVISION.
       1000-MAIN.
           PERFORM 2000-INIT.
           PERFORM 3000-PROCESS-MERIT.
           PERFORM 3100-PROCESS-ALLOT1.
           PERFORM 3200-PROCESS-ALLOT2.
           PERFORM 3300-PROCESS-ALLOT3.
           PERFORM 3400-PROCESS-FINAL.
           PERFORM 3500-PROCESS-VACANCY.
           PERFORM 3600-PROCESS-RESULT.
           PERFORM 5000-GENERATE-REPORT.
           PERFORM 9000-CLEANUP.
           STOP RUN.

       2000-INIT.
           OPEN INPUT MERIT-FILE
                ALLOT1-FILE
                ALLOT2-FILE
                ALLOT3-FILE
                FINAL-FILE
                VACANCY-FILE
                RESULT-FILE.
           OPEN OUTPUT RPT-FILE.

       3000-PROCESS-MERIT.
           READ MERIT-FILE AT END MOVE 'Y' TO WS-MERIT-EOF.
           PERFORM UNTIL WS-MERIT-EOF = 'Y'
               ADD 1 TO WS-ELIGIBLE-CAND
               READ MERIT-FILE AT END MOVE 'Y' TO WS-MERIT-EOF
           END-PERFORM.

       3100-PROCESS-ALLOT1.
           READ ALLOT1-FILE AT END MOVE 'Y' TO WS-ALLOT1-EOF.
           PERFORM UNTIL WS-ALLOT1-EOF = 'Y'
               IF A1-STATUS = 'ALLOTTED  ' ADD 1 TO WS-R1-ALLOT END-IF
               READ ALLOT1-FILE AT END MOVE 'Y' TO WS-ALLOT1-EOF
           END-PERFORM.

       3200-PROCESS-ALLOT2.
           READ ALLOT2-FILE AT END MOVE 'Y' TO WS-ALLOT2-EOF.
           PERFORM UNTIL WS-ALLOT2-EOF = 'Y'
               IF A2-STATUS = 'ALLOTTED  ' ADD 1 TO WS-R2-ALLOT END-IF
               READ ALLOT2-FILE AT END MOVE 'Y' TO WS-ALLOT2-EOF
           END-PERFORM.

       3300-PROCESS-ALLOT3.
           READ ALLOT3-FILE AT END MOVE 'Y' TO WS-ALLOT3-EOF.
           PERFORM UNTIL WS-ALLOT3-EOF = 'Y'
               IF A3-STATUS = 'ALLOTTED  ' ADD 1 TO WS-R3-ALLOT END-IF
               READ ALLOT3-FILE AT END MOVE 'Y' TO WS-ALLOT3-EOF
           END-PERFORM.

       3400-PROCESS-FINAL.
           READ FINAL-FILE AT END MOVE 'Y' TO WS-FINAL-EOF.
           PERFORM UNTIL WS-FINAL-EOF = 'Y'
               IF F-STATUS = 'ALLOTTED  ' 
                   ADD 1 TO WS-FINAL-ALLOT 
               ELSE 
                   ADD 1 TO WS-FINAL-UNALLOT 
               END-IF
               IF F-ACCEPT = 'F' ADD 1 TO WS-FINAL-FROZEN END-IF
               READ FINAL-FILE AT END MOVE 'Y' TO WS-FINAL-EOF
           END-PERFORM.

       3500-PROCESS-VACANCY.
           READ VACANCY-FILE AT END MOVE 'Y' TO WS-VACANCY-EOF.
           PERFORM UNTIL WS-VACANCY-EOF = 'Y'
               ADD V-TOT-SEATS TO WS-TOT-SEATS
               ADD V-AVAIL-SEATS TO WS-AVAIL-SEATS
               READ VACANCY-FILE AT END MOVE 'Y' TO WS-VACANCY-EOF
           END-PERFORM.

       3600-PROCESS-RESULT.
           READ RESULT-FILE AT END MOVE 'Y' TO WS-RESULT-EOF.
           PERFORM UNTIL WS-RESULT-EOF = 'Y'
               EVALUATE R-STATUS
                   WHEN 'PASS    ' ADD 1 TO WS-R-PASS
                   WHEN 'FAIL    ' ADD 1 TO WS-R-FAIL
                   WHEN 'BACKLOG ' ADD 1 TO WS-R-BACKLOG
                   WHEN 'WITHHELD' ADD 1 TO WS-R-WITHHELD
               END-EVALUATE
               EVALUATE R-FEE-STATUS
                   WHEN 'PAID    ' ADD 1 TO WS-FEE-PAID
                   WHEN 'PARTIAL ' ADD 1 TO WS-FEE-PART
                   WHEN 'PENDING ' ADD 1 TO WS-FEE-PEND
               END-EVALUATE
               READ RESULT-FILE AT END MOVE 'Y' TO WS-RESULT-EOF
           END-PERFORM.

       5000-GENERATE-REPORT.
           MOVE SPACES TO RPT-REC
           WRITE RPT-REC FROM 'FINAL COMPREHENSIVE REPORT'
           WRITE RPT-REC FROM '--------------------------'
           WRITE RPT-REC FROM SPACES
           
           MOVE 'TOTAL ELIGIBLE CANDIDATES:' TO RPT-TEXT
           MOVE WS-ELIGIBLE-CAND TO RPT-VALUE
           WRITE RPT-REC FROM WS-RPT-LINE
           
           MOVE 'TOTAL SEATS AVAILABLE:' TO RPT-TEXT
           MOVE WS-TOT-SEATS TO RPT-VALUE
           WRITE RPT-REC FROM WS-RPT-LINE
           
           MOVE 'FINAL ALLOTTED STUDENTS:' TO RPT-TEXT
           MOVE WS-FINAL-ALLOT TO RPT-VALUE
           WRITE RPT-REC FROM WS-RPT-LINE
           
           MOVE 'TOTAL VACANCIES REMAINING:' TO RPT-TEXT
           MOVE WS-AVAIL-SEATS TO RPT-VALUE
           WRITE RPT-REC FROM WS-RPT-LINE
           
           WRITE RPT-REC FROM SPACES
           WRITE RPT-REC FROM 'ACADEMIC RESULTS:'
           MOVE 'PASSED STUDENTS:' TO RPT-TEXT
           MOVE WS-R-PASS TO RPT-VALUE
           WRITE RPT-REC FROM WS-RPT-LINE
           
           WRITE RPT-REC FROM SPACES
           WRITE RPT-REC FROM 'FEE COLLECTION:'
           MOVE 'FULLY PAID:' TO RPT-TEXT
           MOVE WS-FEE-PAID TO RPT-VALUE
           WRITE RPT-REC FROM WS-RPT-LINE.

       9000-CLEANUP.
           CLOSE MERIT-FILE ALLOT1-FILE ALLOT2-FILE ALLOT3-FILE
                 FINAL-FILE VACANCY-FILE RESULT-FILE RPT-FILE.
