BEGIN {
    violated = 0
    clauses = 0
    clause_sat = 0
}

function fail(message) {
    print "ERROR: " message > "/dev/stderr"
    fatal = 1
    exit 2
}

# ==========================================================
# READ SAT MODEL
# ==========================================================

FILENAME == ARGV[1] {

    line = $0
    sub(/^[[:space:]]+/, "", line)

    if (line == "" || substr(line, 1, 1) == "c")
        next

    if (line ~ /^s[[:space:]]/) {

        if (line != "s SATISFIABLE")
            fail("Invalid SAT status")

        status_seen = 1
        next
    }

    if (line ~ /^v([[:space:]]|$)/) {

        sub(/^v[[:space:]]*/, "", line)

        n = split(line, tokens, /[[:space:]]+/)

        for (i = 1; i <= n; i++) {

            if (tokens[i] == "")
                continue

            if (tokens[i] !~ /^-?[0-9]+$/)
                fail("Invalid model literal")

            lit = tokens[i] + 0

            if (lit == 0) {
                model_terminated = 1
                continue
            }

            if (model_terminated)
                fail("Data after model terminator")

            v = (lit < 0 ? -lit : lit)
            value = (lit > 0 ? 1 : 0)

            if (v in assigned && values[v] != value)
                fail("Contradictory variable assignment")

            assigned[v] = 1
            values[v] = value
        }

        next
    }

    fail("Unexpected model format")
}

# ==========================================================
# READ DIMACS CNF AND EVALUATE CLAUSES
# ==========================================================

FILENAME == ARGV[2] {

    line = $0
    sub(/^[[:space:]]+/, "", line)

    if (line == "" || substr(line, 1, 1) == "c")
        next

    if (line ~ /^p[[:space:]]/) {

        n = split(line, header, /[[:space:]]+/)

        if (n != 4 || header[2] != "cnf")
            fail("Invalid DIMACS header")

        nvars = header[3] + 0
        expected_clauses = header[4] + 0

        header_seen = 1
        next
    }

    if (!header_seen)
        fail("Missing DIMACS header")

    n = split(line, tokens, /[[:space:]]+/)

    for (i = 1; i <= n; i++) {

        if (tokens[i] == "")
            continue

        if (tokens[i] !~ /^-?[0-9]+$/)
            fail("Invalid DIMACS literal")

        lit = tokens[i] + 0

        if (lit == 0) {

            clauses++

            if (!clause_sat)
                violated++

            clause_sat = 0

            continue
        }

        v = (lit < 0 ? -lit : lit)

        if (v > nvars)
            fail("Variable exceeds DIMACS header")

        if (!(v in assigned))
            fail("Unassigned variable")

        if (values[v] == (lit > 0 ? 1 : 0))
            clause_sat = 1
    }
}

# ==========================================================
# FINAL VALIDATION
# ==========================================================

END {

    if (fatal)
        exit 2

    if (!status_seen)
        fail("Missing SATISFIABLE status")

    if (!header_seen)
        fail("Missing DIMACS header")

    if (!model_terminated)
        fail("Missing model terminator")

    if (clauses != expected_clauses)
        fail("Clause count mismatch")

    for (v = 1; v <= nvars; v++) {

        if (!(v in assigned))
            fail("Incomplete assignment")
    }

    for (v in assigned) {

        if (v > nvars)
            fail("Assignment exceeds declared variable count")
    }

    print ""
    print "Variables:        " nvars
    print "Clauses checked:  " clauses
    print "Violated clauses: " violated

    if (violated > 0) {
        print "VERIFICATION FAILED"
        exit 1
    }

    print ""
    print "VERIFICATION SUCCESSFUL"
    print "SAT assignment satisfies every clause."
}
