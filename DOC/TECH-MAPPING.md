# Mainframe Technology Mapping

This document maps the theoretical Mainframe concepts to their practical implementation within the Centralized University Admission System project.

## Technology Demonstration Table

| Sr. No. | Mainframe Concept | Where Demonstrated | File(s) | Description |
|---------|-------------------|-------------------|---------|-------------|
| 1 | JCL Job Card | All JCL files | `STEP*.jcl`, `MASTER.jcl` | Proper `JOB` statement with `CLASS`, `MSGCLASS`, and routing logic. |
| 2 | JCL EXEC Statement | All JCL files | `STEP*.jcl` | Use of `PGM=` to invoke COBOL load modules, `SORT` utility, and `IKJEFT01` (REXX). |
| 3 | JCL DD Statement | All JCL files | `STEP*.jcl` | Extensive dataset definitions using `DSN`, `DISP=(NEW,CATLG,DELETE)`, and `DCB` parameters. |
| 4 | Sequential (PS) Files | Entire project | All `.dat` files | Reading and writing fixed-length records across all processing steps. |
| 5 | DFSORT - Sorting | `STEP02` | `STEP02.jcl` | Sorting applications by CET score descending and ID ascending for the Merit List. |
| 6 | DFSORT - Dedup | `STEP01` | `STEP01.jcl` | Using `SUM FIELDS=NONE` on ID to remove duplicate application records. |
| 7 | DFSORT - INCLUDE | `STEP05` | `STEP05.jcl` | Filtering datasets using `INCLUDE COND=(...)` to separate allotted from unallotted students. |
| 8 | COBOL File I/O | All COBOL | `*.cbl` | Proper `SELECT`, `ASSIGN`, `FD` definitions, and `READ`/`WRITE` loops. |
| 9 | COBOL Record Matching | `FEEPROC` | `FEEPROC.cbl` | Matching sequential allotment files with sequential fee transaction files using key (STUDENT-ID). |
| 10 | COBOL Table Handling | `CAPALLOC` | `CAPALLOC.cbl` | Loading the SEATMAT into memory using one-dimensional arrays (`OCCURS`), with dynamic lookup. |
| 11 | COBOL Arithmetic | `ACADPROC` | `ACADPROC.cbl` | Using `COMPUTE` to calculate total marks and percentages with implied decimals (`V9(02)`). |
| 12 | COBOL Conditional | All COBOL | `*.cbl` | Extensive use of `IF/ELSE` and `EVALUATE` statements for complex business rule execution. |
| 13 | COBOL 88-Level | `APPVALID` | `APPVALID.cbl` | Using Level-88 condition names for validating categories and eligibility flags. |
| 14 | REXX String Handling | `VALIDATE` | `VALIDATE.rexx` | Utilizing `PARSE VAR` and `SUBSTR` to dissect record fields. |
| 15 | REXX File I/O | `SUMMARY` | `SUMMARY.rexx` | Using `EXECIO` for reading input datasets and writing output reports. |
| 16 | REXX Report Gen | `RPTGEN` | `RPTGEN.rexx` | Formatting numerical counts into human-readable tabular output. |
| 17 | Batch Processing | `MASTER.jcl` | `MASTER.jcl` | Tying 8 individual steps into a single cohesive end-to-end batch execution pipeline. |
| 18 | Conditional Exec | `MASTER.jcl` | `MASTER.jcl` | Using the `COND=` parameter to skip subsequent steps if an earlier step fails (RC > 0). |
| 19 | Record Validation | `APPVALID` | `APPVALID.cbl` | Robust field-level data verification prior to processing. |
| 20 | Multi-round Logic | CAP Rounds | `CAPALLOC.cbl` | Iterative stateful batch processing across multiple rounds using intermediate acceptance data. |

## Module Implementations

### 1. Application Validation (APPVALID)
- **Programs**: `APPVALID.cbl`, `STEP01.jcl`
- **Concepts**: COBOL File I/O, 88-level conditions, Data validation.
- **I/O Files**: Input (`APPRAW.dat`), Output (`APPVALID.dat`, `REJECTS.dat`).
- **Logic**: Reads raw data, validates format/range, writes good records forward and bad records to a reject file.

### 2. Merit Generation (MERITGEN)
- **Programs**: `STEP02.jcl`
- **Concepts**: DFSORT (Sorting), DFSORT (Tie-breaking).
- **I/O Files**: Input (`APPVALID.dat`), Output (`MERIT.dat`).
- **Logic**: Pure utility step. Sorts Valid applications descending by score, ascending by ID.

### 3. CAP Allocation (CAPALLOC)
- **Programs**: `CAPALLOC.cbl`, `STEP03/04/05.jcl`
- **Concepts**: COBOL Table Handling (`OCCURS`), Multi-file input matching, Complex nested `IF`/`EVALUATE`.
- **I/O Files**: Input (`MERIT.dat`, `PREFVAL.dat`, `SEATMAT.dat`), Output (`ALLOTRx.dat`).
- **Logic**: Loads seat matrix into an array. Reads merit records sequentially. Looks up preferences, decrements available seats in the array, outputs allotment record.

### 4. Fee Processing (FEEPROC)
- **Programs**: `FEEPROC.cbl`, `STEP06.jcl`
- **Concepts**: COBOL Record Matching, Arithmetic.
- **I/O Files**: Input (`ALLOTR3.dat`, `FEEDATA.dat`), Output (`FEEFINAL.dat`).
- **Logic**: Matches final allotments with financial data to determine outstanding balances and payment status.

### 5. Academic Evaluation (ACADPROC)
- **Programs**: `ACADPROC.cbl`, `STEP07.jcl`
- **Concepts**: Arithmetic (`COMPUTE`), Complex rule evaluation (dependencies on external flags like Fee Status).
- **I/O Files**: Input (`FEEFINAL.dat`, `ACADDATA.dat`), Output (`RESULTS.dat`).
- **Logic**: Calculates grades based on component marks, checks attendance thresholds, and sets WITHHELD status based on pending fees.

### 6. Summary Reporting (SUMMARY)
- **Programs**: `SUMMARY.rexx`, `STEP08.jcl`
- **Concepts**: REXX Scripting, EXECIO.
- **I/O Files**: Input (`RESULTS.dat`), Output (`SUMMARY.rpt`).
- **Logic**: Parses final datasets to extract statistics and prints a formatted report summary.
