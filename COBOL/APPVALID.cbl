       IDENTIFICATION DIVISION.
       PROGRAM-ID. APPVALID.
       AUTHOR. MAINFRAME-BUILDER.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT APPLICIN ASSIGN TO INFILE
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-FS-IN.
           SELECT VALIDOUT ASSIGN TO OUTFILE
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-FS-OUT.
           SELECT REJECTFL ASSIGN TO REJFILE
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-FS-REJ.
           SELECT RPTFILE  ASSIGN TO RPTFILE
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-FS-RPT.

       DATA DIVISION.
       FILE SECTION.
       FD  APPLICIN
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

       FD  VALIDOUT
           RECORD CONTAINS 200 CHARACTERS.
       01  REC-OUT                PIC X(200).

       FD  REJECTFL
           RECORD CONTAINS 200 CHARACTERS.
       01  REC-REJ.
           05  REJ-APP-ID         PIC X(06).
           05  REJ-STUDENT-ID     PIC X(08).
           05  REJ-STUDENT-NAME   PIC X(30).
           05  REJ-CET-SCORE      PIC 9(03).
           05  REJ-CATEGORY       PIC X(10).
           05  REJ-GENDER         PIC X(01).
           05  REJ-DOMICILE       PIC X(15).
           05  REJ-ELIG-STATUS    PIC X(01).
           05  FILLER             PIC X(126).

       FD  RPTFILE
           RECORD CONTAINS 132 CHARACTERS.
       01  REC-RPT                PIC X(132).

       WORKING-STORAGE SECTION.
       01  WS-FILE-STATUS.
           05  WS-FS-IN           PIC X(02).
               88  FS-IN-OK       VALUE '00' THRU '09'.
               88  FS-IN-EOF      VALUE '10'.
           05  WS-FS-OUT          PIC X(02).
               88  FS-OUT-OK      VALUE '00' THRU '09'.
           05  WS-FS-REJ          PIC X(02).
               88  FS-REJ-OK      VALUE '00' THRU '09'.
           05  WS-FS-RPT          PIC X(02).
               88  FS-RPT-OK      VALUE '00' THRU '09'.

       01  WS-COUNTERS.
           05  WS-RECS-READ       PIC 9(07) VALUE ZEROES.
           05  WS-RECS-VALID      PIC 9(07) VALUE ZEROES.
           05  WS-RECS-REJECT     PIC 9(07) VALUE ZEROES.

       01  WS-FLAGS.
           05  WS-VALID-FLAG      PIC X(01) VALUE 'Y'.
               88  IS-VALID       VALUE 'Y'.
               88  IS-INVALID     VALUE 'N'.

       01  WS-RPT-DETAIL.
           05  FILLER             PIC X(10) VALUE ' REJECT: '.
           05  RPT-APP-ID         PIC X(06).
           05  FILLER             PIC X(02) VALUE SPACES.
           05  RPT-REASON         PIC X(40).
           05  FILLER             PIC X(74) VALUE SPACES.

       01  WS-RPT-SUMMARY.
           05  FILLER             PIC X(15) VALUE 'TOTAL READ    :'.
           05  RPT-TOT-READ       PIC ZZZ,ZZZ,ZZ9.
           05  FILLER             PIC X(106) VALUE SPACES.

       01  WS-RPT-SUMMARY-V.
           05  FILLER             PIC X(15) VALUE 'TOTAL VALID   :'.
           05  RPT-TOT-VALID      PIC ZZZ,ZZZ,ZZ9.
           05  FILLER             PIC X(106) VALUE SPACES.

       01  WS-RPT-SUMMARY-R.
           05  FILLER             PIC X(15) VALUE 'TOTAL REJECT  :'.
           05  RPT-TOT-REJ        PIC ZZZ,ZZZ,ZZ9.
           05  FILLER             PIC X(106) VALUE SPACES.

       PROCEDURE DIVISION.
       0000-MAIN.
           PERFORM 1000-INIT.
           PERFORM 2000-PROCESS UNTIL FS-IN-EOF.
           PERFORM 3000-FINISH.
           STOP RUN.

       1000-INIT.
           OPEN INPUT APPLICIN
           OPEN OUTPUT VALIDOUT REJECTFL RPTFILE
           
           READ APPLICIN
               AT END SET FS-IN-EOF TO TRUE
           END-READ.

       2000-PROCESS.
           ADD 1 TO WS-RECS-READ
           SET IS-VALID TO TRUE
           MOVE SPACES TO RPT-REASON

           IF IN-APP-ID(1:1) NOT = 'A'
               SET IS-INVALID TO TRUE
               MOVE 'APP-ID MUST START WITH A' TO RPT-REASON
           END-IF

           IF IN-STUDENT-ID(1:2) NOT = 'ST'
               SET IS-INVALID TO TRUE
               MOVE 'STUDENT-ID MUST START WITH ST' TO RPT-REASON
           END-IF

           IF IN-STUDENT-NAME = SPACES
               SET IS-INVALID TO TRUE
               MOVE 'STUDENT-NAME CANNOT BE SPACES' TO RPT-REASON
           END-IF

           IF IN-CET-SCORE NOT NUMERIC OR IN-CET-SCORE <= 0
               SET IS-INVALID TO TRUE
               MOVE 'CET-SCORE MUST BE > 000' TO RPT-REASON
           END-IF

           IF IN-CATEGORY NOT = 'OPEN      ' AND 
              IN-CATEGORY NOT = 'OBC       ' AND
              IN-CATEGORY NOT = 'SC        ' AND 
              IN-CATEGORY NOT = 'ST        '
               SET IS-INVALID TO TRUE
               MOVE 'INVALID CATEGORY' TO RPT-REASON
           END-IF

           IF IN-GENDER NOT = 'M' AND IN-GENDER NOT = 'F'
               SET IS-INVALID TO TRUE
               MOVE 'GENDER MUST BE M OR F' TO RPT-REASON
           END-IF

           IF IN-DOMICILE NOT = 'MH-STATE       ' AND 
              IN-DOMICILE NOT = 'MH-OTHER       '
               SET IS-INVALID TO TRUE
               MOVE 'INVALID DOMICILE' TO RPT-REASON
           END-IF

           IF IN-ELIG-STATUS NOT = 'E'
               SET IS-INVALID TO TRUE
               MOVE 'ELIG-STATUS MUST BE E' TO RPT-REASON
           END-IF

           IF IS-VALID
               WRITE REC-OUT FROM REC-IN
               ADD 1 TO WS-RECS-VALID
           ELSE
               WRITE REC-REJ FROM REC-IN
               ADD 1 TO WS-RECS-REJECT
               MOVE IN-APP-ID TO RPT-APP-ID
               WRITE REC-RPT FROM WS-RPT-DETAIL
           END-IF

           READ APPLICIN
               AT END SET FS-IN-EOF TO TRUE
           END-READ.

       3000-FINISH.
           MOVE WS-RECS-READ TO RPT-TOT-READ
           WRITE REC-RPT FROM WS-RPT-SUMMARY
           MOVE WS-RECS-VALID TO RPT-TOT-VALID
           WRITE REC-RPT FROM WS-RPT-SUMMARY-V
           MOVE WS-RECS-REJECT TO RPT-TOT-REJ
           WRITE REC-RPT FROM WS-RPT-SUMMARY-R
           
           CLOSE APPLICIN VALIDOUT REJECTFL RPTFILE.
