       IDENTIFICATION DIVISION.
       PROGRAM-ID. CAPALLOC.
       AUTHOR. MAINFRAME-BUILDER.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT MERITIN ASSIGN TO MERITIN
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-FS-MERIT.
           SELECT SEATIN ASSIGN TO SEATIN
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-FS-SEAT.
           SELECT PREFIN ASSIGN TO PREFIN
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-FS-PREF.
           SELECT PREVALLOT ASSIGN TO PREVALL
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-FS-PREV.
           SELECT ACCEPTIN ASSIGN TO ACCEPTIN
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-FS-ACC.
           SELECT ALLOTOUT ASSIGN TO ALLOTOUT
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-FS-ALLOT.
           SELECT SEATOUT ASSIGN TO SEATOUT
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-FS-SOUT.
           SELECT UNALLOT ASSIGN TO UNALLOT
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-FS-UNALLOT.
           SELECT RPTFILE  ASSIGN TO RPTFILE
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-FS-RPT.

       DATA DIVISION.
       FILE SECTION.
       FD  MERITIN
           RECORD CONTAINS 200 CHARACTERS.
       01  REC-MERIT.
           05  MERIT-RANK         PIC 9(04).
           05  MERIT-APP-ID       PIC X(06).
           05  MERIT-STUDENT-ID   PIC X(08).
           05  MERIT-STUDENT-NAME PIC X(30).
           05  MERIT-CET-SCORE    PIC 9(03).
           05  MERIT-CATEGORY     PIC X(10).
           05  MERIT-GENDER       PIC X(01).
           05  MERIT-DOMICILE     PIC X(15).
           05  FILLER             PIC X(123).

       FD  SEATIN
           RECORD CONTAINS 200 CHARACTERS.
       01  REC-SEAT.
           05  SEAT-COLLEGE-ID    PIC X(04).
           05  SEAT-COLLEGE-NAME  PIC X(30).
           05  SEAT-COURSE-ID     PIC X(04).
           05  SEAT-COURSE-NAME   PIC X(25).
           05  SEAT-CATEGORY      PIC X(10).
           05  SEAT-TOTAL         PIC 9(03).
           05  SEAT-AVAIL         PIC 9(03).
           05  FILLER             PIC X(121).

       FD  PREFIN
           RECORD CONTAINS 80 CHARACTERS.
       01  REC-PREF.
           05  PREF-APP-ID        PIC X(06).
           05  PREF-NUM           PIC 9(02).
           05  PREF-COLLEGE-ID    PIC X(04).
           05  PREF-COURSE-ID     PIC X(04).
           05  FILLER             PIC X(64).

       FD  PREVALLOT
           RECORD CONTAINS 250 CHARACTERS.
       01  REC-PREV-ALLOT         PIC X(250).

       FD  ACCEPTIN
           RECORD CONTAINS 80 CHARACTERS.
       01  REC-ACCEPT.
           05  ACC-APP-ID         PIC X(06).
           05  ACC-CODE           PIC X(01).
           05  FILLER             PIC X(73).

       FD  ALLOTOUT
           RECORD CONTAINS 250 CHARACTERS.
       01  REC-ALLOT.
           05  ALLOT-APP-ID       PIC X(06).
           05  ALLOT-RANK         PIC 9(04).
           05  ALLOT-STUDENT-ID   PIC X(08).
           05  ALLOT-STUDENT-NAME PIC X(30).
           05  ALLOT-COLLEGE-ID   PIC X(04).
           05  ALLOT-COLLEGE-NAME PIC X(30).
           05  ALLOT-COURSE-ID    PIC X(04).
           05  ALLOT-COURSE-NAME  PIC X(25).
           05  ALLOT-CATEGORY     PIC X(10).
           05  ALLOT-STATUS       PIC X(10).
           05  ALLOT-PREF         PIC 9(02).
           05  ALLOT-ROUND        PIC 9(01).
           05  ALLOT-ACCEPT       PIC X(01).
           05  FILLER             PIC X(115).

       FD  SEATOUT
           RECORD CONTAINS 200 CHARACTERS.
       01  REC-SEAT-OUT           PIC X(200).

       FD  UNALLOT
           RECORD CONTAINS 200 CHARACTERS.
       01  REC-UNALLOT            PIC X(200).

       FD  RPTFILE
           RECORD CONTAINS 132 CHARACTERS.
       01  REC-RPT                PIC X(132).

       WORKING-STORAGE SECTION.
       01  WS-FILE-STATUS.
           05  WS-FS-MERIT        PIC X(02).
               88  FS-MERIT-EOF   VALUE '10'.
           05  WS-FS-SEAT         PIC X(02).
               88  FS-SEAT-EOF    VALUE '10'.
           05  WS-FS-PREF         PIC X(02).
               88  FS-PREF-EOF    VALUE '10'.
           05  WS-FS-PREV         PIC X(02).
               88  FS-PREV-EOF    VALUE '10'.
           05  WS-FS-ACC          PIC X(02).
               88  FS-ACC-EOF     VALUE '10'.
           05  WS-FS-ALLOT        PIC X(02).
           05  WS-FS-SOUT         PIC X(02).
           05  WS-FS-UNALLOT      PIC X(02).
           05  WS-FS-RPT          PIC X(02).

       01  WS-ROUND-NUM           PIC 9(01) VALUE 1.

       01  WS-TABLES.
           05  WS-SEAT-COUNT      PIC 9(03) VALUE ZEROES.
           05  WS-SEAT-TABLE OCCURS 60 TIMES INDEXED BY SEAT-IDX.
               10  TBL-S-COL-ID   PIC X(04).
               10  TBL-S-COL-NAME PIC X(30).
               10  TBL-S-CRS-ID   PIC X(04).
               10  TBL-S-CRS-NAME PIC X(25).
               10  TBL-S-CAT      PIC X(10).
               10  TBL-S-TOT      PIC 9(03).
               10  TBL-S-AVAIL    PIC 9(03).

           05  WS-PREF-COUNT      PIC 9(04) VALUE ZEROES.
           05  WS-PREF-TABLE OCCURS 500 TIMES INDEXED BY PREF-IDX.
               10  TBL-P-APP-ID   PIC X(06).
               10  TBL-P-NUM      PIC 9(02).
               10  TBL-P-COL-ID   PIC X(04).
               10  TBL-P-CRS-ID   PIC X(04).

       01  WS-FLAGS.
           05  WS-ALLOTTED-FLAG   PIC X(01) VALUE 'N'.
               88  IS-ALLOTTED    VALUE 'Y'.
               88  NOT-ALLOTTED   VALUE 'N'.
           05  WS-PREV-ALLOT-REC  PIC X(250).
           05  WS-BETTERMENT-FLAG PIC X(01) VALUE 'N'.

       01  WS-COUNTERS.
           05  WS-PROC-COUNT      PIC 9(05) VALUE ZEROES.
           05  WS-ALLOT-COUNT     PIC 9(05) VALUE ZEROES.
           05  WS-UNALLOT-COUNT   PIC 9(05) VALUE ZEROES.

       01  WS-RPT-LINES.
           05  RPT-DET.
               10  FILLER         PIC X(10) VALUE 'ALLOTTED: '.
               10  RPT-APP-ID     PIC X(06).
           05  RPT-SUM1.
               10  FILLER         PIC X(20) VALUE 'PROCESSED : '.
               10  RPT-TOT-PROC   PIC ZZ,ZZ9.
           05  RPT-SUM2.
               10  FILLER         PIC X(20) VALUE 'ALLOTTED  : '.
               10  RPT-TOT-ALLOT  PIC ZZ,ZZ9.
           05  RPT-SUM3.
               10  FILLER         PIC X(20) VALUE 'UNALLOTTED: '.
               10  RPT-TOT-UNALL  PIC ZZ,ZZ9.

       PROCEDURE DIVISION.
       0000-MAIN.
           PERFORM 1000-INIT.
           PERFORM 1100-LOAD-SEATS.
           PERFORM 1200-LOAD-PREFS.
           PERFORM 2000-PROCESS-MERIT UNTIL FS-MERIT-EOF.
           PERFORM 3000-WRITE-SEATS.
           PERFORM 4000-FINISH.
           STOP RUN.

       1000-INIT.
           OPEN INPUT MERITIN SEATIN PREFIN
           OPEN I-O PREVALLOT ACCEPTIN
           OPEN OUTPUT ALLOTOUT SEATOUT UNALLOT RPTFILE
           
           READ MERITIN
               AT END SET FS-MERIT-EOF TO TRUE
           END-READ.

       1100-LOAD-SEATS.
           READ SEATIN
               AT END SET FS-SEAT-EOF TO TRUE
           END-READ
           PERFORM UNTIL FS-SEAT-EOF
               ADD 1 TO WS-SEAT-COUNT
               MOVE SEAT-COLLEGE-ID   TO TBL-S-COL-ID(WS-SEAT-COUNT)
               MOVE SEAT-COLLEGE-NAME TO TBL-S-COL-NAME(WS-SEAT-COUNT)
               MOVE SEAT-COURSE-ID    TO TBL-S-CRS-ID(WS-SEAT-COUNT)
               MOVE SEAT-COURSE-NAME  TO TBL-S-CRS-NAME(WS-SEAT-COUNT)
               MOVE SEAT-CATEGORY     TO TBL-S-CAT(WS-SEAT-COUNT)
               MOVE SEAT-TOTAL        TO TBL-S-TOT(WS-SEAT-COUNT)
               MOVE SEAT-AVAIL        TO TBL-S-AVAIL(WS-SEAT-COUNT)
               READ SEATIN
                   AT END SET FS-SEAT-EOF TO TRUE
               END-READ
           END-PERFORM.

       1200-LOAD-PREFS.
           READ PREFIN
               AT END SET FS-PREF-EOF TO TRUE
           END-READ
           PERFORM UNTIL FS-PREF-EOF
               ADD 1 TO WS-PREF-COUNT
               MOVE PREF-APP-ID     TO TBL-P-APP-ID(WS-PREF-COUNT)
               MOVE PREF-NUM        TO TBL-P-NUM(WS-PREF-COUNT)
               MOVE PREF-COLLEGE-ID TO TBL-P-COL-ID(WS-PREF-COUNT)
               MOVE PREF-COURSE-ID  TO TBL-P-CRS-ID(WS-PREF-COUNT)
               READ PREFIN
                   AT END SET FS-PREF-EOF TO TRUE
               END-READ
           END-PERFORM.

       2000-PROCESS-MERIT.
           ADD 1 TO WS-PROC-COUNT
           SET NOT-ALLOTTED TO TRUE
           MOVE SPACES TO REC-ALLOT
           
           PERFORM VARYING PREF-IDX FROM 1 BY 1 
                     UNTIL PREF-IDX > WS-PREF-COUNT OR IS-ALLOTTED
               IF TBL-P-APP-ID(PREF-IDX) = MERIT-APP-ID
                   PERFORM VARYING SEAT-IDX FROM 1 BY 1
                             UNTIL SEAT-IDX > WS-SEAT-COUNT OR IS-ALLOTTED
                       IF TBL-S-COL-ID(SEAT-IDX) = TBL-P-COL-ID(PREF-IDX) AND
                          TBL-S-CRS-ID(SEAT-IDX) = TBL-P-CRS-ID(PREF-IDX) AND
                          TBL-S-CAT(SEAT-IDX) = MERIT-CATEGORY
                           IF TBL-S-AVAIL(SEAT-IDX) > 0
                               SUBTRACT 1 FROM TBL-S-AVAIL(SEAT-IDX)
                               SET IS-ALLOTTED TO TRUE
                               
                               MOVE MERIT-APP-ID       TO ALLOT-APP-ID
                               MOVE MERIT-RANK         TO ALLOT-RANK
                               MOVE MERIT-STUDENT-ID   TO ALLOT-STUDENT-ID
                               MOVE MERIT-STUDENT-NAME TO ALLOT-STUDENT-NAME
                               MOVE TBL-S-COL-ID(SEAT-IDX) TO ALLOT-COLLEGE-ID
                               MOVE TBL-S-COL-NAME(SEAT-IDX) TO ALLOT-COLLEGE-NAME
                               MOVE TBL-S-CRS-ID(SEAT-IDX) TO ALLOT-COURSE-ID
                               MOVE TBL-S-CRS-NAME(SEAT-IDX) TO ALLOT-COURSE-NAME
                               MOVE MERIT-CATEGORY     TO ALLOT-CATEGORY
                               MOVE 'ALLOTTED  '       TO ALLOT-STATUS
                               MOVE TBL-P-NUM(PREF-IDX) TO ALLOT-PREF
                               MOVE WS-ROUND-NUM       TO ALLOT-ROUND
                               MOVE SPACE              TO ALLOT-ACCEPT
                               MOVE SPACES             TO ALLOT-FILLER
                               
                               WRITE REC-ALLOT
                               ADD 1 TO WS-ALLOT-COUNT
                           END-IF
                       END-IF
                   END-PERFORM
               END-IF
           END-PERFORM.
           
           IF NOT-ALLOTTED
               WRITE REC-UNALLOT FROM REC-MERIT
               ADD 1 TO WS-UNALLOT-COUNT
           END-IF.

           READ MERITIN
               AT END SET FS-MERIT-EOF TO TRUE
           END-READ.

       3000-WRITE-SEATS.
           PERFORM VARYING SEAT-IDX FROM 1 BY 1 UNTIL SEAT-IDX > WS-SEAT-COUNT
               MOVE SPACES TO REC-SEAT-OUT
               MOVE TBL-S-COL-ID(SEAT-IDX)   TO REC-SEAT-OUT(1:4)
               MOVE TBL-S-COL-NAME(SEAT-IDX) TO REC-SEAT-OUT(5:30)
               MOVE TBL-S-CRS-ID(SEAT-IDX)   TO REC-SEAT-OUT(35:4)
               MOVE TBL-S-CRS-NAME(SEAT-IDX) TO REC-SEAT-OUT(39:25)
               MOVE TBL-S-CAT(SEAT-IDX)      TO REC-SEAT-OUT(64:10)
               MOVE TBL-S-TOT(SEAT-IDX)      TO REC-SEAT-OUT(74:3)
               MOVE TBL-S-AVAIL(SEAT-IDX)    TO REC-SEAT-OUT(77:3)
               MOVE SPACES                   TO REC-SEAT-OUT(80:121)
               WRITE REC-SEAT-OUT
           END-PERFORM.

       4000-FINISH.
           MOVE WS-PROC-COUNT   TO RPT-TOT-PROC
           MOVE WS-ALLOT-COUNT  TO RPT-TOT-ALLOT
           MOVE WS-UNALLOT-COUNT TO RPT-TOT-UNALL
           
           WRITE REC-RPT FROM RPT-SUM1
           WRITE REC-RPT FROM RPT-SUM2
           WRITE REC-RPT FROM RPT-SUM3
           
           CLOSE MERITIN SEATIN PREFIN PREVALLOT ACCEPTIN
                 ALLOTOUT SEATOUT UNALLOT RPTFILE.
