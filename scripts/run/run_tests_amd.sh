#!/bin/bash
set -u
export TIMEOUT=1800
CSV=$REPO/results/_summary_amd.csv
echo "category,test,status,invalid,divzero,overflow,underflow,total,subnormal,kernels_launched,notes" > $CSV
for f in $(find $REPO/tests/amd/basic_test -name '*.hip' | sort); do
  cat=$(basename $(dirname "$f"))
  name=$(basename "$f" .hip)
  [[ "$name" == "logB_verify" ]] && continue
  echo ">>> $cat/$name"
  out=$(bash $REPO/scripts/buildScripts/run_hip_basictest.sh "$cat/$name" instrumented 2>&1)
  line=$(echo "$out" | grep -m1 'counts:')
  g(){ echo "$line" | grep -oE "$1=[0-9]+" | cut -d= -f2; }
  if [[ -n "$line" ]]; then
    echo "$cat,$name,ok,$(g invalid),$(g divzero),$(g overflow),$(g underflow),,$(g subnormal),1," | tee -a $CSV
  else
    echo "$cat,$name,FAIL,,,,,,,,run produced no counts" | tee -a $CSV
  fi
  sleep 5
done
echo; echo "=== $CSV ==="; column -s, -t < $CSV
