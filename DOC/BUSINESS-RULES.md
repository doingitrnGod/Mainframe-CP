# Business Rules

This document details all the business rules implemented in the Centralized University Admission and Student Processing System.

## 1. Application Validation Rules
Before an application is considered for merit processing, it must pass rigorous field-level validation.
- **APP-ID**: Must not be empty.
- **STUDENT-ID**: Must not be empty.
- **STUDENT-NAME**: Must not be empty.
- **CET-SCORE**: Must be numeric and between 000 and 200.
- **CATEGORY**: Must be one of `OPEN`, `OBC`, `SC`, `ST`, `NT`.
- **GENDER**: Must be `M`, `F`, or `O`.
- **ELIG-STATUS**: Must be `Y`. Applications with `N` are rejected.
- **Error Handling**: Records failing any of the above checks are written to `REJECTS.dat` with an appropriate error code (e.g., `INV-SCORE`, `INV-CAT`, `NOT-ELIG`).

## 2. Duplicate Removal Rules
- **Duplicate Key**: `STUDENT-ID`. A single student might apply multiple times.
- **Resolution**: If multiple records exist for the same `STUDENT-ID`, they are grouped.
- **Winner**: The record with the lowest (earliest) `APP-ID` is retained; others are dropped.

## 3. Merit Ranking Rules
After validation and deduplication, the system assigns a unique State Merit Rank.
- **Primary Sort**: Descending order of `CET-SCORE`.
- **Secondary Sort (Tiebreaker)**: Ascending order of `STUDENT-ID`. This ensures deterministic sorting and reproducible merit lists.
- **Ranking**: Starting from rank 0001 incrementing by 1 for each valid record.

## 4. Seat Allocation Rules
Allocation happens in three distinct rounds.
- **Processing Order**: Top-down based on State Merit Rank (Rank 0001 is processed first).
- **Category Matching**: A student can only claim a seat in their own `CATEGORY` or in the `OPEN` category.
- **Preference Order**: For a given student, the system checks their preferences strictly from lowest PREF-NUM (e.g., 01) to highest.
- **Allocation Decision**: The first preference where a valid seat (Matching Category > 0 OR Open Category > 0) is available is allocated.
- **Seat Deduction**: The `AVAIL-SEATS` count for that specific category in the seat matrix is decremented by 1 immediately.

## 5. Acceptance Rules (Post-Round 1 & 2)
After an allocation round, students must provide their acceptance choice via `ACCEPTRX.dat`.
- **Freeze (F)**: The student accepts the allotted seat and locks it. They will NOT participate in subsequent rounds.
- **Betterment (B)**: The student accepts the seat but wishes to upgrade in the next round. The current seat is held for them.
- **Reject (R)**: The student rejects the allotted seat. The seat is added back to the pool (`AVAIL-SEATS` + 1), and the student will participate in the next round as an unallotted candidate.
- **No Response (Space)**: Treated as Reject (seat released).

## 6. Betterment Rules (During Round 2 & 3)
For a student marked as Betterment (B) from a previous round:
- **Preference Consideration**: The system only evaluates preferences that have a *lower* `PREF-NUM` (i.e., a higher priority) than their currently allotted preference.
- **Upgrade Success**: If a seat is available in a higher preference, the student is allotted the new seat. Their old seat is released back to the general pool immediately.
- **Upgrade Failure**: If no higher preference seat is available, the student retains their previously allotted seat.

## 7. Fee Calculation Rules
Processed for final allotted students after Round 3.
- **Calculation**: `TOTAL-FEE` = `TUITION-FEE` + `OTHER-FEE`.
- **Balance**: `OUTSTANDING` = `TOTAL-FEE` - `AMOUNT-PAID`.
- **Status Determination**: 
  - If `OUTSTANDING` > 0, `PAY-STATUS` = `PENDING`.
  - If `OUTSTANDING` = 0, `PAY-STATUS` = `PAID`.

## 8. Academic Evaluation Rules
Processed at the end of the academic semester.
- **Marking Scheme**: 
  - IA1: Max 25 (Min passing: 10)
  - IA2: Max 25 (Min passing: 10)
  - Practical: Max 50 (Min passing: 20)
  - EndSem: Max 100 (Min passing: 40)
  - Total: Max 200
- **Total Calculation**: `TOTAL-MARKS` = `IA1-MARKS` + `IA2-MARKS` + `PRACT-MARKS` + `ENDSEM-MARKS`.
- **Percentage**: (`TOTAL-MARKS` / 200) * 100.
- **Grade Breakdown**:
  - >= 75%: A
  - >= 60%: B
  - >= 50%: C
  - >= 40%: D
  - < 40%: F
- **Result Status Determination Priority**:
  1. **Attendance**: If `ATTENDANCE` < 75%, `RESULT-STATUS` is immediately set to `FAIL`.
  2. **Backlog Check**: If any individual component (IA1, IA2, Pract, EndSem) is below the minimum passing marks, `RESULT-STATUS` = `BACKLOG`. `BACKLOG-CNT` is incremented.
  3. **Overall Check**: If `PERCENTAGE` < 40%, `RESULT-STATUS` = `FAIL`.
  4. **Fee Check**: If `PAY-STATUS` is `PENDING`, `RESULT-STATUS` = `WITHHELD` (regardless of academic performance).
  5. **Pass**: If none of the above apply, `RESULT-STATUS` = `PASS`.
