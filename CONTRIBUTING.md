# Contributing to HNQAP

HNQAP is where the heat network industry agrees, in the open, how
monitoring data is named and how performance is measured. Comments,
evidence and corrections from anyone who operates, designs, builds,
maintains or monitors heat networks are welcome. The overview is at
[hnqap.org/collaborate](https://hnqap.org/collaborate/).

## Ways to contribute

| To… | Open |
|---|---|
| Comment on one KPI | [KPI comment](https://github.com/heatweb/HNQAP/issues/new?template=kpi-comment.yml) |
| Report how a KPI behaves on a real network | [Implementation report](https://github.com/heatweb/HNQAP/issues/new?template=implementation-report.yml) |
| Comment on the protocol or a monitoring point address | [Protocol comment](https://github.com/heatweb/HNQAP/issues/new?template=protocol-comment.yml) |
| Propose a varkey or vargroup | [Varkey proposal](https://github.com/heatweb/HNQAP/issues/new?template=varkey-proposal.yml) |
| Ask a question or float an idea | [Discussions](https://github.com/heatweb/HNQAP/discussions) |
| Fix wording on the website | A pull request against `site/content/` |

## What not to edit by hand

These files are generated from the platform's KPI catalogue and vocabulary
registry. Propose changes as issues; edits made directly are overwritten on
the next refresh.

- `kpis/kpi-reference.md`, `kpis/kpi-reference.json`, `kpis/heat-network-kpi-reference.pdf`
- `standard/vocabulary.json`, `standard/varkeys.md`, `standard/vargroups.md`
- `standard/monitoring-points.json`

Everything under `site/content/` is hand-written and open to pull requests.

## How decisions are made

1. A change starts as an issue.
2. Discussion happens on the issue, in public.
3. The maintainers propose a resolution and label the issue
   `proposed resolution`. It stays open for comment for at least 14 days.
4. The change is merged, recorded in [CHANGELOG.md](CHANGELOG.md) with a
   link to the issue, and included in the next tagged release.
5. Where people disagree, the issue records both positions and the reason
   for the decision.

## Rules

- **Never post client data.** Report results as figures, describe a network
  in general terms (type, size, age, plant) and leave out site names,
  addresses, meter serials and people.
- **Paraphrase and cite** the scheme's documents and other standards; do not
  paste their text.
- **Be specific**: name the KPI code, the protocol section or the varkey.
- Be respectful. HNQAP follows the
  [Contributor Covenant 2.1](https://www.contributor-covenant.org/version/2/1/code_of_conduct/).
  Report conduct concerns to the maintainers through a private message on
  GitHub.

## Building the website

```bash
cd site
npm ci
npm run build      # writes ../_site
```

The site rebuilds and publishes to hnqap.org on every push to `main`.

## Licence

By contributing you agree that your contribution is licensed under the
[Apache License 2.0](LICENSE), the licence of this repository.
