#!/bin/bash

set -euo pipefail

echo
echo "=================================================="
echo "          SAT CERTIFICATE VERIFICATION"
echo "=================================================="

echo
echo "[1] Checking verification software..."

command -v gratchk

echo
echo "[2] Checking instance integrity..."

sha256sum instance.cnf

echo
echo "[3] Checking assignment integrity..."

sha256sum assignment.model

echo
echo "[4] Checking SAT assignment..."

gratchk sat instance.cnf assignment.vars

echo
echo "=================================================="
echo "          VERIFICATION COMPLETED"
echo "=================================================="
