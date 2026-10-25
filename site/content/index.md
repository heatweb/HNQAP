---
title: HNQAP
description: Open standards for heat network quality assurance — one address for every data point, one vocabulary of names, and one reference of heat network KPIs, developed in the open with the industry.
section: Pages
---
# Open standards for heat network quality assurance

<p class="lead">HNQAP is where the heat network industry agrees, in the open, how
monitoring data is named and how performance is measured, so that the same
network gets the same answer whichever BMS, meter platform or analytics tool
it runs on.</p>

<div class="cards">
<a class="card" href="/protocol/"><strong>The protocol</strong><span>HNQAP-MQTT v1: a six-level address for every data point, from energy centre to dwelling.</span></a>
<a class="card" href="/vocabulary/"><strong>The vocabulary</strong><span>{{varkeyCount}} registered point names, each with one type and one set of units.</span></a>
<a class="card" href="/kpis/"><strong>The KPI reference</strong><span>{{kpiCount}} heat network KPIs, one table per element type, with thresholds and the calculation.</span></a>
</div>

## Why it matters now

Heat network technical assurance asks every network to monitor defined
points and report KPIs against thresholds. The scheme's drafts say what to
measure; they leave real choices about how. If every platform makes those
choices differently, one network can pass on one platform and fail on the
next.

HNQAP publishes one open, worked answer to each choice, and invites everyone
who operates, designs, builds, maintains or monitors heat networks to test
it and improve it. The aim is a reference good enough to put forward as a
British Standard on heat network KPIs.

## Get started

| You are… | Start with |
|---|---|
| A controls or BMS engineer connecting a site | [Publishing data](/getting-started/#controls-and-bms-engineers) |
| A software developer, or an AI agent | [Using the data files](/getting-started/#software-developers-and-ai-agents) |
| An operator, consultant or assessor | [Reading the KPI tables](/getting-started/#operators-consultants-and-assessors) |
| A manufacturer or integrator | [Mapping your product](/getting-started/#manufacturers-and-integrators) |
| Anyone who wants to help get the KPIs right | [Collaborate](/collaborate/) |

## What is open for comment

| Item | Status |
|---|---|
| [HNQAP-MQTT v1](/protocol/) | Draft for public comment |
| [KPI reference](/kpis/) | Draft, generated {{kpiGenerated}}. Cooling, meter-health and hours-below-outage KPIs carry proposed thresholds |
| [Vocabulary](/vocabulary/) | {{varkeyCount}} approved names, exported {{vocabExported}}. [Proposals](/vocabulary/proposed/) open |

## For machines

Everything here is also data. The [KPI reference](/data/kpi-reference.json)
and the [vocabulary](/data/vocabulary.json) are JSON; every page has a
Markdown twin at `index.md`; and [llms.txt](/llms.txt) maps the site for AI
agents. All of it is Apache-2.0 licensed: use it, build on it, and tell us
what you find.
