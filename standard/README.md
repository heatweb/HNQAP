# HNQAP Data Standard

The data standard behind Heatweb's heat-network and spray-booth software, published
so that third parties — and third-party code assistants — can build on the same
names. Everything in this folder is generated from the live registry; nothing here
is hand-maintained except `PROPOSED.md`.

| File | What it is | Use it for |
|---|---|---|
| `vocabulary.json` | The registry: every **vargroup** and **varkey** with its shape (type, units), title, meaning, aliases and allowed groups | Machine lookup — pin a copy, validate names against it |
| `vargroups.md` | The vargroups as a readable table | Browsing |
| `varkeys.md` | The varkeys as a readable table, grouped by vargroup | Browsing, searching by title or alias |
| `PROPOSED.md` | Names nominated but not yet approved | What is coming; comment before it lands |
| `BMS-CONNECTION-GUIDE.md` | How a BMS or data logger publishes to the broker | Connecting a site |
| `build.py` | Regenerates the Markdown tables from `vocabulary.json` | Keeping the tables honest |

Raw URLs for tools: `https://raw.githubusercontent.com/heatweb/HNQAP/main/standard/vocabulary.json`

---

## 1. The address: six levels

Every data point — a live reading, a design value, a survey answer, a setting — is
addressed by six segments. The same address is the MQTT topic, the database key and
the column name in exports.

```
<schema>/<network>/<element>/<device>/<vargroup>/<varkey>
```

| # | Level | Identifies | Examples |
|---|---|---|---|
| 1 | **schema** | The owning organisation or partner group; one database partition | `heatweb`, `acme`, `org_name` |
| 2 | **network** | A site: a heat network or a body shop | `riverside_court`, `unit4_bodyshop` |
| 3 | **element** (node) | A thing on the site with its own identity: an energy centre, substation, dwelling (consumer connection), BMS controller. `global` = the site itself | `ec1`, `cc14`, `b1_4_130`, `global` |
| 4 | **device** | A physical device within the element; `network` for site-wide values on `global` | `boiler1`, `pump1`, `hiu1`, `cp1`, a serial number, `network` |
| 5 | **vargroup** | The *kind* of value — what sort of thing it is, not which process produced it | `sensor`, `hmeter`, `gmeter`, `emeter`, `status`, `setpoint`, `set`, `design`, `system`, `acceptance` |
| 6 | **varkey** | The specific data point, from the registry | `tF`, `tR`, `kw`, `m3Gas`, `gasCalorificValue`, `tSetpointDHW` |

Examples:

```
heatweb/myHeatNetwork/energycentre/boiler1/sensor/tF        = 73.5
heatweb/myHeatNetwork/energycentre/boiler1/gmeter/m3Gas     = 16353499.1
heatweb/myHeatNetwork/b1_4_130/hiu1/acceptance/tSetpointDHW = 52.5
heatweb/myHeatNetwork/global/network/design/gasCalorificValue = 39.5
acme/unit4_bodyshop/cp1/cp1/status/spray                    = 1
```

### Why the levels are MQTT-shaped

- **Wildcards at any level**: `heatweb/myHeatNetwork/+/+/sensor/#` reads every sensor on a network.
- **Access control by prefix**: a contract manager is granted one network; a partner gets only their schema.
- **Storage keyed identically**: a topic filter translates directly into a row filter.
- **Bridging**: brokers can mirror agreed prefixes between organisations in real time.

### Reading rules

- Topics are read **right-anchored**: the last six segments are the address, so a
  longer prefix is tolerated.
- Names are **case-sensitive**, ASCII letters, digits and underscore; `network` and
  `element` are lowercase.
- A reading's value is a number where it parses as one, otherwise text. The
  registry says which a varkey is.

## 2. Vargroups: the kind of value

A vargroup classifies the **nature** of a value, never the process that wrote it.
`design/tFlow` is a design intent wherever it was entered; `sensor/tF` is a
measurement whoever measured it. Kinds in the registry:

| Kind | Meaning | Examples |
|---|---|---|
| `telemetry` | Live readings and states published by equipment | `sensor`, `hmeter`, `gmeter`, `emeter`, `status`, `setpoint`, `set` |
| `shared` | Values any process may write and every process reads | `design`, `system` |
| `process` | Answers belonging to one QA procedure | `acceptance`, `survey`, `onboarding`, `hnes_rev_study` |
| `system_record` | Attributes of the record itself | `site`, `device` |

## 3. Varkeys: one name, one shape

A varkey has **one shape everywhere**: its type and units are fixed when the name is
registered. `gasCalorificValue` is MJ/m³ in every schema; if you hold kWh/m³, derive
it. Aliases record legacy or vendor spellings so old data can still be read, but
new data uses the registered name.

Before naming anything new:

1. Search `varkeys.md` (name, title, aliases).
2. If a name with the right meaning exists, use it with its units.
3. If not, propose it: open an issue on this repository with name, vargroup, type,
   units and one-line meaning, or send it to Heatweb. Approved names appear in the
   next export; pending ones are listed in `PROPOSED.md`.

## 4. Publishing data

Connect to the broker over TLS on port 8883 with the credentials issued for your
schema, and publish each point on its full six-level topic (profile A), or publish a
batch JSON object once per station and let the platform explode it (profile B), or
Sparkplug B (profile C). `BMS-CONNECTION-GUIDE.md` has the details, the envelope
format and the checklist.

Site-wide constants (calorific value, tariffs, carbon factors) live on the site's
`global` element, device `network`, in the `design` vargroup, so every consumer of
the data finds them in the same place.

## 5. Versioning

`vocabulary.json` carries `exportedAt`. Pin the copy you built against and diff on
refresh. Names are never deleted: a withdrawn name is marked `retired` with
`replacedBy`.
