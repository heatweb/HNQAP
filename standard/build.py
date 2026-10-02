#!/usr/bin/env python3
"""Regenerate vargroups.md and varkeys.md from vocabulary.json.

    python standard/build.py

No dependencies beyond the standard library. Run after every refresh of
vocabulary.json so the tables never drift from the data.
"""
import json
import pathlib
from collections import defaultdict

HERE = pathlib.Path(__file__).resolve().parent
doc = json.loads((HERE / "vocabulary.json").read_text(encoding="utf-8"))

def esc(s):
    return (s or "").replace("|", "\\|").replace("\n", " ").strip()

# ---- vargroups.md ---------------------------------------------------------
lines = ["# Vargroups", "", f"Generated from `vocabulary.json` exported {doc['exportedAt']}. {len(doc['vargroups'])} groups.", "",
         "| Vargroup | Title | Kind | Description | Varkeys |", "|---|---|---|---|---|"]
count = defaultdict(int)
for k in doc["varkeys"]:
    for g in k.get("vargroups", []):
        count[g] += 1
for g in doc["vargroups"]:
    name = g["name"] + (" *(retired)*" if g.get("retired") else "")
    lines.append(f"| `{name}` | {esc(g.get('title'))} | {g.get('kind','')} | {esc(g.get('description'))} | {count.get(g['name'], 0)} |")
(HERE / "vargroups.md").write_text("\n".join(lines) + "\n", encoding="utf-8")

# ---- varkeys.md -----------------------------------------------------------
by_group = defaultdict(list)
ungrouped = []
for k in doc["varkeys"]:
    gs = k.get("vargroups") or []
    if not gs:
        ungrouped.append(k)
    for g in gs:
        by_group[g].append(k)

out = ["# Varkeys", "", f"Generated from `vocabulary.json` exported {doc['exportedAt']}. {len(doc['varkeys'])} names.",
       "", "A varkey may be allowed under more than one vargroup; it is listed under each. The shape (type, units) is the same everywhere.", ""]
out.append("## Index")
for g in sorted(by_group):
    out.append(f"- [`{g}`](#{g}) ({len(by_group[g])})")
if ungrouped:
    out.append(f"- [not yet placed](#not-yet-placed) ({len(ungrouped)})")
out.append("")

def table(keys):
    rows = ["| Varkey | Type | Units | Title | Meaning | Aliases | Status |", "|---|---|---|---|---|---|---|"]
    for k in sorted(keys, key=lambda x: x["name"].lower()):
        rows.append(
            f"| `{k['name']}` | {k.get('type','')} | {esc(k.get('units'))} | {esc(k.get('title'))} | "
            f"{esc(k.get('meaning'))} | {esc(', '.join(k.get('aliases') or []))} | {k.get('status','')} |"
        )
    return rows

for g in sorted(by_group):
    out += [f"## {g}", ""] + table(by_group[g]) + [""]
if ungrouped:
    out += ["## not yet placed", "", "Registered names not yet seen under any vargroup.", ""] + table(ungrouped) + [""]
(HERE / "varkeys.md").write_text("\n".join(out) + "\n", encoding="utf-8")
print(f"vargroups.md: {len(doc['vargroups'])} groups; varkeys.md: {len(doc['varkeys'])} names")
