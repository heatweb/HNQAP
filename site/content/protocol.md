---
title: HNQAP-MQTT v1 protocol
description: The HNQAP-MQTT v1 specification: how heat network data points are addressed, named, published and timestamped over MQTT, so any BMS, meter platform or analytics tool can exchange data without a mapping exercise.
section: Standard
---
# HNQAP-MQTT v1

**Status: draft for public comment.** Version 1.0-draft, October 2026.
[Comment on this specification](https://github.com/heatweb/HNQAP/issues/new?template=protocol-comment.yml).

This specification defines how a heat network data point is addressed, named
and published over MQTT. It is deliberately small. A controls engineer can
apply it to an existing BMS in an afternoon, and a software developer can
consume it with an MQTT client and one JSON file.

The key words MUST, MUST NOT, SHOULD and MAY are used as in RFC 2119.

## 1. Scope

The protocol covers:

- the address of a data point: live readings, settings, design values and
  inspection answers alike;
- the names used at each level of the address, drawn from the
  [HNQAP vocabulary](/vocabulary/);
- payloads, timestamps and transport for publishing readings.

It does not cover how readings are stored, how KPIs are computed (see the
[KPI reference](/kpis/)), or commercial arrangements between the parties
exchanging data.

## 2. The address

Every data point has an address of exactly six segments:

```
<schema>/<network>/<element>/<device>/<vargroup>/<varkey>
```

| # | Segment | Identifies | Examples |
|---|---|---|---|
| 1 | schema | The organisation or portfolio that owns the data; one access and storage partition | `acme`, `org_name` |
| 2 | network | A site: one heat network | `riverside_court` |
| 3 | element | A part of the network with its own identity: energy centre, substation, block, dwelling. `global` is the site itself | `ec1`, `ss2`, `cc14`, `global` |
| 4 | device | A physical device within the element, or the monitoring point it serves | `boiler1`, `intake`, `hiu1`, `network` |
| 5 | vargroup | The kind of value | `sensor`, `hmeter`, `status`, `design` |
| 6 | varkey | The data point itself | `tF`, `tR`, `kwh`, `m3h` |

The same address is the MQTT topic, the storage key and the column name in
exports. A tool that knows the address knows everything it needs to find
the value again.

### 2.1 Segment rules

1. A segment MUST be non-empty and MUST NOT contain `/`, `+`, `#` or
   whitespace.
2. `schema` MUST contain only ASCII letters, digits and underscore. It is
   compared case-insensitively.
3. `network` and `element` SHOULD be lowercase ASCII letters, digits and
   underscore.
4. `vargroup` and `varkey` MUST be registered names from the
   [vocabulary](/vocabulary/), or the names in the
   [monitoring points](/monitoring-points/) table, when one with the right
   meaning exists. They are case-sensitive.
5. A receiver MUST read the address **right-anchored**: the last six
   segments of a topic are the address, so a broker may prefix topics with
   its own access-control levels.

### 2.2 Elements and devices on monitored networks

Where an element is one that heat network assurance monitors (energy
centre, district distribution, substation, communal distribution, consumer
connection), a meter or sensor device SHOULD be named for the monitoring
point it serves. The quantity keeps its ordinary varkey.

| Device name | Monitoring point |
|---|---|
| `intake` | SS1, DD1, CD1: intake boundary meter |
| `offtake` | SS2: offtake boundary meter |
| `termination` | DD2, CD2: termination boundary meter |
| `boundary` | EC3, CC1: boundary meter |
| `pump` | EC4, SS3: distribution pump set |
| `makeup` | EC5: make-up water meter |
| `watermeter` | SS4: water meter |
| `pressure` | EC8, SS7: operating pressure |
| `EC1` … `EC8`, `SS1` … `SS7`, `DD1` … `DD3`, `CD1` … `CD3`, `CC1` | The point itself, written in capitals |

```
acme/riverside_court/ss1/intake/hmeter/tF    69.3
acme/riverside_court/ss1/offtake/hmeter/tF   64.1
acme/riverside_court/ec1/EC3/hmeter/kwh      15869
```

A KPI engine can then bind a device to its monitoring point by name alone.
Device names are matched case-insensitively.

### 2.3 Site-wide values

Constants that belong to the whole site (calorific value, tariffs, carbon
factors, design temperatures) MUST be published on element `global`,
device `network`, in vargroup `design`:

```
acme/riverside_court/global/network/design/gasCalorificValue   39.5
```

## 3. Names

### 3.1 Vargroups: the kind of value

A vargroup classifies the nature of a value, never the process that
produced it. `design/tF` is a design intent wherever it was entered;
`sensor/tF` is a measurement whoever took it.

| Kind | Vargroups | Meaning |
|---|---|---|
| telemetry | `sensor`, `hmeter`, `meter`, `gmeter`, `emeter`, `status`, `setpoint`, `set` | Readings and states published by equipment |
| shared | `design`, `system` | Values any process may write and every process reads |
| process | `acceptance`, `survey`, `onboarding`, … | Answers that belong to one quality-assurance procedure |
| system record | `site`, `device` | Attributes of the record itself |

### 3.2 Varkeys: one name, one shape

A varkey has **one type and one set of units everywhere it is used**,
fixed when the name is registered. A publisher MUST convert to the
registered units rather than publish the same name in other units. A
legacy or vendor spelling MAY be recorded as an alias so that old data
stays readable, but new data MUST use the registered name.

Before using a new name, search the [vocabulary](/vocabulary/). If nothing
has the right meaning, [propose a varkey](https://github.com/heatweb/HNQAP/issues/new?template=varkey-proposal.yml).

## 4. Payloads

1. The payload of a single reading MUST be the plain value as UTF-8 text:
   a number such as `72.4`, or a short text state such as `fault`.
2. A number MUST be written in full: optional sign, digits, optional
   decimal point and optional exponent. Units, status flags and other
   decoration MUST NOT be added to a numeric payload.
3. A receiver MUST store a payload that is not a complete number as text
   on the same address, and MUST exclude text values from numeric
   calculations. A receiver MUST NOT extract a number from inside a text
   value.
4. A JSON object or array MAY be published as a payload, for example a
   batch (§6). A receiver that does not decode it MUST keep it rather than
   drop it.

## 5. Timestamps

1. A publisher using MQTT 5 SHOULD send the time the value was measured
   as the user property `time`: epoch seconds, epoch milliseconds or an
   ISO 8601 string with an offset.
2. Without that property, the reading's time is the time the receiver
   took it from the broker.
3. A receiver SHOULD treat the pair (address, time) as unique, so that a
   message delivered twice is stored once.

## 6. Batch profile

A station that exports a whole point list as one message MAY publish it as
a JSON object with a `status` array, on a topic whose fifth segment is the
literal `json`:

```
<schema>/<network>/<element>/<station>/json/<batchName>
```

```json
{
  "status": [
    { "displayName": "boiler_1__flow_temp_sensor", "value": "71.8 °C {ok}" },
    { "displayName": "dhn__pump_speed_driver", "value": "42.0 % {ok}" }
  ]
}
```

The receiver explodes the batch into one reading per entry. A display name
of the form `<device>__<varkey>_<vargroup>` (device, double underscore,
point name, then the vargroup as the last token) resolves straight to a
six-level address. Any other name is stored under
`<station>/point/<name>` and mapped later. Inside a batch, value strings
MAY carry units and status flags; the receiver extracts the leading number.
Every reading in a batch takes the batch message's time under §5.

## 7. Transport

| | |
|---|---|
| Protocol | MQTT 3.1.1 or 5 |
| Security | TLS, port 8883. Plain-text connections MUST NOT be used across public networks |
| Credentials | One per site or gateway, allowed to publish only under its own `<schema>/<network>/#` |
| QoS | 0 or 1 |
| Retained messages | Not required |
| Cadence | On change of value with a periodic re-send, or a fixed scan. One to five minutes suits heat network KPIs; the [KPI reference](/kpis/) states the minimum frequency for each monitoring point |

## 8. Reading data back

Because the address is the topic, MQTT topic filters work as queries at
any level, and the same filters can be used as access rules:

| Filter | Reads |
|---|---|
| `acme/riverside_court/#` | Everything on one network |
| `acme/+/+/+/hmeter/kwh` | Every heat meter energy register in a portfolio |
| `acme/riverside_court/+/intake/hmeter/#` | Every intake boundary meter on a network |
| `acme/riverside_court/global/network/design/#` | The site's constants |

## 9. Conformance

| Level | A publisher… |
|---|---|
| **Addressed** | publishes on six-level addresses (§2) with plain payloads (§4) over TLS (§7) |
| **Named** | also uses registered vargroups and varkeys in their registered units (§3) |
| **Assurance-ready** | also names devices for monitoring points on monitored elements (§2.2), publishes site constants on `global/network/design` (§2.3), and timestamps at source (§5) |

A receiver conforms when it applies §2.1 rule 5, §4 rules 3 and 4, and §5.

## 10. Versioning

This document is versioned with the repository. A breaking change to the
address or the payload rules requires a new major version (`HNQAP-MQTT v2`).
Names are never deleted from the vocabulary: a withdrawn name is marked
`retired` with `replacedBy`. Changes are recorded in the
[changelog](https://github.com/heatweb/HNQAP/blob/main/CHANGELOG.md).

A worked implementation, including the batch profile in production use on
a Niagara station, is the [BMS connection guide](/bms-guide/).
