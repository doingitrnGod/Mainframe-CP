# Centralized University Admission and Student Processing System

## Using Mainframe Technologies (COBOL, JCL, DFSORT, REXX)

---

## 1. Project Description

This project simulates a complete, end-to-end **Centralized Admission Process (CAP)** modeled after the Maharashtra state engineering admission system. It demonstrates a robust batch processing pipeline using traditional Mainframe technologies.

**Key Features:**
- Application validation and duplicate removal
- Merit list generation with deterministic tie-breaking
- Three rounds of category-based seat allocation (CAP Rounds 1, 2, 3)
- Freeze / Betterment / Reject workflows
- Fee processing with PAID / PARTIAL / PENDING status
- Academic result evaluation with PASS / FAIL / BACKLOG / WITHHELD outcomes
- Comprehensive summary reports

---

## 2. Project Architecture

```
PROJECT/
├── JCL/                    Job Control Language scripts
│   ├── STEP01.jcl          Application validation & dedup
│   ├── STEP02.jcl          Merit list generation (SORT + rank)
│   ├── STEP03.jcl          CAP Round 1 allocation
│   ├── STEP04.jcl          CAP Round 2 (with betterment)
│   ├── STEP05.jcl          CAP Round 3 + final allotment
│   ├── STEP06.jcl          Fee processing
│   ├── STEP07.jcl          Academic processing & results
│   ├── STEP08.jcl          Final summary reports
│   └── MASTER.jcl          Master job (runs all steps)
├── COBOL/                  COBOL programs (core business logic)
│   ├── APPVALID.cbl        Application validation
│   ├── MERITGEN.cbl        Merit rank assignment
│   ├── CAPALLOC.cbl        CAP round seat allocation
│   ├── FEEPROC.cbl         Fee processing & matching
│   ├── ACADPROC.cbl        Academic record processing
│   ├── RESULTPR.cbl        Result & eligibility validation
│   └── FINALRPT.cbl        Final comprehensive report
├── REXX/                   REXX utility scripts
│   ├── VALIDATE.rexx       Data validation cross-check
│   ├── DUPECHECK.rexx      Duplicate detection report
│   ├── SUMMARY.rexx        Final processing summary
│   ├── ERRRPT.rexx         Error/exception report
│   └── RPTGEN.rexx         Formatted report generator
├── DATA/                   Input data files
│   ├── APPLICANTS.dat      55 raw applications (50 unique + 5 dupes)
│   ├── COLLEGES.dat        56 seat matrix records (5 colleges)
│   ├── PREFERENCES.dat     189 preference records (47 candidates)
│   ├── ACCEPT1.dat         Round 1 acceptance decisions
│   ├── ACCEPT2.dat         Round 2 acceptance decisions
│   ├── ACCEPT3.dat         Round 3 acceptance decisions
│   ├── FEEPAY.dat          40 fee payment records
│   └── ACADEMIC.dat        40 academic records (Semester 1)
├── OUTPUT/                 Generated output files (created at runtime)
├── DOC/                    Documentation
│   ├── RECORD-LAYOUTS.md   Detailed record layouts
│   ├── BUSINESS-RULES.md   Business rules document
│   ├── DEMO-SCRIPT.md      External examiner demo script
│   └── TECH-MAPPING.md     Mainframe technology mapping
└── README.md               This file
```

---

## 3. System Flow

```
Raw Applications (55 records)
    │
    ▼
┌──────────────────────────┐
│ STEP01: Validation &     │  COBOL: APPVALID.cbl
│         Deduplication     │  SORT:  SUM FIELDS=NONE
│                          │  REXX:  DUPECHECK.rexx
│ → 3 rejected (invalid)  │
│ → 5 duplicates removed   │
│ → 47 clean candidates    │
└──────────────────────────┘
    │
    ▼
┌──────────────────────────┐
│ STEP02: Merit List       │  SORT:  CET DESC, STID ASC
│                          │  COBOL: MERITGEN.cbl
│ → 47 ranked candidates   │
└──────────────────────────┘
    │
    ▼
┌──────────────────────────┐
│ STEP03: CAP Round 1      │  COBOL: CAPALLOC.cbl
│                          │
│ → ~35 allotted           │
│ → ~12 unallotted         │
└──────────────────────────┘
    │ + ACCEPT1.dat (F/B/R)
    ▼
┌──────────────────────────┐
│ STEP04: CAP Round 2      │  COBOL: CAPALLOC.cbl
│                          │
│ → Betterment cases       │
│ → New allotments         │
└──────────────────────────┘
    │ + ACCEPT2.dat
    ▼
┌──────────────────────────┐
│ STEP05: CAP Round 3      │  COBOL: CAPALLOC.cbl
│         + Final Lists    │  SORT:  INCLUDE/OMIT
│                          │
│ → Final allotment list   │
│ → Unallotted list        │
│ → Vacancy report         │
└──────────────────────────┘
    │
    ▼
┌──────────────────────────┐
│ STEP06: Fee Processing   │  COBOL: FEEPROC.cbl
│                          │
│ → PAID / PARTIAL /       │
│   PENDING status         │
└──────────────────────────┘
    │
    ▼
┌──────────────────────────┐
│ STEP07: Academic Results │  COBOL: ACADPROC.cbl
│                          │  COBOL: RESULTPR.cbl
│ → PASS / FAIL /          │
│   BACKLOG / WITHHELD     │
└──────────────────────────┘
    │
    ▼
┌──────────────────────────┐
│ STEP08: Final Reports    │  COBOL: FINALRPT.cbl
│                          │  REXX:  SUMMARY.rexx
│ → Processing summary     │
│ → Statistics report       │
└──────────────────────────┘
```

---

## 4. Record Layouts (Summary)

| File Type     | LRECL | RECFM | Description                       |
|---------------|-------|-------|-----------------------------------|
| Application   | 200   | FB    | Candidate applications            |
| College/Seats | 200   | FB    | College-course-category seat matrix|
| Preference    | 80    | FB    | Student preference list           |
| Merit List    | 200   | FB    | Ranked eligible candidates        |
| Allotment     | 250   | FB    | CAP round allotment records       |
| Acceptance    | 80    | FB    | Freeze/Betterment/Reject decisions|
| Fee           | 200   | FB    | Fee payment status                |
| Academic      | 250   | FB    | Semester marks and results        |

> For detailed column-level layouts, see [DOC/RECORD-LAYOUTS.md](DOC/RECORD-LAYOUTS.md)

---

## 5. Setup & Execution Instructions

### On a Mainframe (z/OS):

1. **Upload files** to the mainframe using FTP or ISPF:
   ```
   USERID.ADMIT.DATA.APPLICANTS   ← DATA/APPLICANTS.dat
   USERID.ADMIT.DATA.COLLEGES     ← DATA/COLLEGES.dat
   USERID.ADMIT.DATA.PREFS        ← DATA/PREFERENCES.dat
   USERID.ADMIT.DATA.ACCEPT1      ← DATA/ACCEPT1.dat
   USERID.ADMIT.DATA.ACCEPT2      ← DATA/ACCEPT2.dat
   USERID.ADMIT.DATA.ACCEPT3      ← DATA/ACCEPT3.dat
   USERID.ADMIT.DATA.FEEPAY       ← DATA/FEEPAY.dat
   USERID.ADMIT.DATA.ACADEMIC     ← DATA/ACADEMIC.dat
   ```

2. **Compile COBOL programs**:
   ```jcl
   //COMPILE  EXEC IGYWCLG
   //COBOL.SYSIN DD DSN=USERID.ADMIT.COBOL(APPVALID),DISP=SHR
   //LKED.SYSLMOD DD DSN=USERID.ADMIT.LOADLIB(APPVALID),DISP=SHR
   ```
   Repeat for: MERITGEN, CAPALLOC, FEEPROC, ACADPROC, RESULTPR, FINALRPT

3. **Execute step-by-step**:
   ```
   STEP01.jcl → STEP02.jcl → STEP03.jcl → STEP04.jcl →
   STEP05.jcl → STEP06.jcl → STEP07.jcl → STEP08.jcl
   ```
   Or run `MASTER.jcl` for the entire pipeline.

4. **View output** in `USERID.ADMIT.OUTPUT.*` datasets.

### On a Mainframe Emulator (Hercules / zD&T):

Same process as above. Ensure the emulator has DFSORT and the COBOL compiler available.

### For Academic Demonstration (without a mainframe):

The project can be **reviewed and explained** directly from the source files:
- Open COBOL programs to show the logic
- Open JCL to show batch processing concepts
- Open data files to show fixed-length record formats
- Use the [Demo Script](DOC/DEMO-SCRIPT.md) to walk through the system

---

## 6. JCL Execution Order

| Step | JCL File    | Purpose                              | COBOL Program | SORT/REXX |
|------|-------------|--------------------------------------|---------------|-----------|
| 1    | STEP01.jcl  | Validate apps + Remove duplicates    | APPVALID      | SORT, DUPECHECK.rexx |
| 2    | STEP02.jcl  | Sort by CET score + Assign ranks     | MERITGEN      | SORT |
| 3    | STEP03.jcl  | CAP Round 1 allocation               | CAPALLOC      | SORT |
| 4    | STEP04.jcl  | Process ACCEPT1 + CAP Round 2        | CAPALLOC      | - |
| 5    | STEP05.jcl  | Process ACCEPT2 + CAP Round 3 + Finals| CAPALLOC     | SORT (INCLUDE/OMIT) |
| 6    | STEP06.jcl  | Fee processing                       | FEEPROC       | SORT |
| 7    | STEP07.jcl  | Academic evaluation + Results        | ACADPROC, RESULTPR | SORT |
| 8    | STEP08.jcl  | Final summary reports                | FINALRPT      | SUMMARY.rexx |

---

## 7. Sample Data Highlights

### Key Demonstration Candidates:

| Student ID | Name             | CET | Category | Demo Purpose                        |
|-----------|------------------|-----|----------|-------------------------------------|
| ST000001  | AARAV SHARMA     | 185 | OPEN     | Top scorer → Pref 1 → Freeze → PASS |
| ST000010  | PRIYA KULKARNI   | 156 | OPEN     | Gets Pref 3 in R1 → Betterment in R2 |
| ST000025  | SURESH GAIKWAD   | 112 | SC       | Unallotted R1 → Allotted R2         |
| ST000047  | YASH BHOSALE     | 048 | ST       | Always unallotted (no ST seats)     |
| ST000003  | RAVI DESHMUKH    | 178 | OPEN     | Good marks but PENDING fee → WITHHELD|
| ST000015  | ANIL JADHAV      | 140 | OBC      | Low EndSem marks → BACKLOG          |
| ST000020  | SNEHA PATIL      | 125 | OBC      | Attendance < 75% → FAIL             |
| ST000048  | INVALID SCORE    | 000 | OPEN     | CET = 000 → Rejected in validation  |
| ST000049  | INVALID DOMICILE | 150 | OPEN     | OUTSIDE domicile → Rejected         |
| ST000050  | (blank name)     | 160 | OPEN     | Blank name → Rejected               |

### Data Statistics:
- **55** raw application records (50 unique + 5 duplicates)
- **5** colleges, **14** college-course combinations
- **56** seat matrix entries across OPEN/OBC/SC/ST categories
- **66** total seats
- **189** preference records
- **40** fee payment records
- **40** academic records

---

## 8. Mainframe Technology Mapping

| Mainframe Concept         | Where Demonstrated           | Files                        |
|--------------------------|------------------------------|------------------------------|
| JCL Job Card             | Every batch job              | All STEP*.jcl, MASTER.jcl   |
| JCL EXEC PGM=            | Program execution            | All JCL files                |
| JCL DD Statement         | File/dataset definitions     | All JCL files                |
| JCL COND Parameter       | Conditional step execution   | MASTER.jcl                   |
| Sequential PS Files      | All data storage             | All .dat files               |
| Fixed-Length Records (FB) | Record processing            | All programs                 |
| DFSORT - Sorting         | Merit list, allotment sort   | STEP02, STEP03, STEP05       |
| DFSORT - Dedup           | Duplicate removal            | STEP01 (SUM FIELDS=NONE)    |
| DFSORT - INCLUDE/OMIT    | Filter allotted/unallotted   | STEP05                       |
| COBOL File I/O           | READ/WRITE sequential files  | All .cbl programs            |
| COBOL Table Handling      | Seat matrix OCCURS array     | CAPALLOC.cbl                 |
| COBOL Record Matching    | Fee ↔ allotment matching     | FEEPROC.cbl                  |
| COBOL Arithmetic          | Percentage/fee calculation   | ACADPROC.cbl, FEEPROC.cbl   |
| COBOL 88-Level Conditions| Validation flags             | APPVALID.cbl                 |
| COBOL EVALUATE           | Grade determination          | ACADPROC.cbl                 |
| REXX String Handling      | PARSE, SUBSTR for data       | VALIDATE.rexx                |
| REXX File I/O (EXECIO)   | Reading datasets             | All .rexx scripts            |
| REXX Report Generation   | Formatted reports            | SUMMARY.rexx, RPTGEN.rexx   |
| Batch Multi-Step Processing| End-to-end pipeline         | MASTER.jcl                   |

> For detailed mapping, see [DOC/TECH-MAPPING.md](DOC/TECH-MAPPING.md)

---

## 9. Business Rules Summary

- **Validation**: APP-ID starts with 'A', STUDENT-ID starts with 'ST', CET > 0, valid category/gender/domicile
- **Dedup**: Duplicate STUDENT-IDs eliminated; keep lowest APP-ID
- **Merit**: Sort CET descending, tie-break by STUDENT-ID ascending
- **Allocation**: Process in merit order; check preferences sequentially; match category to available seats
- **Acceptance**: Freeze (locked), Betterment (upgrade possible), Reject (seat released)
- **Fees**: Tuition varies by college (₹1,00,000 - ₹1,50,000) + ₹15,000 other fees
- **Academics**: Min IA1≥8, IA2≥8, Pract≥20, EndSem≥35, Attendance≥75%, Overall≥40%
- **Results**: FAIL (attendance/overall), BACKLOG (component fail), WITHHELD (fee pending), PASS

> For comprehensive rules, see [DOC/BUSINESS-RULES.md](DOC/BUSINESS-RULES.md)

---

## 10. Demonstration Guide

For a step-by-step external examiner demonstration, see [DOC/DEMO-SCRIPT.md](DOC/DEMO-SCRIPT.md).

---

## 11. Credits

Developed as an academic demonstration of Mainframe Technologies and batch processing workflows for centralized university admissions, based on the Maharashtra CAP admission model.

**Technologies Used**: COBOL, JCL, DFSORT, REXX, Sequential (PS) Files
