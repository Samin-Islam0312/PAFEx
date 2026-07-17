#!/bin/bash
# fp_report.sh — join fp_sites.csv (index->file/func/line) with
# fp_site_counts.csv (index->counts) into a readable per-line report.
#
# Usage: ./fp_report.sh [sites.csv] [counts.csv]
# Output: a table sorted by total exceptions, with demangled kernel names.

SITES=${1:-fp_sites.csv}
COUNTS=${2:-fp_site_counts.csv}

if [ ! -f "$SITES" ];  then echo "missing $SITES";  exit 1; fi
if [ ! -f "$COUNTS" ]; then echo "missing $COUNTS"; exit 1; fi

# Header
printf "%-35s %-22s %6s | %7s %7s %7s %7s %7s | %7s\n" \
    "FILE" "KERNEL" "LINE" "INVAL" "DIV0" "OVFL" "UNFL" "SUBN" "TOTAL"
printf '%.0s-' {1..120}; echo

# Read counts into an associative array: idx -> "inv div ovf unf sub"
declare -A C
while IFS=, read -r idx inv div ovf unf sub; do
    [ "$idx" = "index" ] && continue          # skip header
    C[$idx]="$inv $div $ovf $unf $sub"
done < "$COUNTS"

# Walk sites; for each site that has nonzero counts, print joined+demangled row
while IFS=$'\t' read -r idx file func line; do
    [ "$idx" = "index" ] && continue
    counts="${C[$idx]}"
    [ -z "$counts" ] && continue               # no exceptions at this site
    read -r inv div ovf unf sub <<< "$counts"
    total=$((inv + div + ovf + unf + sub))
    [ "$total" -eq 0 ] && continue

    # demangle kernel name, strip argument list, shorten file to basename
    pretty=$(echo "$func" | c++filt | sed 's/(.*//')
    base=$(basename "$file")

    printf "%-35s %-22s %6s | %7s %7s %7s %7s %7s | %7s\n" \
        "$base" "$pretty" "$line" "$inv" "$div" "$ovf" "$unf" "$sub" "$total"
done < "$SITES" | sort -t'|' -k3 -nr        # sort by TOTAL column descending