---
title: Getting started
description: How to start using HNQAP — publishing data from a BMS, building software against the JSON files, reading the KPI tables, and mapping a product's points.
section: Pages
---
# Getting started

Pick the route that matches what you do. Every route ends in the same
place: data published under one address, named from one vocabulary, and
measured with one set of KPIs.

## Controls and BMS engineers

1. **Read the [protocol](/protocol/).** It is ten short sections. The
   address is `schema/network/element/device/vargroup/varkey`.
2. **Agree the first two segments** with whoever receives the data: the
   `schema` (your organisation or the client's portfolio) and the `network`
   (the site).
3. **Name elements and devices.** Use the element for each part of the
   network (`ec1`, `ss1`, `cc14`). On monitored elements, name meters for
   the monitoring point they serve: `intake`, `offtake`, `boundary`.
4. **Use the standard names.** `tF` and `tR` for flow and return
   temperature, `kwh` for the energy register, `m3h` for flow rate. The
   [monitoring points](/monitoring-points/) table gives the address of every
   assurance point; search the [vocabulary](/vocabulary/) for the rest.
5. **Publish plain values over TLS**, one topic per point, on change of
   value with a periodic re-send. A Niagara station can publish its whole
   point list as one batch instead.

```
acme/riverside_court/ec1/boiler1/sensor/tF     71.8
acme/riverside_court/ss1/intake/hmeter/kwh     2918920
acme/riverside_court/global/network/design/gasCalorificValue   39.5
```

The [BMS connection guide](/bms-guide/) is a worked example for one platform
that runs the protocol, with Workbench steps for Niagara.

## Software developers and AI agents

The JSON files are the source of truth. Pin a copy and diff on refresh.

| File | Contents |
|---|---|
| [`kpi-reference.json`](/data/kpi-reference.json) | Per element type, per KPI: code, standing, title, monitoring points, threshold, calculation, period |
| [`vocabulary.json`](/data/vocabulary.json) | Every vargroup and varkey with type, units, meaning and aliases |
| [`monitoring-points.json`](/data/monitoring-points.json) | Every assurance monitoring point with its six-level address, units and frequency |

```bash
curl -s https://hnqap.org/data/kpi-reference.json | jq '.elements[] | select(.code=="SS") | .rows[] | {code, title, threshold}'
```

Things that save time:

- Parse topics **right-anchored**: the last six segments are the address.
- Store a non-numeric payload as text on the same address; never pull a
  number out of it.
- Resolve legacy names through `aliases` on read, and write registered
  names only.
- Every page on this site has a Markdown twin (`/kpis/index.md`), and
  [llms.txt](/llms.txt) lists them. [llms-full.txt](/llms-full.txt) is the
  whole standard in one file.

## Operators, consultants and assessors

1. **Open the [KPI reference](/kpis/).** One table per element type, in
   network order from the energy centre to the dwelling.
2. **Check the standing column.** "HNTAS" rows follow the scheme's drafts,
   paraphrased and interpreted where the drafts leave a choice. "HNTAS-style"
   rows apply the scheme's method where it does not reach yet, such as
   cooling. "Heatweb" rows are diagnostic KPIs offered for adoption.
3. **Cite KPIs by code** (`SS-KPI-07`) in reports and specifications. Each
   code has a stable page: [hnqap.org/kpis/ss-kpi-07/](/kpis/ss-kpi-07/).
4. **Print it.** The [PDF](/data/heat-network-kpi-reference.pdf) is the same
   tables on landscape A4.

## Manufacturers and integrators

Map your product's points to registered varkeys once, and every HNQAP
receiver can read them without a site-by-site mapping exercise.

1. List the points your product exposes.
2. Find each one in the [vocabulary](/vocabulary/) by meaning and units.
3. Where nothing fits, [propose a varkey](https://github.com/heatweb/HNQAP/issues/new?template=varkey-proposal.yml).
4. Publish the mapping as a table with your product documentation, and
   tell us so it can be linked from here.

## Next

When you have used any of it, [tell us what happened](/collaborate/). An
implementation report from a real network is the most valuable contribution
there is.
