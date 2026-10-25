# Changelog

Each release is tagged. Changes to KPIs, the protocol or the vocabulary link
to the issue where they were discussed.

## 1.1.0 — 2026-10-25

- **hnqap.org**: the website, built from this repository on every push, with
  a page for every KPI, every vargroup and every monitoring point, Markdown
  twins of every page, `llms.txt` and a sitemap.
- **HNQAP-MQTT v1** (draft for public comment): the protocol stated as a
  specification, with conformance levels.
- **Monitoring points** (`standard/monitoring-points.json`): every assurance
  monitoring point with its six-level address, units and minimum frequency.
- **KPI reference** (`kpis/`): 92 KPIs in one table per element type, as
  Markdown, JSON and PDF, including proposed cooling, meter-health and
  hours-below-outage KPIs.
- Collaboration: contributing guide, issue forms for KPI comments,
  implementation reports, protocol comments and varkey proposals, and the
  decision process.
- Citation file. The `broswerware` folder is renamed `browserware`. Example
  site names and service hosts removed from the legacy Node-RED flows.

## 1.0.0

- Data standard (`standard/`): six-level address, vocabulary of vargroups
  and varkeys, BMS connection guide.
- Earlier publications: acceptance-testing forms and question sets,
  PostgreSQL functions, Grafana dashboards, schematic details.
