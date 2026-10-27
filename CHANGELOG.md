# Changelog

Each release is tagged. Changes to KPIs, the protocol or the vocabulary link
to the issue where they were discussed.

## Unreleased

- **KPI reference: departures from the published methods.** A new section
  lists, with the issue that argues each one, where this reference
  deliberately differs from the published methods. The KPI pages concerned
  say so too.
  - Out-of-range bounds on cumulative energy and volume registers (all
    KPI-03, and the rule that excludes out-of-range readings): register
    channels take bounds from the meters' register span, set per network,
    instead of the data-pilot 0–55,000 kWh / 0–10,000 m³ ranges, which fail
    healthy long-lived meters (#4).
  - CC-KPI-08 VWATD from the energy and volume register increase, not
    estimated from the volume-weighted temperatures (#3).
  - KPI-01 and KPI-02 over the points a network has: required points
    minus those declared not installed, with a reason (#5).
- **Monitoring point coverage** (`-A-01` on every element type): the
  required points installed and mapped, target 100%, the companion to
  KPI-01 and KPI-02 (#5).
- KPI-02 completeness counts readings per channel (a heat meter is six
  data points), stated in the rules that apply to every KPI.

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
