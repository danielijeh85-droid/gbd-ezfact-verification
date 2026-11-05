# SAT Certificate Verification — GBD Integer Factorisation Benchmark

## Overview

This repository contains a SAT assignment associated with an integer-factorisation benchmark instance from the Global Benchmark Database (GBD).

It provides:

- The original decompressed CNF benchmark instance.
- The corresponding SAT assignment in `.model` format.
- A Bash verification script.
- An AWK-based CNF assignment evaluator.
- Cryptographic fingerprints for authenticating the benchmark and assignment.
- A reproducible verification procedure.
- Evidence of a successful verification run.

The objective is to make the SAT assignment publicly available and enable independent researchers to authenticate the benchmark, inspect the assignment, and reproduce the verification.

The verification procedure successfully evaluated the published assignment against the original benchmark instance.

**Final result: 3,073 variables, 19,785 clauses checked, and zero violated clauses.**

---

## 1. Benchmark Identification

The benchmark used in this verification originates from the Global Benchmark Database.

| Property | Value |
|---|---|
| Database | Global Benchmark Database (GBD) |
| Benchmark ID | `151e1995986dd49b41aae9866736caec` |
| Original filename | `151e1995986dd49b41aae9866736caec-ezfact64_3.shuffled-as.sat03-1519.cnf.xz` |
| Benchmark category | Integer factorisation |
| File format | DIMACS CNF |
| Number of variables | 3,073 |
| Number of clauses | 19,785 |

### Original Benchmark Source

The original benchmark can be accessed directly from the Global Benchmark Database:

https://benchmark-database.de/file/151e1995986dd49b41aae9866736caec?context=cnf

The verification script retrieves the original compressed benchmark directly from this source rather than relying exclusively on the copy stored in this repository.

---

## 2. Repository Contents

The repository contains the following files:

| File | Description |
|---|---|
| `instance.cnf` | Decompressed CNF benchmark instance. |
| `assignment.model` | Published SAT assignment in SAT competition-style model format. |
| `verify.sh` | Bash script that downloads, authenticates, and verifies the benchmark and assignment. |
| `check_sat.awk` | AWK evaluator that checks the assignment against the CNF clauses. |
| `README.md` | Benchmark documentation and verification record. |

The assignment is supplied in a model format containing the SAT status and variable assignments.

The verification procedure uses the supplied assignment. It does not search for or generate a new satisfying assignment.

---

## 3. Cryptographic Authentication

SHA-256 fingerprints are provided to authenticate the original benchmark instance and the published SAT assignment.

These fingerprints allow anyone reproducing the verification to establish whether the files being examined are identical to the files published here.

### 3.1 Original Benchmark Instance

Expected SHA-256:

```text
cf9c4a0b7b9c6598430aeec515e44ccb0953bb6c424b167713b659fd3f9a310d
```

### 3.2 SAT Assignment

Expected SHA-256:

```text
03b606e4c26174ca573ce8d14ec0ed6e8e6c55cfa1036d556a5f0f82abd5735d
```

During verification, the downloaded benchmark and the published assignment are independently hashed and compared with their expected fingerprints.

Both authentication checks returned `PASS`.

---

## 4. Verification Methodology

The verification procedure consists of seven stages.

**Stage 1 — Original benchmark retrieval**

The script downloads the compressed benchmark directly from the Global Benchmark Database.

**Stage 2 — Compressed-file integrity**

The downloaded XZ archive is checked using the XZ integrity-testing utility.

**Stage 3 — Decompression**

The original compressed benchmark is decompressed to recover the DIMACS CNF instance.

**Stage 4 — Original instance authentication**

The decompressed benchmark is hashed using SHA-256 and compared with the expected fingerprint.

**Stage 5 — Repository instance comparison**

The downloaded original instance is compared byte-for-byte with the `instance.cnf` file published in this repository.

**Stage 6 — SAT assignment authentication**

The published assignment is independently hashed and compared with its expected SHA-256 fingerprint.

**Stage 7 — SAT assignment evaluation**

The assignment is evaluated against the CNF formula using the AWK evaluator.

The evaluator checks the clauses of the formula to determine whether the supplied variable assignments satisfy them.

A successful result requires every clause to evaluate as satisfied.

---

## 5. Requirements

The verification procedure uses standard Linux command-line utilities.

Required tools:

- Bash
- Git
- curl
- XZ utilities
- AWK
- SHA-256 utilities
- Standard Unix utilities

### Ubuntu / Debian Installation

Install the required dependencies:

```bash
sudo apt update

sudo apt install -y \
    git \
    curl \
    xz-utils \
    gawk \
    coreutils
```

### Google Colab Installation

The verification can also be performed using Google Colab.

Install the required dependencies in a Colab code cell:

```bash
!apt-get update -qq

!apt-get install -y \
    git \
    curl \
    xz-utils \
    gawk \
    coreutils
```

No Docker installation is required.

---

## 6. Reproducing the Verification

Independent researchers can reproduce the verification using the following procedure.

### Step 1 — Clone the repository

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
```

Replace `YOUR_GITHUB_REPOSITORY_URL` with the actual repository address.

### Step 2 — Enter the repository

```bash
cd YOUR_REPOSITORY_NAME
```

Replace `YOUR_REPOSITORY_NAME` with the repository directory name.

### Step 3 — Execute the verification script

```bash
bash verify.sh
```

The script will:

1. Retrieve the original GBD benchmark.
2. Check the compressed archive.
3. Decompress the benchmark.
4. Authenticate the original instance.
5. Compare the downloaded instance with the repository copy.
6. Authenticate the SAT assignment.
7. Evaluate the assignment against the CNF formula.

The verification results are printed directly to the terminal.

---

## 7. Verification Results

The published SAT assignment successfully passed the verification procedure.

### Verification Summary

| Verification stage | Result |
|---|---|
| Original GBD download | PASS |
| XZ integrity check | PASS |
| Decompression | PASS |
| Original instance SHA-256 authentication | PASS |
| Repository instance comparison | PASS |
| SAT assignment SHA-256 authentication | PASS |
| Variable evaluation | PASS |
| Clause evaluation | PASS |
| Final verification | SUCCESSFUL |

### Numerical Results

| Metric | Result |
|---|---:|
| Variables | 3,073 |
| Clauses checked | 19,785 |
| Violated clauses | **0** |

The evaluator reported:

```text
VERIFICATION SUCCESSFUL
SAT assignment satisfies every clause.
```

The result establishes that the supplied assignment satisfies every clause of the authenticated CNF benchmark instance.

---

## 8. Complete Verification Output

The following is the complete terminal output from the successful verification run.

It is reproduced here to provide a readable record of the individual verification stages and their results.

```text
============================================
       SAT CERTIFICATE VERIFICATION
============================================

[1] Downloading original GBD instance...
Download successful.

[2] Checking compressed instance...
XZ integrity: PASS

[3] Decompressing instance...
Decompression: PASS

[4] Authenticating original instance...
Expected: cf9c4a0b7b9c6598430aeec515e44ccb0953bb6c424b167713b659fd3f9a310d
Actual:   cf9c4a0b7b9c6598430aeec515e44ccb0953bb6c424b167713b659fd3f9a310d
INSTANCE AUTHENTICATION: PASS

[5] Comparing repository instance...
LOCAL INSTANCE: IDENTICAL TO GBD

[6] Authenticating SAT assignment...
Expected: 03b606e4c26174ca573ce8d14ec0ed6e8e6c55cfa1036d556a5f0f82abd5735d
Actual:   03b606e4c26174ca573ce8d14ec0ed6e8e6c55cfa1036d556a5f0f82abd5735d
ASSIGNMENT AUTHENTICATION: PASS

[7] Evaluating SAT assignment...

Variables:        3073
Clauses checked:  19785
Violated clauses: 0

VERIFICATION SUCCESSFUL
SAT assignment satisfies every clause.

============================================
       VERIFICATION COMPLETED
============================================
```

---

## 9. Verification Screenshots

The following screenshots document the execution of the verification procedure in Google Colab.

### Screenshot 1 — Verification Process

This screenshot documents the initial stages of the verification, including retrieval of the original benchmark, integrity checking, decompression, and authentication.

![Verification process](verification-start.png)

### Screenshot 2 — Successful Verification

This screenshot documents the final authentication results and the successful evaluation of the SAT assignment.

The final output reports:

- 3,073 variables.
- 19,785 clauses checked.
- Zero violated clauses.
- Successful verification.

![Successful verification](verification-success.png)

---

## 10. Independent Reproduction and Examination

Independent researchers are welcome to examine and reproduce the results.

The following materials are available in this repository:

1. The published CNF benchmark instance.
2. The SAT assignment.
3. The Bash verification script.
4. The AWK-based CNF evaluator.
5. The SHA-256 fingerprints.
6. The complete verification output.
7. Execution screenshots.

Researchers can independently download the original GBD benchmark, compare its fingerprint with the published value, authenticate the assignment, and execute the verification procedure.

The objective is to make the result transparent, reproducible, and open to independent examination.

---

## 11. Scope of Verification

This verification establishes the following:

1. The original benchmark was successfully retrieved from the identified GBD source.
2. The decompressed benchmark matches the published SHA-256 fingerprint.
3. The repository's CNF instance is identical to the downloaded original.
4. The published SAT assignment matches its recorded SHA-256 fingerprint.
5. The supplied assignment satisfies every clause of the CNF formula.

The verification specifically establishes the validity of the supplied SAT assignment with respect to the identified CNF instance.

It does not independently constitute a formal proof of the underlying integer factorisation outside the semantics of the benchmark encoding.

---

## Conclusion

The SAT assignment associated with the identified Global Benchmark Database integer-factorisation instance has successfully passed the published verification procedure.

**3,073 variables.**

**19,785 clauses checked.**

**Zero violated clauses.**

The original benchmark, SAT assignment, cryptographic fingerprints, and reproducible verification scripts are publicly available for independent examination.

Independent verification is welcome.
