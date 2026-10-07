       IDENTIFICATION DIVISION.
       PROGRAM-ID. MERITGEN.
       AUTHOR. MAINFRAME-BUILDER.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CLEANIN ASSIGN TO INFILE
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-FS-IN.
           SELECT MERITOUT ASSIGN TO OUTFILE
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-FS-OUT.
           SELECT ELIGOUT  ASSIGN TO ELIGFILE
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-FS-ELIG.
           SELECT RPTFILE  ASSIGN TO RPTFILE
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-FS-RPT.

       DATA DIVISION.
       FILE SECTION.
       FD  CLEANIN
           RECORD CONTAINS 200 CHARACTERS.
       01  REC-IN.
           05  IN-APP-ID          PIC X(06).
           05  IN-STUDENT-ID      PIC X(08).
           05  IN-STUDENT-NAME    PIC X(30).
           05  IN-CET-SCORE       PIC 9(03).
           05  IN-CATEGORY        PIC X(10).
           05  IN-GENDER          PIC X(01).
           05  IN-DOMICILE        PIC X(15).
           05  IN-ELIG-STATUS     PIC X(01).
           05  FILLER             PIC X(126).

       FD  MERITOUT
           RECORD CONTAINS 200 CHARACTERS.
       01  REC-OUT.
           05  OUT-MERIT-RANK     PIC 9(04).
           05  OUT-APP-ID         PIC X(06).
           05  OUT-STUDENT-ID     PIC X(08).
           05  OUT-STUDENT-NAME   PIC X(30).
           05  OUT-CET-SCORE      PIC 9(03).
           05  OUT-CATEGORY       PIC X(10).
           05  OUT-GENDER         PIC X(01).
           05  OUT-DOMICILE       PIC X(15).
           05  FILLER             PIC X(123).

       FD  ELIGOUT
           RECORD CONTAINS 200 CHARACTERS.
       01  REC-ELIG               PIC X(200).

       FD  RPTFILE
           RECORD CONTAINS 132 CHARACTERS.
       01  REC-RPT                PIC X(132).

       WORKING-STORAGE SECTION.
       01  WS-FILE-STATUS.
           05  WS-FS-IN           PIC X(02).
               88  FS-IN-EOF      VALUE '10'.
           05  WS-FS-OUT          PIC X(02).
           05  WS-FS-ELIG         PIC X(02).
           05  WS-FS-RPT          PIC X(02).

       01  WS-COUNTERS.
           05  WS-MERIT-RANK      PIC 9(04) VALUE 0000.
           05  WS-TOTAL-CAND      PIC 9(07) VALUE ZEROES.
           05  WS-MAX-SCORE       PIC 9(03) VALUE 000.
           05  WS-MIN-SCORE       PIC 9(03) VALUE 999.

       01  WS-RPT-SUMMARY.
           05  FILLER             PIC X(20) VALUE 'TOTAL CANDIDATES : '.
           05  RPT-TOT-CAND       PIC ZZZ,ZZ9.
           05  FILLER             PIC X(105) VALUE SPACES.

       01  WS-RPT-SCORES.
           05  FILLER             PIC X(20) VALUE 'MAX SCORE        : '.
           05  RPT-MAX-SCORE      PIC ZZ9.
           05  FILLER             PIC X(20) VALUE '   MIN SCORE: '.
           05  RPT-MIN-SCORE      PIC ZZ9.
           05  FILLER             PIC X(86) VALUE SPACES.

       PROCEDURE DIVISION.
       0000-MAIN.
           PERFORM 1000-INIT.
           PERFORM 2000-PROCESS UNTIL FS-IN-EOF.
           PERFORM 3000-FINISH.
           STOP RUN.

       1000-INIT.
           OPEN INPUT CLEANIN
           OPEN OUTPUT MERITOUT ELIGOUT RPTFILE
           
           READ CLEANIN
               AT END SET FS-IN-EOF TO TRUE
           END-READ.

       2000-PROCESS.
           ADD 1 TO WS-MERIT-RANK
           ADD 1 TO WS-TOTAL-CAND

           MOVE WS-MERIT-RANK   TO OUT-MERIT-RANK
           MOVE IN-APP-ID       TO OUT-APP-ID
           MOVE IN-STUDENT-ID   TO OUT-STUDENT-ID
           MOVE IN-STUDENT-NAME TO OUT-STUDENT-NAME
           MOVE IN-CET-SCORE    TO OUT-CET-SCORE
           MOVE IN-CATEGORY     TO OUT-CATEGORY
           MOVE IN-GENDER       TO OUT-GENDER
           MOVE IN-DOMICILE     TO OUT-DOMICILE
           MOVE SPACES          TO REC-OUT(78:123)

           IF IN-CET-SCORE > WS-MAX-SCORE
               MOVE IN-CET-SCORE TO WS-MAX-SCORE
           END-IF
           IF IN-CET-SCORE < WS-MIN-SCORE
               MOVE IN-CET-SCORE TO WS-MIN-SCORE
           END-IF

           WRITE REC-OUT
           WRITE REC-ELIG FROM REC-OUT

           READ CLEANIN
               AT END SET FS-IN-EOF TO TRUE
           END-READ.

       3000-FINISH.
           MOVE WS-TOTAL-CAND TO RPT-TOT-CAND
           WRITE REC-RPT FROM WS-RPT-SUMMARY
           MOVE WS-MAX-SCORE TO RPT-MAX-SCORE
           MOVE WS-MIN-SCORE TO RPT-MIN-SCORE
           WRITE REC-RPT FROM WS-RPT-SCORES
           
           CLOSE CLEANIN MERITOUT ELIGOUT RPTFILE.
