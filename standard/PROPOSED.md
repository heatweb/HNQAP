# Proposed names (not yet in `vocabulary.json`)

Nominated 2026-10-02 while unifying the spray-booth dictionary with the heat-network
registry. Each row becomes a registered name once approved; comments welcome as
issues on this repository.

## Site-wide constants (vargroup `design`, on `global/network`)

| Name | Type | Units | Meaning | Replaces |
|---|---|---|---|---|
| `gasCalorificValue` | number | MJ/m³ | Calorific value used to convert metered gas m³ to kWh | spray `values/calorificGas` (kWh/m³ — derive: MJ/m³ × correction ÷ 3.6) |
| `gasVolumeCorrection` | number | factor | Gas volume correction factor | — |
| `gasPrice` | number | p/kWh | Gas unit price (existing name, additionally allowed under `design`) | spray `values/costGas` (£/kWh) |
| `elecPrice` | number | p/kWh | Electricity unit price (existing name, additionally allowed under `design`) | spray `values/costElec` (£/kWh) |
| `carbonFactorGas` | number | kgCO₂e/kWh | Carbon factor for gas | spray `values/co2Gas` |
| `carbonFactorElec` | number | kgCO₂e/kWh | Carbon factor for electricity | spray `values/co2Elec` |
| `sessionIdleMinutes` | number | min | Idle gap that closes a booth session | Node-RED 300 s constant |

## Site identity (vargroup `system`, on `global/network`)

| Name | Type | Meaning |
|---|---|---|
| `name` | text | Site display name |
| `imageUrl` | text | Site image for tiles and headers |

## Telemetry (new vargroups, kind `telemetry`)

| Vargroup | Varkey | Type | Units | Meaning |
|---|---|---|---|---|
| `status` | `run` | boolean | — | Booth running |
| `status` | `spray` | boolean | — | Spray mode active |
| `status` | `flashoff` | boolean | — | Flash-off mode active |
| `status` | `bake` | boolean | — | Bake mode active |
| `status` | `cool` | boolean | — | Cool-down active |
| `status` | `prep` | boolean | — | Prep mode active |
| `status` | `emac` | boolean | — | Emergency stop / off |
| `sensor` | `temperature` | number | °C | Booth air temperature |
| `sensor` | `tInlet` | number | °C | Inlet air temperature (alias `temperatureInlet`) |
| `sensor` | `rhumidity` | number | %RH | Relative humidity |
| `sensor` | `voc` | number | ppb | Volatile organic compounds |
| `setpoint` | `tSet` | number | °C | Temperature setpoint |
| `gmeter` | `gasFlow` | number | m³/h | Gas flow rate |
| `gmeter` | `m3` | number | m³ | Gas register, whole m³ |
| `gmeter` | `mm3` | number | L | Gas register, sub-m³ part |
| `emeter` | `wattsL1` `wattsL2` `wattsL3` | number | W | Power per phase |
| `emeter` | `ampsL1` `ampsL2` `ampsL3` | number | A | Current per phase |
| `emeter` | `kwhElectric` | number | kWh | Electricity register |
| `set` | `jobCode` | text | — | Operator job reference (QR scan); `none` clears |

The heat-network telemetry names already in use (`sensor/tF`, `sensor/tR`,
`hmeter/kw`, `hmeter/kwh`, `gmeter/m3Gas`, …) will be registered in the same pass
from the live point mappings.
