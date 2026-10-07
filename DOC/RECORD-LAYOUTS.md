# Record Layouts

Detailed record layouts for ALL file types used in the Centralized University Admission System. All files use fixed-length sequential records (PS).

## 1. Application Record (LRECL=200)
Used in `APPRAW.dat` and `APPVALID.dat`.

| Field Name | Position | Length | PIC Clause | Description | Valid Values |
|------------|----------|--------|------------|-------------|--------------|
| APP-ID | 1-6 | 6 | X(06) | Application ID | Unique alphanumeric |
| STUDENT-ID | 7-14 | 8 | X(08) | Student ID | Unique alphanumeric |
| STUDENT-NAME | 15-44 | 30 | X(30) | Student Full Name | Alphabetic, spaces |
| CET-SCORE | 45-47 | 3 | 9(03) | Entrance Exam Score | 000-200 |
| CATEGORY | 48-57 | 10 | X(10) | Social Category | OPEN, OBC, SC, ST, NT |
| GENDER | 58-58 | 1 | X(01) | Gender | M, F, O |
| DOMICILE | 59-73 | 15 | X(15) | State Domicile | e.g., MAHARASHTRA |
| ELIG-STATUS | 74-74 | 1 | X(01) | Eligibility Status | Y, N |
| FILLER | 75-200 | 126 | X(126) | Space Padding | Spaces |

## 2. College/Seat Matrix Record (LRECL=200)
Used in `SEATMAT.dat`.

| Field Name | Position | Length | PIC Clause | Description | Valid Values |
|------------|----------|--------|------------|-------------|--------------|
| COLLEGE-ID | 1-4 | 4 | X(04) | College ID | Unique alphanumeric |
| COLLEGE-NAME | 5-34 | 30 | X(30) | College Name | Alphabetic, spaces |
| COURSE-ID | 35-38 | 4 | X(04) | Course ID | Unique alphanumeric |
| COURSE-NAME | 39-63 | 25 | X(25) | Course Name | Alphabetic, spaces |
| CATEGORY | 64-73 | 10 | X(10) | Seat Category | OPEN, OBC, SC, ST, NT |
| TOTAL-SEATS | 74-76 | 3 | 9(03) | Total Capacity | 000-999 |
| AVAIL-SEATS | 77-79 | 3 | 9(03) | Available Seats | 000-999 |
| FILLER | 80-200 | 121 | X(121) | Space Padding | Spaces |

## 3. Preference Record (LRECL=80)
Used in `PREFRAW.dat` and `PREFVAL.dat`.

| Field Name | Position | Length | PIC Clause | Description | Valid Values |
|------------|----------|--------|------------|-------------|--------------|
| APP-ID | 1-6 | 6 | X(06) | Application ID | Matches valid APP-ID |
| PREF-NUM | 7-8 | 2 | 9(02) | Preference Order | 01-99 |
| COLLEGE-ID | 9-12 | 4 | X(04) | College ID | Valid College ID |
| COURSE-ID | 13-16 | 4 | X(04) | Course ID | Valid Course ID |
| FILLER | 17-80 | 64 | X(64) | Space Padding | Spaces |

## 4. Merit List Record (LRECL=200)
Used in `MERIT.dat`.

| Field Name | Position | Length | PIC Clause | Description | Valid Values |
|------------|----------|--------|------------|-------------|--------------|
| MERIT-RANK | 1-4 | 4 | 9(04) | State Merit Rank | 0001-9999 |
| APP-ID | 5-10 | 6 | X(06) | Application ID | Unique alphanumeric |
| STUDENT-ID | 11-18 | 8 | X(08) | Student ID | Unique alphanumeric |
| STUDENT-NAME | 19-48 | 30 | X(30) | Student Full Name | Alphabetic, spaces |
| CET-SCORE | 49-51 | 3 | 9(03) | Entrance Exam Score | 000-200 |
| CATEGORY | 52-61 | 10 | X(10) | Social Category | OPEN, OBC, SC, ST, NT |
| GENDER | 62-62 | 1 | X(01) | Gender | M, F, O |
| DOMICILE | 63-77 | 15 | X(15) | State Domicile | e.g., MAHARASHTRA |
| FILLER | 78-200 | 123 | X(123) | Space Padding | Spaces |

## 5. Allotment Record (LRECL=250)
Used in `ALLOTR1.dat`, `ALLOTR2.dat`, `ALLOTR3.dat`.

| Field Name | Position | Length | PIC Clause | Description | Valid Values |
|------------|----------|--------|------------|-------------|--------------|
| APP-ID | 1-6 | 6 | X(06) | Application ID | Valid APP-ID |
| MERIT-RANK | 7-10 | 4 | 9(04) | State Merit Rank | 0001-9999 |
| STUDENT-ID | 11-18 | 8 | X(08) | Student ID | Valid Student ID |
| STUDENT-NAME | 19-48 | 30 | X(30) | Student Full Name | Alphabetic, spaces |
| COLLEGE-ID | 49-52 | 4 | X(04) | Allotted College ID | Valid College ID or Spaces if Unallotted |
| COLLEGE-NAME | 53-82 | 30 | X(30) | Allotted College Name | Alphabetic, spaces |
| COURSE-ID | 83-86 | 4 | X(04) | Allotted Course ID | Valid Course ID or Spaces |
| COURSE-NAME | 87-111 | 25 | X(25) | Allotted Course Name | Alphabetic, spaces |
| CATEGORY | 112-121 | 10 | X(10) | Seat Category | Category of the seat obtained |
| ALLOT-STATUS | 122-131 | 10 | X(10) | Allotment Status | ALLOTTED, UNALLOTTED |
| ALLOT-PREF | 132-133 | 2 | 9(02) | Preference Obtained | 01-99 or 00 |
| ROUND-NUM | 134-134 | 1 | 9(01) | Round Number | 1, 2, 3 |
| ACCEPT-FLAG | 135-135 | 1 | X(01) | Acceptance Status | F (Freeze), B (Betterment), R (Reject), Space |
| FILLER | 136-250 | 115 | X(115) | Space Padding | Spaces |

## 6. Acceptance Record (LRECL=80)
Used in `ACCEPTR1.dat`, `ACCEPTR2.dat`.

| Field Name | Position | Length | PIC Clause | Description | Valid Values |
|------------|----------|--------|------------|-------------|--------------|
| APP-ID | 1-6 | 6 | X(06) | Application ID | Valid APP-ID |
| ACCEPT-CODE | 7-7 | 1 | X(01) | Acceptance Code | F (Freeze), B (Betterment), R (Reject) |
| FILLER | 8-80 | 73 | X(73) | Space Padding | Spaces |

## 7. Fee Record (LRECL=200)
Used in `FEEDATA.dat` and `FEEFINAL.dat`.

| Field Name | Position | Length | PIC Clause | Description | Valid Values |
|------------|----------|--------|------------|-------------|--------------|
| STUDENT-ID | 1-8 | 8 | X(08) | Student ID | Valid Student ID |
| APP-ID | 9-14 | 6 | X(06) | Application ID | Valid APP-ID |
| STUDENT-NAME | 15-44 | 30 | X(30) | Student Full Name | Alphabetic, spaces |
| COLLEGE-ID | 45-48 | 4 | X(04) | College ID | Valid College ID |
| COURSE-ID | 49-52 | 4 | X(04) | Course ID | Valid Course ID |
| TUITION-FEE | 53-59 | 7 | 9(07) | Base Tuition Fee | Numeric |
| OTHER-FEE | 60-66 | 7 | 9(07) | Other Fees | Numeric |
| TOTAL-FEE | 67-73 | 7 | 9(07) | Total Required | Numeric |
| AMOUNT-PAID | 74-80 | 7 | 9(07) | Amount Paid by Student | Numeric |
| OUTSTANDING | 81-87 | 7 | 9(07) | Amount Remaining | Numeric |
| PAY-STATUS | 88-95 | 8 | X(08) | Payment Status | PAID, PENDING |
| FILLER | 96-200 | 105 | X(105) | Space Padding | Spaces |

## 8. Academic Record (LRECL=250)
Used in `ACADDATA.dat` and `RESULTS.dat`.

| Field Name | Position | Length | PIC Clause | Description | Valid Values |
|------------|----------|--------|------------|-------------|--------------|
| STUDENT-ID | 1-8 | 8 | X(08) | Student ID | Valid Student ID |
| APP-ID | 9-14 | 6 | X(06) | Application ID | Valid APP-ID |
| STUDENT-NAME | 15-44 | 30 | X(30) | Student Full Name | Alphabetic, spaces |
| COLLEGE-ID | 45-48 | 4 | X(04) | College ID | Valid College ID |
| COURSE-ID | 49-52 | 4 | X(04) | Course ID | Valid Course ID |
| SEMESTER | 53-54 | 2 | 9(02) | Current Semester | 01-08 |
| IA1-MARKS | 55-57 | 3 | 9(03) | Internal Assessment 1 | 000-025 |
| IA2-MARKS | 58-60 | 3 | 9(03) | Internal Assessment 2 | 000-025 |
| PRACT-MARKS | 61-63 | 3 | 9(03) | Practical Marks | 000-050 |
| ENDSEM-MARKS | 64-66 | 3 | 9(03) | End Semester Marks | 000-100 |
| ATTENDANCE | 67-69 | 3 | 9(03) | Attendance Percentage | 000-100 |
| TOTAL-MARKS | 70-73 | 4 | 9(04) | Total Marks (Max 200) | 0000-0200 |
| PERCENTAGE | 74-78 | 5 | 9(03)V9(02)| Overall Percentage | e.g., 08500 for 85.00% |
| GRADE | 79-80 | 2 | X(02) | Final Grade | A, B, C, D, F |
| BACKLOG-CNT | 81-82 | 2 | 9(02) | Number of Backlogs | 00-99 |
| RESULT-STATUS | 83-90 | 8 | X(08) | Result Outcome | PASS, FAIL, BACKLOG, WITHHELD |
| FEE-STATUS | 91-98 | 8 | X(08) | Associated Fee Status | PAID, PENDING |
| FILLER | 99-250 | 152 | X(152) | Space Padding | Spaces |
