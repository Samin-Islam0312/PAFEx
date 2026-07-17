#!/usr/bin/env python3
"""
Origination vs. propagation gap figure for PaeFEx.

Both series are DYNAMIC counts from the same run:
  - origination events     = sum of NATIVE-view 'dynamic' column (exceptions created)
  - propagated appearances = sum of RESULT-BITS-view 'dynamic' column
                             (special values appearing in result registers)

Run:  python3 plot_gap.py   ->  writes gap.pdf (vector, for LaTeX) and gap.png
"""
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

# benchmark : (precision, origination_events, propagated_appearances, origination_sites)
data = {
    "LU":       ("FP32",  2045,  2_883_175_929,  1),
    "GRAMSCHM": ("FP32",  2048, 17_184_061_439,  1),
    "myocyte":  ("FP64",  4545,        975_660, 29),
}

names  = list(data.keys())
orig   = [data[n][1] for n in names]
prop   = [data[n][2] for n in names]
sites  = [data[n][3] for n in names]
labels = [f"{n}\n({data[n][0]})" for n in names]

x = np.arange(len(names))
w = 0.38

fig, ax = plt.subplots(figsize=(7, 4))
ax.bar(x - w/2, orig, w, label="Origination events (PaeFEx native)", color="#2b6cb0")
ax.bar(x + w/2, prop, w, label="Propagated appearances (result-register)", color="#c05621")

ax.set_yscale("log")
ax.set_ylabel("Dynamic count (log scale)")
ax.set_xticks(x)
ax.set_xticklabels(labels)
ax.legend(frameon=False, fontsize=9, loc="upper right")
ax.grid(axis="y", which="both", ls=":", alpha=0.4)

for xi, s, o in zip(x, sites, orig):
    ax.annotate(f"{s} site{'s' if s != 1 else ''}",
                xy=(xi - w/2, o), xytext=(0, 4), textcoords="offset points",
                ha="center", va="bottom", fontsize=8, color="#2b6cb0")

for xi, o, p in zip(x, orig, prop):
    amp = p / o if o else 0
    ax.annotate(f"{amp:,.0f}x", xy=(xi + w/2, p), xytext=(0, 4),
                textcoords="offset points", ha="center", fontsize=8, color="#c05621")

fig.tight_layout()
fig.savefig("gap.pdf")
fig.savefig("gap.png", dpi=160)
print("wrote gap.pdf and gap.png")
