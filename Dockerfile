# ============================================================
# SAT CERTIFICATE VERIFICATION ENVIRONMENT
#
# Checker: GRATchk
# Purpose: Independently verify a SAT assignment against
#          the original DIMACS CNF instance.
#
# Benchmark:
# GBD: 151e1995986dd49b41aae9866736caec
# ============================================================

FROM ubuntu:22.04

# ------------------------------------------------------------
# 1. Environment configuration
# ------------------------------------------------------------

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /verification

# ------------------------------------------------------------
# 2. Install required system dependencies
# ------------------------------------------------------------

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    wget \
    xz-utils \
    coreutils \
    make \
    g++ \
    cmake \
    mlton \
    && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------
# 3. Install GRATchk
# ------------------------------------------------------------

RUN wget -O /tmp/gratchk.tgz \
    https://www21.in.tum.de/~lammich/grat/gratchk.tgz \
    && mkdir -p /tmp/gratchk \
    && tar -xzf /tmp/gratchk.tgz -C /tmp/gratchk \
    && make -C /tmp/gratchk/gratchk/code \
    && find /tmp/gratchk -type f -name gratchk -executable \
       -exec install -m 0755 {} /usr/local/bin/gratchk \; \
    && rm -rf /tmp/gratchk /tmp/gratchk.tgz

# ------------------------------------------------------------
# 4. Copy verification materials
# ------------------------------------------------------------

COPY instance.cnf /verification/instance.cnf

COPY assignment.model /verification/assignment.model

# ------------------------------------------------------------
# 5. Authenticate original instance and assignment
# ------------------------------------------------------------

RUN echo "cf9c4a0b7b9c6598430aeec515e44ccb0953bb6c424b167713b659fd3f9a310d  instance.cnf" \
    | sha256sum -c -

RUN echo "03b606e4c26174ca573ce8d14ec0ed6e8e6c55cfa1036d556a5f0f82abd5735d  assignment.model" \
    | sha256sum -c -

# ------------------------------------------------------------
# 6. Convert SAT Competition model format
#    into GRATchk variable assignment format.
#
# Original:
# s SATISFIABLE
# v -1 2 -3 ...
# v 4 -5 6 ...
#
# GRATchk input:
# -1 2 -3 ...
# 4 -5 6 ...
# 0
# ------------------------------------------------------------

RUN grep '^s SATISFIABLE$' assignment.model \
    && grep '^v ' assignment.model \
       | sed 's/^v[[:space:]]*//' \
       > assignment.vars \
    && printf '0\n' >> assignment.vars

# ------------------------------------------------------------
# 7. Verification entry point
# ------------------------------------------------------------

COPY verify.sh /verification/verify.sh

RUN chmod +x /verification/verify.sh

ENTRYPOINT ["/verification/verify.sh"]
