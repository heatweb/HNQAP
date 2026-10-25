---
title: About HNQAP
description: What HNQAP is, who maintains it, how it is licensed and how to cite it.
section: Pages
---
# About HNQAP

HNQAP (Heat Network Quality Assurance Publications) is an open project for
quality assurance of heat networks and low-carbon building services. It
began as a set of open procedures, forms and database functions for
acceptance testing and KPI calculation, and now publishes the data standard
and KPI reference that sit underneath them.

The project builds only on open technologies: MQTT to move data,
PostgreSQL with TimescaleDB to store it, and Grafana or any other tool to
view it. Nothing in HNQAP needs a licence fee or proprietary hardware.

## What is in the repository

| Folder | Contents |
|---|---|
| [`standard/`](https://github.com/heatweb/HNQAP/tree/main/standard) | The data standard, vocabulary and BMS connection guide |
| [`kpis/`](https://github.com/heatweb/HNQAP/tree/main/kpis) | The KPI reference as Markdown, JSON and PDF |
| [`site/`](https://github.com/heatweb/HNQAP/tree/main/site) | The generator for this website |
| [`postgresql/`](https://github.com/heatweb/HNQAP/tree/main/postgresql) | Earlier SQL functions for a standardised database and KPI calculation |
| [`qa/`](https://github.com/heatweb/HNQAP/tree/main/qa), [`csv/`](https://github.com/heatweb/HNQAP/tree/main/csv) | Earlier acceptance-testing forms and question sets |
| [`drawings/`](https://github.com/heatweb/HNQAP/tree/main/drawings) | Standard schematic details |

## Maintainers

HNQAP is maintained by [Heatweb Solutions Ltd](https://heatweb.co.uk), a heat
network engineering company, and is generated from the KPI catalogue and
vocabulary registry of the platform Heatweb runs. Contributions from
anyone are welcome: see [Collaborate](/collaborate/).

## Independence

HNQAP is not part of, and is not endorsed by, the Heat Network Technical
Assurance Scheme. Where the KPI reference describes the scheme's KPIs, it
paraphrases the scheme's drafts and states where it has interpreted them.
The scheme's own documents remain the authority for the scheme.

## Licence

HNQAP is licensed under the
[Apache License 2.0](https://github.com/heatweb/HNQAP/blob/main/LICENSE). You
may use, copy, adapt and redistribute it, including commercially, with
attribution and a copy of the licence.

## Citing HNQAP

Every release is archived on Zenodo. The DOI
[10.5281/zenodo.23647605](https://doi.org/10.5281/zenodo.23647605) always
resolves to the latest version, and each release has its own DOI on that
page. Cite the release you used. The repository carries a
[`CITATION.cff`](https://github.com/heatweb/HNQAP/blob/main/CITATION.cff) file,
so GitHub's "Cite this repository" button gives the reference in APA or
BibTeX. For a single KPI, cite its code and page, for example
`SS-KPI-07, HNQAP Heat Network KPI Reference, https://hnqap.org/kpis/ss-kpi-07/`.
