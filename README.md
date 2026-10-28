#  SAT Verification: ezfact-shuffled

This repository contains the verified model certificate and the deterministic, zero-dependency streaming verifier for the `ezfact-shuffled` industrial instance from the Global SAT Database. 

### 📊 Dataset Integrity
* **Target Instance:** `instance.cnf`
* **Model Certificate:** `assignment.model`
* **Global SAT Database Hash:** `151e1995986dd49b41aae9866736caec`
* **Official Database Node:** [Global SAT Database Landing Page](https://benchmark-database.de)

---

### 🚀 Replication Instructions

The result can be independently verified by executing the streaming python verifier directly against the files in this directory.

#### 1. Prepare Environment
Ensure you have `instance.cnf` and `assignment.model` downloaded into the same directory as the script.

#### 2. Execute the Verifier
Run the zero-dependency verification engine via your terminal:
```bash
python Verifier.py
```

#### 3. Expected Output Log
A successful trace will read the literal mapping streams from the certificate file and validate all 19k+ constraints, printing the confirmation line:
```text
[*] Parsing certificate structure...
[*] Successfully isolated 3073 assignment vectors.
[*] Stream-verifying EZFECT instance...
Checked and validated 19785 distinct constraints.

===================================
s VERIFIED SATISFIABLE
===================================
```
