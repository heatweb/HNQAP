# Heatweb BMS-to-MQTT Data Connection Guide

**Connecting building management systems to the Heatweb telemetry platform**
Version 1.0 — September 2026

---

## 1. Purpose

This guide tells a BMS or controls engineer how to publish plant data to the
Heatweb telemetry platform with the minimum of site-side effort. The design
principle throughout:

> **Connect every point, exactly as it is named today. Heatweb does the mapping.**

You do not need to rename points to a Heatweb convention, agree a point
schedule in advance, or filter to an approved list. Publish everything the
station can see; the platform ingests verbatim, and Heatweb maps the incoming
identities to standard heat-network monitoring points (flow/return
temperatures, heat meters, pump energy, pressures) for KPI calculation,
dashboards and HNTAS-aligned reporting. Unrecognised points are stored, not
lost — mapping can happen at any time after connection.

Three connection profiles are supported. Pick the one that matches your
platform; each has a one-page instruction section below.

| Profile | For | Effort |
|---|---|---|
| **A — Native topics** | Any MQTT-capable controller (incl. Trend IQ5 family), gateways, custom kit | One topic per point |
| **B — Batch JSON** | Tridium Niagara stations (N4 / JACE), and Niagara-based OEM front-ends | One JSON message per point list — **in production use today** |
| **C — Sparkplug B** | Ignition / industrial estates already standardised on Sparkplug | Off-the-shelf modules (on request) |

## 2. The address model

Every reading in the platform lives at a six-level MQTT address:

```
<schema>/<network>/<node>/<device>/<group>/<key>
```

| Level | Meaning | Example |
|---|---|---|
| schema | The operator / portfolio (issued by Heatweb) | `operatorx` |
| network | The heat network / site slug (issued by Heatweb) | `highstreet` |
| node | Element of the network: `ec` (energy centre), substation or block id | `ec`, `block_g` |
| device | The plant item | `boiler_1`, `chp`, `hiu`, `block_g` |
| group | The kind of value: `sensor`, `meter`, `emeter`, `setpoint`, `digin`, `driver` | `sensor` |
| key | The point name | `tF`, `tR`, `kwh`, `speed` |

Heatweb issues the `schema` and `network` values with your credentials.
Everything from `node` down may use your existing naming — lowercase with
underscores preferred, no spaces or `/` in a segment. Broker-side access
prefixes ahead of the six levels are tolerated (the address is read
right-anchored).

Payloads on native topics are the plain numeric value (`72.4`). Formatted
value strings (`72.4 °C {ok} @ def`) belong on the batch JSON profile, whose
decoder extracts the number; published raw to a native topic they are kept
as text values — visible, never dropped, but deliberately excluded from
numeric analytics.

## 3. Broker connection

| | |
|---|---|
| Host | `mqtt.heatweb.cloud` |
| Port | `8883` (TLS) |
| Protocol | MQTT v3.1.1 or v5 |
| Credentials | Issued per site by Heatweb — publish-only permission on your `<schema>/#` |
| QoS | 0 or 1 |
| Retained messages | Not required |
| Cadence | On change-of-value where supported, else a periodic scan. 1–5 minutes suits most heat-network KPIs; faster is accepted. |

Nothing on site is polled from outside and no inbound firewall rules are
needed: the connection is outbound MQTT/TLS from your station or gateway.

## 4. Profile A — native topics

*For any controller or gateway that can publish MQTT directly (including the
Trend IQ5 family — IQ500/IQ528 are natively MQTT-capable; legacy Trend IQ4
should use Profile B via a Niagara/IQVISION layer or a gateway).*

1. Configure the broker connection from §3.
2. For each point, publish its plain numeric value to its six-level topic, e.g.:
   ```
   operatorx/highstreet/ec/boiler_1/sensor/tF        → 71.8
   operatorx/highstreet/ec/dhn/meter/kwh             → 2918920
   operatorx/highstreet/block_g/hiu_riser/sensor/dP  → 0.42
   ```
3. Publish on change-of-value with a periodic re-send (heartbeat) so quiet
   points remain visibly alive.
4. Tell Heatweb the connection is live. Nothing else is needed — points
   appear in the platform within seconds and mapping proceeds from there.

## 5. Profile B — Niagara batch JSON *(in production use)*

*For Tridium Niagara N4 stations and JACE controllers, and the many OEM
front-ends built on Niagara. This profile is running in production today,
ingesting live energy-centre and per-block substation data exported from a
Niagara station on a UK district heating scheme.*

Niagara's strength is exporting a whole point list as one JSON message
(JSON Toolkit, or the MQTT Service payload builder). Rather than fight
that, the platform accepts the batch shape natively:

### 5.1 Point naming — no renaming required

Exported points are accepted **under their existing displayNames, exactly as
they are** — no renaming, and therefore no impact on the site's own
graphics, schedules or histories. A point named `AHU2_SupplyTemp` ingests
verbatim (addressed under its batch, e.g.
`…/boilers/point/ahu2_supplytemp`) and is then mapped platform-side to the
standard monitoring point it represents. At portfolio scale this matters:
mapping thousands of as-found names is Heatweb's job, done centrally with
bulk pattern rules — not a renaming exercise across every station.

**Optionally**, a site that wants its data pre-organised by plant item can
name exported points as `<device>__<key>_<group>` — the plant item, a
**double underscore**, the point name, and the value kind as the final
underscore-separated token. Points named this way resolve straight to
structured addresses without any mapping step:

| Niagara displayName | Resolved address (device/group/key) |
|---|---|
| `boiler_1__flow_temp_sensor` | `boiler_1/sensor/flow_temp` |
| `block_g__cummulative_energy_meter` | `block_g/meter/cummulative_energy` |
| `AHU2_SupplyTemp` *(unrenamed)* | `<batch>/point/ahu2_supplytemp` — mapped by Heatweb |

Both styles can coexist in one batch; where the convention is used, a
displayName is a one-field Workbench edit that does not disturb the
underlying point or its history.

### 5.2 Envelope

Publish batches as a JSON object with a `status` array:

```json
{
  "topic":     "operatorx/highstreet/ec/hm/json/boilers",
  "timestamp": "06-Sep-26 12:58 PM BST",
  "status": [
    { "displayName": "boiler_1__flow_temp_sensor", "value": "71.8 °C {ok} @ def" },
    { "displayName": "boiler_1__return_temp_sensor", "value": "58.2 °C {ok} @ def" },
    { "displayName": "dhn__pump_speed_driver", "value": "42.0 % {ok} @ def" }
  ]
}
```

Niagara's native value strings — units, `{ok}`/`{down}`/`{fault}` status
flags, priority slots — are accepted as-is; the platform extracts the
numeric value and does not require you to strip formatting.

### 5.3 Publish topic

Publish each batch to:

```
<schema>/<network>/<node>/<station>/json/<batchName>
```

The literal `json` at level five is what routes the message to the batch
decoder. `<batchName>` is free (e.g. `boilers`, `block_g`, `dhn`); one batch
per plant area keeps messages a comfortable size. Group points under the
node they belong to (`ec` for energy-centre plant; a block/substation id for
consumer-side points).

### 5.4 Station-side steps (Workbench)

1. Add the MQTT connection (§3) using the Niagara MQTT driver or MQTT
   Service.
2. Build the point list(s) for export — all points; do not filter.
3. Optionally apply the naming convention (§5.1) — or skip this step
   entirely and leave every displayName as-is.
4. Encode the list to JSON (JSON Toolkit `pointsToJson` or the MQTT Service
   payload builder) and link the output string to the publish topic (§5.3).
5. Trigger on a 1–5 minute interval (or change-of-value where preferred).

### 5.5 What happens platform-side

Each batch is exploded into per-point readings at full six-level addresses,
typed (numeric analytics never polluted by text values), stored in a
compressed time-series store with two-year retention, and surfaced in the
Heatweb App within seconds — per-device activity, latest values, and
history. Heatweb then maps point identities to the standard heat-network
monitoring points for KPIs and reporting; unmapped points remain stored and
queryable throughout.

## 6. Profile C — Sparkplug B

For estates already standardised on MQTT Sparkplug B (typically Ignition
with the Cirrus Link modules), Sparkplug metric batches can be accepted —
the industrial-standard equivalent of Profile B. The decoding is
provisioned per project rather than enabled on request: the site-side
effort is configuration of an off-the-shelf module, and the platform side
is agreed at the outset. Talk to us before assuming this profile.

## 7. Data quality, security and governance

- **Transport**: TLS-only broker; per-site credentials; publish-only ACLs
  scoped to the site's own schema. Site systems cannot read other sites'
  traffic.
- **Typing defence**: numeric and text values are stored in separate
  columns; a stray text value can never corrupt an average or a KPI.
- **Visibility**: malformed or unrecognised messages are dead-lettered and
  counted, never silently dropped; ingest health (rate, backlog, errors) is
  monitored.
- **Retention & efficiency**: readings are compressed (typically 10–70×)
  with two-year online retention as standard.
- **Access**: read access in the Heatweb App is granted per operator
  tenant by Heatweb — the same data can serve multiple authorised parties
  (operator, maintainer, consultant) without re-publishing.

## 8. Connection checklist

1. Request credentials from Heatweb → receive `schema`, `network`, username,
   password.
2. Pick your profile (A: native topics · B: Niagara batch JSON · C:
   Sparkplug B).
3. Configure the broker connection (§3) and publish **all points**.
4. Confirm with Heatweb — arrival is verified live and mapping begins.

*Heatweb Solutions Ltd — heat network telemetry, analysis and optimisation.*
