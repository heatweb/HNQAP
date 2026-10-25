---
title: Collaborate
description: How the heat network industry works together on HNQAP to get the KPIs and assurance monitoring right — what needs review, how to take part, how decisions are made, and the route to a British Standard.
section: Pages
---
# Collaborate: getting the KPIs over the line

Heat network technical assurance will judge networks on KPIs computed from
monitoring data. Those judgements are only fair if every platform computes
each KPI the same way, and only useful if the thresholds reflect how real
networks behave. Neither can be settled by one company. HNQAP is the open
place to settle them.

## Where help is needed most

1. **Review the proposed thresholds.** Rows marked "(proposed)" in the
   [KPI reference](/kpis/) are starting points: cooling at the consumer
   connection, meter health, and hours below outage limits. Is the number
   right for the networks you know?
2. **Send an implementation report.** Run a KPI on your network's data and
   report the result, the data you used and anything that surprised you.
   Evidence from many networks and many platforms is what turns a proposal
   into a standard.
3. **Record your interpretation.** Where the scheme's drafts leave a choice,
   such as how an interruption is counted or how volume weighting pairs
   readings, say what you do and why. The reference states one answer; the
   discussion shows whether it is the right one.
4. **Map your equipment.** Manufacturers and integrators: map your
   product's points to the [vocabulary](/vocabulary/) and publish the table.
5. **Propose names.** If a point has no registered varkey,
   [propose one](https://github.com/heatweb/HNQAP/issues/new?template=varkey-proposal.yml).
6. **Build tools.** Open implementations of the KPIs or the protocol in any
   language are welcome, here or in your own repository.

## How to take part

| To… | Use |
|---|---|
| Comment on one KPI | The **Discuss this KPI** link on its page, or the [KPI comment form](https://github.com/heatweb/HNQAP/issues/new?template=kpi-comment.yml) |
| Report results from a network | The [implementation report form](https://github.com/heatweb/HNQAP/issues/new?template=implementation-report.yml) |
| Comment on the protocol | The [protocol comment form](https://github.com/heatweb/HNQAP/issues/new?template=protocol-comment.yml) |
| Propose a name | The [varkey proposal form](https://github.com/heatweb/HNQAP/issues/new?template=varkey-proposal.yml) |
| Ask a question or float an idea | [Discussions](https://github.com/heatweb/HNQAP/discussions) |
| Change the text | A pull request; see [CONTRIBUTING](https://github.com/heatweb/HNQAP/blob/main/CONTRIBUTING.md) |

All of these need a free GitHub account. Everything posted is public.

**Never post client data.** Report results as figures and describe the
network in general terms (type, size, age, plant). Name the KPI, the period
and the threshold; leave out the site.

## How decisions are made

1. A change starts as an issue: a comment, a report or a proposal.
2. Discussion happens on the issue, in public.
3. The maintainers propose a resolution and label it **proposed
   resolution**. It stays open for comment for at least 14 days.
4. The change is merged, recorded in the
   [changelog](https://github.com/heatweb/HNQAP/blob/main/CHANGELOG.md) with
   a link to the issue, and included in the next tagged release.
5. Where people disagree, the issue records both positions and the reason
   for the decision.

The maintainers today are Heatweb Solutions Ltd, who started the project.
As regular contributors join, the intention is a steering group drawn from
operators, consultants, designers, installers, manufacturers and metering
providers, with the same open process.

## The route to a standard

| Stage | What it takes | Where we are |
|---|---|---|
| 1. Open draft | KPI tables, protocol and vocabulary published and open for comment | **Now** |
| 2. Evidence | Implementation reports from several networks and several platforms; thresholds revised on the evidence | Starting |
| 3. Version 1.0 | Reference frozen, with every interpretation and its reasoning recorded | Next |
| 4. Proposal | Version 1.0 put to the national standards body as a proposal for new work, with the open reference as the starting text | After 1.0 |

The reference stays open and maintained whatever happens at stage 4.

## Ground rules

- Be specific: name the KPI code, the clause or the varkey.
- Paraphrase the scheme's documents and cite them; do not paste their text.
- Disagree with the method, not the person. The project follows the
  [Contributor Covenant](https://www.contributor-covenant.org/version/2/1/code_of_conduct/).
