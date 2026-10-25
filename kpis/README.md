# Heat Network KPI Reference

Every key performance indicator the HNQAP platform computes for a heat
network, in one table per element type — energy centre, district
distribution, substation, communal distribution, consumer connection — with
the monitoring points each one reads, its threshold, and the calculation
written as compact maths. Published as a working basis for a proposed
British Standard on heat network KPIs.

| File | What it is | Use it for |
|---|---|---|
| `kpi-reference.md` | The tables, readable on GitHub | Browsing, citing a KPI by code |
| `kpi-reference.json` | The same tables as data: per element, per KPI — code, standing, title, monitoring points, threshold, calculation, period | Tools and agents: look a KPI up by code, compare implementations |
| `heat-network-kpi-reference.pdf` | The same tables as a printable landscape A4 document | Printing, attaching to a proposal |

Raw URL for tools: `https://raw.githubusercontent.com/heatweb/HNQAP/main/kpis/kpi-reference.json`

## What the tables contain

- **HNTAS KPIs** — the KPIs of the Heat Network Technical Assurance Scheme
  (Milestone 4 drafts), assessed or reported, as the platform computes them.
  Thresholds and methods are paraphrased from the scheme's drafts and
  interpreted where the drafts leave a choice; the scheme's own documents
  remain the authority for the scheme.
- **HNTAS-style KPIs** (`-C-` codes) — an HNTAS method applied where the
  scheme does not yet reach, starting with cooling at the consumer connection.
- **Heatweb KPIs** — diagnostic KPIs the scheme does not define: meter health
  (`-M-` codes) and hours below outage limits (`-H-` codes), offered as an
  alternative to the scheme's episode-counted outage KPIs.

A KPI marked **proposed** is defined here but not yet computed by the
platform. Thresholds marked "(proposed)" are put forward for review.

## Related

- [`standard/`](../standard/) — the data standard: the six-level address
  (`schema/network/element/device/vargroup/varkey`) that every monitoring
  point in these tables is read from, and the vocabulary of names.
- [`standard/BMS-CONNECTION-GUIDE.md`](../standard/BMS-CONNECTION-GUIDE.md) —
  how a BMS publishes those points over MQTT.

Comments, corrections and implementation reports are welcome as issues.
These tables are generated from the platform's KPI catalogue; they are
refreshed here with each change rather than edited by hand.
