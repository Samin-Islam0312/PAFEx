#!/bin/bash
# agg_result_sites.sh <run_dir>
# fp_result_counts.csv (per-site DYNAMIC counts) -> GPU-FPX unit: number of
# DISTINCT SITES nonzero in each class (NaN/Inf/Sub/Div0). Splits user vs
# library-internal (vendor math headers) so the tag0/tag1 delta is visible.
set -eu
D="${1:?usage: agg_result_sites.sh <run_dir>}"
RC="$D/fp_result_counts.csv"
SITES="$D/fp_sites.csv"
[ -f "$RC" ] || { echo "  (no fp_result_counts.csv - run with PASS_FLAGS=-result-class)"; exit 0; }
[ -f "$SITES" ] || { echo "  (no fp_sites.csv)"; exit 0; }

awk -F'\t' 'NR>1 && ($2 ~ /__clang_(hip|cuda)|ocml|ockl|\/lib\/clang\//){print $1}' "$SITES" > /tmp/_libidx.$$ || true

awk -F',' -v libf=/tmp/_libidx.$$ '
BEGIN { while ((getline l < libf) > 0) lib[l]=1 }
NR==1 { next }
{
  idx=$1; islib=(idx in lib)
  if ($2+0>0){ if(islib) nan_l++;  else nan_u++ }
  if ($3+0>0){ if(islib) inf_l++;  else inf_u++ }
  if ($4+0>0){ if(islib) sub_l++;  else sub_u++ }
  if ($5+0>0){ if(islib) div_l++;  else div_u++ }
}
END {
  printf "  result-sites USER : nan=%d inf=%d sub=%d div0=%d\n", nan_u+0,inf_u+0,sub_u+0,div_u+0
  printf "  result-sites LIB  : nan=%d inf=%d sub=%d div0=%d\n", nan_l+0,inf_l+0,sub_l+0,div_l+0
  printf "  result-sites TOTAL: nan=%d inf=%d sub=%d div0=%d  <- vs GPU-FPX\n", nan_u+nan_l+0,inf_u+inf_l+0,sub_u+sub_l+0,div_u+div_l+0
}' "$RC"
rm -f /tmp/_libidx.$$
