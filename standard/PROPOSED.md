# Proposed names (not yet in `vocabulary.json`)

Nothing pending. The 2026-10-02 nominations (site-wide constants under `design`,
site identity under `system`, and the telemetry vargroups `status`, `sensor`,
`setpoint`, `gmeter`, `emeter`, `set`) were approved on 2026-10-02 and are in
`vocabulary.json`; legacy spellings (`calorificGas`, `costGas`, `costElec`,
`co2Gas`, `co2Elec`, `temperatureInlet`) are recorded as aliases.

Equipment that already publishes under a legacy name does not need to change:
store what is published and resolve the alias on read.

To propose a name: open an issue on this repository with name, vargroup, type,
units and a one-line meaning.
