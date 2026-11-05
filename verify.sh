#!/usr/bin/env bash

set -Eeuo pipefail

# ==========================================================
# SAT ASSIGNMENT VERIFICATION
#
# Benchmark: ezfact64_3.shuffled-as.sat03-1519
# Database: Global Benchmark Database
# GBD ID: 151e1995986dd49b41aae9866736caec
#
# ==========================================================

GBD_ID="151e1995986dd49b41aae9866736caec"

URL="https://benchmark-database.de/file/${GBD_ID}?context=cnf"

EXPECTED_CNF_HASH="cf9c4a0b7b9c6598430aeec515e44ccb0953bb6c424b167713b659fd3f9a310d"

EXPECTED_MODEL_HASH="03b606e4c26174ca573ce8d14ec0ed6e8e6c55cfa1036d556a5f0f82abd5735d"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

MODEL="$ROOT/assignment.model"
INSTANCE="$ROOT/instance.cnf"

TMP="$(mktemp -d)"

trap 'rm -rf "$TMP"' EXIT

# ----------------------------------------------------------
# SHA-256 FUNCTION
# ----------------------------------------------------------

sha256() {
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$1" | awk '{print $1}'
    elif command -v shasum >/dev/null 2>&1; then
        shasum -a 256 "$1" | awk '{print $1}'
    else
        echo "ERROR: SHA-256 utility unavailable."
        exit 1
    fi
}

# ----------------------------------------------------------
# DEPENDENCY CHECK
# ----------------------------------------------------------

for tool in curl xz awk cmp; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "ERROR: Missing dependency: $tool"
        exit 1
    fi
done

echo
echo "============================================"
echo "       SAT CERTIFICATE VERIFICATION"
echo "============================================"

# ----------------------------------------------------------
# DOWNLOAD ORIGINAL INSTANCE
# ----------------------------------------------------------

echo
echo "[1] Downloading original GBD instance..."

curl -fLsS --retry 3 "$URL" \
    -o "$TMP/instance.cnf.xz"

echo "Download successful."

# ----------------------------------------------------------
# XZ INTEGRITY
# ----------------------------------------------------------

echo
echo "[2] Checking compressed instance..."

xz -t "$TMP/instance.cnf.xz"

echo "XZ integrity: PASS"

# ----------------------------------------------------------
# DECOMPRESSION
# ----------------------------------------------------------

echo
echo "[3] Decompressing instance..."

xz -dc "$TMP/instance.cnf.xz" \
    > "$TMP/instance.cnf"

echo "Decompression: PASS"

# ----------------------------------------------------------
# INSTANCE HASH
# ----------------------------------------------------------

echo
echo "[4] Authenticating original instance..."

ACTUAL_CNF_HASH="$(sha256 "$TMP/instance.cnf")"

echo "Expected: $EXPECTED_CNF_HASH"
echo "Actual:   $ACTUAL_CNF_HASH"

if [[ "$ACTUAL_CNF_HASH" != "$EXPECTED_CNF_HASH" ]]; then
    echo "INSTANCE AUTHENTICATION: FAILED"
    exit 1
fi

echo "INSTANCE AUTHENTICATION: PASS"

# ----------------------------------------------------------
# LOCAL INSTANCE COMPARISON
# ----------------------------------------------------------

echo
echo "[5] Comparing repository instance..."

if [[ -f "$INSTANCE" ]]; then

    LOCAL_HASH="$(sha256 "$INSTANCE")"

    if [[ "$LOCAL_HASH" != "$EXPECTED_CNF_HASH" ]]; then
        echo "LOCAL INSTANCE HASH MISMATCH"
        exit 1
    fi

    if ! cmp -s "$INSTANCE" "$TMP/instance.cnf"; then
        echo "LOCAL INSTANCE DIFFERS FROM GBD DOWNLOAD"
        exit 1
    fi

    echo "LOCAL INSTANCE: IDENTICAL TO GBD"
else
    echo "ERROR: instance.cnf not found in repository."
    exit 1
fi

# ----------------------------------------------------------
# ASSIGNMENT HASH
# ----------------------------------------------------------

echo
echo "[6] Authenticating SAT assignment..."

if [[ ! -f "$MODEL" ]]; then
    echo "ERROR: assignment.model not found."
    exit 1
fi

ACTUAL_MODEL_HASH="$(sha256 "$MODEL")"

echo "Expected: $EXPECTED_MODEL_HASH"
echo "Actual:   $ACTUAL_MODEL_HASH"

if [[ "$ACTUAL_MODEL_HASH" != "$EXPECTED_MODEL_HASH" ]]; then
    echo "ASSIGNMENT AUTHENTICATION: FAILED"
    exit 1
fi

echo "ASSIGNMENT AUTHENTICATION: PASS"

# ----------------------------------------------------------
# DIRECT SAT VERIFICATION
# ----------------------------------------------------------

echo
echo "[7] Evaluating SAT assignment..."

awk -f "$ROOT/check_sat.awk" \
    "$MODEL" \
    "$TMP/instance.cnf"

echo
echo "============================================"
echo "       VERIFICATION COMPLETED"
echo "============================================"
