# Heat Network KPI Reference

*Generated 2026-10-27. Generated from the platform's KPI registry. A working basis for a proposed British Standard on heat network key performance indicators.*

## How to read the tables

One table per element type, in network order from the energy centre to the dwelling. The layout follows the KPI tables of the HNTAS Milestone 4 technical specifications so the two can be compared row by row; the columns that differ carry the detail a KPI needs to be computed the same way on every network.

| Column | Meaning |
|---|---|
| Code | `<element>-KPI-<nn>`; a letter after the number is a variant (A reported form, B weather-compensated or per-source form). `-C-` marks the cooling form of a KPI; `-M-` a meter-health KPI; `-H-` a health KPI (hours below outage limits, offered as an alternative to the outage KPIs 04 and 05). |
| Standing | **HNTAS**: in the HNTAS Milestone 4 specifications, assessed (pass/fail) or reported (expected value only). **HNTAS-style**: an HNTAS KPI's method applied where the scheme does not yet reach, such as cooling. **Heatweb**: a diagnostic KPI the platform runs that HNTAS does not define. **proposed**: defined here, not yet computed by the platform. |
| Monitoring points | Point code, minimum data frequency, and the fields read. "x, else y" is a fallback chain: the first source with data at each reading is used. |
| Threshold | Pass criterion for an assessed KPI; "expected value" for a reported one. "(proposed)" marks a value put forward for review. |
| Calculation | The maths, in as few words as states it exactly. |
| Period | The window the KPI is assessed over. |

**Notation.** tF, tR flow and return temperature (°C); q volumetric flow rate (m³/h); V volume register (m³); E energy register (kWh); ΔE, ΔV register increase over the period or day; 1.163 kWh/(m³·K) the volumetric heat capacity of water; Σ over the period; n readings. Volume weighting pairs readings in 5-minute buckets. Data at a higher frequency than the minimum is used at that frequency.

**Rules that apply to every KPI.** Readings that fail the out-of-range bounds for their channel are excluded before any KPI is computed. A setpoint input follows the live setpoint stream where the controls publish one and falls back to the design value where they do not. Consumer Connection KPIs 01 to 03 are assessed across all consumer connections together, not dwelling by dwelling.

## Where this reference departs from the published methods

Each departure is deliberate and is argued in the linked issue; comments there are welcome.

| Topic | Published method | This reference | Why | Issue |
|---|---|---|---|---|
| Out-of-range bounds on cumulative registers (all KPI-03, and the exclusion rule) | One range per quantity for every reading: energy 0–55,000 kWh, volume 0–10,000 m³ (the DESNZ data-pilot workbook thresholds). | Register channels (E, V) take bounds set per network from the meters' register span; the published ranges stay the default and still apply to interval and rate channels. | A heat meter register several years old legitimately reads millions of kWh and hundreds of thousands of m³. Under the published ranges every reading of a healthy meter is out of range and the point fails KPI-03 on good data. | [#4](https://github.com/heatweb/HNQAP/issues/4) |
| CC-KPI-08 volume-weighted average temperature difference | Estimated from the volume-weighted average flow and return temperatures. | ΔE ÷ (1.163 · ΔV): the energy and volume register increase over the period. | Two readings suffice, so the KPI is resilient to reading frequency and missing data, and applies to low-frequency systems and monthly meter summaries; studies support its accuracy. | [#3](https://github.com/heatweb/HNQAP/issues/3) |

## Energy Centre (EC)

| Code | Standing | KPI | Monitoring points | Threshold | Calculation | Period |
|---|---|---|---|---|---|---|
| EC‑KPI‑01 | HNTAS · assessed | Energy Centre ARMS connectivity | all EC points | ≥ 99% | received intervals ÷ expected intervals across connected points | Monthly |
| EC‑KPI‑02 | HNTAS · assessed | Energy Centre monitoring point data completeness | all EC points | ≥ 95% | valid readings ÷ expected readings | Monthly |
| EC‑KPI‑03 | HNTAS · assessed | Energy Centre monitoring points operational | all EC points | 100% of ARMS-connected points | points with no error/negative/out-of-range values ÷ total points | Monthly |
| EC‑KPI‑04 | HNTAS · assessed | Energy Centre unplanned interruptions | EC · tF (sensor, else heat meter); sensor dP | ≤ 3 a year | count of >12h periods below min flow temp OR min dP without 48h notice. Uses design/minFlowTemp design/minDPIndex | Previous 12 months |
| EC‑KPI‑05 | HNTAS · assessed | Energy Centre planned interruptions | EC · tF (sensor, else heat meter); sensor dP | ≤ 1 a year | count of noticed (≥48h) interruptions. Uses design/minFlowTemp design/minDPIndex | Previous 12 months |
| EC‑KPI‑06 | HNTAS · reported | Energy Centre average flow temperature | EC · tF (sensor, else heat meter) | [expected average flow temperature] | time-weighted mean of flow temperature. Uses design/tF | Monthly |
| EC‑KPI‑07 | HNTAS · reported | Energy Centre average return temperature | EC · tR (sensor, else heat meter) | [expected average return temperature] | time-weighted mean of return temperature | Monthly |
| EC‑KPI‑08 | HNTAS · assessed | EC flow temperature variance from set point | EC · tF (sensor, else heat meter), tF (setpoint, else design) | 0 ± 2 °C | mean \|tF - setpoint\| | Monthly |
| EC‑KPI‑09A | HNTAS · assessed | EC volume weighted average flow temperature (VWAFT) | EC · tF (heat meter, else sensor); heat meter m³/h | [expected] ± 3 °C | Σ(tF · flow volume) ÷ Σ(volume). Uses design/tF | Monthly |
| EC‑KPI‑09B | HNTAS · assessed | EC VWAFT (weather-compensated variant) | EC · tF (heat meter, else sensor), tF (setpoint, else design); heat meter m³/h | tracks compensated setpoint ± 3 °C | as 09A against live setpoint | Monthly |
| EC‑KPI‑10A | HNTAS · assessed | EC flow temperature stability | EC · tF (sensor, else heat meter), tF (setpoint, else design) | ≥ 95% within thresholds | 1 - (time above upper + below lower) ÷ total | Monthly |
| EC‑KPI‑10B | HNTAS · assessed | EC flow temperature stability (weather-compensated) | EC · tF (sensor, else heat meter), tF (setpoint, else design) | ≥ 95% | as 10A against compensated setpoint | Monthly |
| EC‑KPI‑11 | HNTAS · assessed | EC flow temperature uptime | EC · tF (sensor, else heat meter) | ≥ 98% above minimum flow temp (99.5% at M4) | time above minimum ÷ total time. Uses design/minFlowTemp | Monthly |
| EC‑KPI‑12 | HNTAS · assessed | EC pressure differential uptime | EC · sensor dP | ≥ 99% above minimum dP (99.5% at M4) | time above minimum dP ÷ total. Uses design/minDPIndex | Monthly |
| EC‑KPI‑13 | HNTAS · assessed | Max allowable differential pressure exceedance | EC · sensor dpSupply | 100% below maximum dP | 1 - time above max dP ÷ total. Uses design/maxDPSupply | Monthly |
| EC‑KPI‑14 | HNTAS · assessed | Max allowable operating pressure exceedance | EC · sensor pressure | 100% below maximum operating pressure | 1 - time above max pressure ÷ total. Uses design/maxPressure | Monthly |
| EC‑KPI‑15 | HNTAS · assessed | Top-up water volume | EC · water meter m³ | ≤ 1% of system volume per month (0.17% at M4/TS1) | make-up volume ÷ system volume per month. Uses design/systemVolume | Monthly |
| EC‑KPI‑16A | HNTAS · assessed | Heat fraction (source A) | EC · heat meter kWh | [design heat fraction] | source A heat out ÷ total heat out | Monthly |
| EC‑KPI‑16B | HNTAS · assessed | Heat fraction (source B) | EC · heat meter kWh | [design heat fraction] | source B heat out ÷ total heat out | Monthly |
| EC‑KPI‑18 | HNTAS · assessed | Network distribution pump energy | EC · electricity meter kwhElectric | < 1% of annual heat generation | sum of distribution pump electricity (excl. shunts). Uses design/kwhAnnualPump | Monthly |
| **Hours below outage limits (alternative to 04/05)** | | | | | | |
| EC‑KPI‑H‑01 | Heatweb | Energy Centre hours below outage limits | EC · tF (sensor, else heat meter); sensor dpIndex | < 60 h a year, judged on the month pro rata (≈ 4.9 h in 30 days); shorter windows report hours used | Σ_i min(t_{i+1} − t_i, 1 h) over readings with tF < tF_min or dP < dP_min; tF and dP spans unioned. Offered as an alternative to KPI-04/05. Uses design/minFlowTemp design/minDPIndex | Monthly (pro rata) |
| **heat** | | | | | | |
| EC‑KPI‑17‑A | HNTAS · assessed | Heat generation efficiency (source A) | EC · heat meter kWh; gas meter m3Gas, kWh | gas/oil 80% · biomass 75% · electric 98% · heat pump COP 2.0 · CHP QI 105 | heat out ÷ fuel in (boiler gross; HP CoP uses emeter). Uses design/efficiency | Monthly |
| EC‑KPI‑17‑B | HNTAS · assessed | Heat generation efficiency (source B) | EC · heat meter kWh; gas meter m3Gas, kWh; electricity meter kwhElectric | gas/oil 80% · biomass 75% · electric 98% · heat pump COP 2.0 · CHP QI 105 | as 17-A per source. Uses design/efficiency | Monthly |

## District Distribution (DD)

| Code | Standing | KPI | Monitoring points | Threshold | Calculation | Period |
|---|---|---|---|---|---|---|
| DD‑KPI‑01 | HNTAS · assessed | District Distribution ARMS connectivity | all DD points | ≥ 99% | received intervals ÷ expected intervals across connected points | Monthly |
| DD‑KPI‑02 | HNTAS · assessed | District Distribution monitoring point data completeness | all DD points | ≥ 95% | valid readings ÷ expected readings | Monthly |
| DD‑KPI‑03 | HNTAS · assessed | District Distribution monitoring points operational | all DD points | 100% of ARMS-connected points | points with no error/negative/out-of-range values ÷ total points | Monthly |
| DD‑KPI‑04 | HNTAS · assessed | District Distribution unplanned interruptions | DD1 · 30 min · tF (sensor, else heat meter); DD · sensor dP | ≤ 3 a year | count of >12h periods below min flow temp OR min dP without 48h notice. Uses design/minFlowTemp design/minDPIndex | Previous 12 months |
| DD‑KPI‑05 | HNTAS · assessed | District Distribution planned interruptions | DD1 · 30 min · tF (sensor, else heat meter); DD · sensor dP | ≤ 1 a year | count of noticed (≥48h) interruptions. Uses design/minFlowTemp design/minDPIndex | Previous 12 months |
| DD‑KPI‑06 | HNTAS · assessed | DD network heat loss | DD1 · 30 min · heat meter kWh | per design W/dwelling basis | initiation kWh - Σ(termination kWh), as W/dwelling | Monthly |
| DD‑KPI‑07 | HNTAS · reported | DD average flow temperature | DD1 · 30 min · tF (sensor, else heat meter) | [expected] | time-weighted mean. Uses design/tF | Monthly |
| DD‑KPI‑08 | HNTAS · reported | DD average return temperature | DD1 · 30 min · tR (sensor, else heat meter) | [expected] | time-weighted mean. Uses design/tR | Monthly |
| DD‑KPI‑09 | HNTAS · assessed | DD flow temperature uptime | DD1 · 30 min · tF (sensor, else heat meter) | ≥ 98% (99.5% at M4) | time above minimum/total. Uses design/minFlowTemp | Monthly |
| DD‑KPI‑10 | HNTAS · assessed | DD network bypass flow rate | DD1 · 30 min · heat meter m³/h | [design bypass allowance] | initiation q - Σ(termination q). Uses design/maxBypassFlow | Monthly |
| **Hours below outage limits (alternative to 04/05)** | | | | | | |
| DD‑KPI‑H‑01 | Heatweb | District Distribution hours below outage limits | DD1 · 30 min · tF (sensor, else heat meter); DD3 · 5 min · sensor dpIndex | < 60 h a year, judged on the month pro rata (≈ 4.9 h in 30 days); shorter windows report hours used | Σ_i min(t_{i+1} − t_i, 1 h) over readings with tF < tF_min or dP < dP_min; tF and dP spans unioned. Offered as an alternative to KPI-04/05. Uses design/minFlowTemp design/minDPIndex | Monthly (pro rata) |

## Substation (SS)

| Code | Standing | KPI | Monitoring points | Threshold | Calculation | Period |
|---|---|---|---|---|---|---|
| SS‑KPI‑01 | HNTAS · assessed | Substation ARMS connectivity | all SS points | ≥ 99% | received intervals ÷ expected intervals across connected points | Monthly |
| SS‑KPI‑02 | HNTAS · assessed | Substation monitoring point data completeness | all SS points | ≥ 95% | valid readings ÷ expected readings | Monthly |
| SS‑KPI‑03 | HNTAS · assessed | Substation monitoring points operational | all SS points | 100% of ARMS-connected points | points with no error/negative/out-of-range values ÷ total points | Monthly |
| SS‑KPI‑04 | HNTAS · assessed | Substation unplanned interruptions | SS1 · 5 min · tF (sensor, else heat meter); SS · sensor dP | ≤ 3 a year | count of >12h periods below min flow temp OR min dP without 48h notice. Uses design/minFlowTempOff design/minDPIndex | Previous 12 months |
| SS‑KPI‑05 | HNTAS · assessed | Substation planned interruptions | SS1 · 5 min · tF (sensor, else heat meter); SS · sensor dP | ≤ 1 a year | count of noticed (≥48h) interruptions. Uses design/minFlowTempOff design/minDPIndex | Previous 12 months |
| SS‑KPI‑06 | HNTAS · reported | Substation average flow temperature | SS1 · 5 min · tF (sensor, else heat meter) | [expected average flow temperature] | time-weighted mean. Uses design/tFOff | Monthly |
| SS‑KPI‑07 | HNTAS · reported | Substation average return temperature | SS1 · 5 min · tR (sensor, else heat meter) | [expected average return temperature] | time-weighted mean | Monthly |
| SS‑KPI‑08 | HNTAS · assessed | SS flow temperature variance from set point | SS1 · 5 min · tF (sensor, else heat meter); SS · tF (setpoint, else design) | 0 ± 2 °C | mean \|tF - setpoint\| | Monthly |
| SS‑KPI‑09A | HNTAS · assessed | SS volume weighted average flow temperature | SS1 · 5 min · tF (heat meter, else sensor); heat meter m³/h | [network flow temp] ± 3 °C | Σ(tF · volume) ÷ Σ(volume). Uses design/tFOff | Monthly |
| SS‑KPI‑09B | HNTAS · assessed | SS VWAFT (weather-compensated) | SS1 · 5 min · tF (heat meter, else sensor); heat meter m³/h; SS · tF (setpoint, else design) | ± 3 °C vs compensated setpoint | as 09A | Monthly |
| SS‑KPI‑10A | HNTAS · assessed | SS flow temperature stability | SS1 · 5 min · tF (sensor, else heat meter); SS · tF (setpoint, else design) | ≥ 95% within thresholds | 1-(out-of-band time/total) | Monthly |
| SS‑KPI‑10B | HNTAS · assessed | SS flow temperature stability (weather-comp) | SS1 · 5 min · tF (sensor, else heat meter); SS · tF (setpoint, else design) | ≥ 95% | as 10A | Monthly |
| SS‑KPI‑11 | HNTAS · assessed | SS flow temperature uptime | SS1 · 5 min · tF (sensor, else heat meter) | ≥ 98% (99.5% at M4) | time above minimum/total. Uses design/minFlowTempOff | Monthly |
| SS‑KPI‑12 | HNTAS · assessed | Substation average approach temperature | SS2 · 5 min · heat meter tROff; SS1 · 5 min · heat meter tR | ≤ design maximum approach | mean(primary tR - secondary tR). Uses design/maxApproachTemp | Monthly |
| SS‑KPI‑13 | HNTAS · assessed | SS pressure differential uptime | SS · sensor dP | ≥ 99% (99.5% at M4) | time above min dP/total. Uses design/minDPIndex | Monthly |
| SS‑KPI‑14 | HNTAS · assessed | SS max differential pressure exceedance | SS6 · 5 min · sensor dpOff | 100% below max dP | 1-time above/total. Uses design/maxDPOff | Monthly |
| SS‑KPI‑15 | HNTAS · assessed | SS max operating pressure exceedance | SS · sensor pressure | 100% below max pressure | 1-time above/total. Uses design/maxPressure | Monthly |
| SS‑KPI‑16 | HNTAS · assessed | SS top-up water volume | SS · water meter m³ | ≤ 1%/month (0.17% at M4) | make-up/system volume monthly. Uses design/systemVolume | Monthly |
| SS‑KPI‑17 | HNTAS · assessed | SS distribution pump energy | SS3 · 30 min · electricity meter kwhElectric | < 1% of annual heat throughput | pump electricity sum (excl. shunts). Uses design/kwhAnnualPump | Monthly |
| **Hours below outage limits (alternative to 04/05)** | | | | | | |
| SS‑KPI‑H‑01 | Heatweb | Substation hours below outage limits | SS2 · 5 min · tFOff (sensor, else heat meter); SS5 · 5 min · sensor dpIndex | < 60 h a year, judged on the month pro rata (≈ 4.9 h in 30 days); shorter windows report hours used | Σ_i min(t_{i+1} − t_i, 1 h) over readings with tF < tF_min or dP < dP_min; tF and dP spans unioned. Offered as an alternative to KPI-04/05. Uses design/minFlowTempOff design/minDPIndex | Monthly (pro rata) |

## Communal Distribution (CD)

| Code | Standing | KPI | Monitoring points | Threshold | Calculation | Period |
|---|---|---|---|---|---|---|
| CD‑KPI‑01 | HNTAS · assessed | Communal Distribution ARMS connectivity | all CD points | ≥ 99% | received intervals ÷ expected intervals across connected points | Monthly |
| CD‑KPI‑02 | HNTAS · assessed | Communal Distribution monitoring point data completeness | all CD points | ≥ 95% | valid readings ÷ expected readings | Monthly |
| CD‑KPI‑03 | HNTAS · assessed | Communal Distribution monitoring points operational | all CD points | 100% of ARMS-connected points | points with no error/negative/out-of-range values ÷ total points | Monthly |
| CD‑KPI‑04 | HNTAS · assessed | Communal Distribution unplanned interruptions | CD1 · 30 min · tF (sensor, else heat meter); CD · sensor dP | ≤ 3 a year | count of >12h periods below min flow temp OR min dP without 48h notice. Uses design/minDPIndex | Previous 12 months |
| CD‑KPI‑05 | HNTAS · assessed | Communal Distribution planned interruptions | CD1 · 30 min · tF (sensor, else heat meter); CD · sensor dP | ≤ 1 a year | count of noticed (≥48h) interruptions. Uses design/minDPIndex | Previous 12 months |
| CD‑KPI‑06 | HNTAS · assessed | CD network heat loss | CD1 · 30 min · heat meter kWh | per design W/dwelling basis | initiation kWh - Σ(termination kWh), as W/dwelling | Monthly |
| CD‑KPI‑07 | HNTAS · reported | CD average flow temperature | CD1 · 30 min · tF (sensor, else heat meter) | [expected] | time-weighted mean. Uses design/tF | Monthly |
| CD‑KPI‑08 | HNTAS · reported | CD average return temperature | CD1 · 30 min · tR (sensor, else heat meter) | [expected] | time-weighted mean. Uses design/tR | Monthly |
| CD‑KPI‑09 | HNTAS · assessed | CD network bypass flow rate | CD1 · 30 min · heat meter m³/h | [design bypass allowance] | initiation q - Σ(termination q) | Monthly |
| **Hours below outage limits (alternative to 04/05)** | | | | | | |
| CD‑KPI‑H‑01 | Heatweb | Communal Distribution hours below outage limits | CD1 · 30 min · tF (sensor, else heat meter); CD3 · 5 min · sensor dpIndex | < 60 h a year, judged on the month pro rata (≈ 4.9 h in 30 days); shorter windows report hours used | Σ_i min(t_{i+1} − t_i, 1 h) over readings with tF < tF_min or dP < dP_min; tF and dP spans unioned. Offered as an alternative to KPI-04/05. Uses design/minFlowTemp design/minDPIndex | Monthly (pro rata) |

## Consumer Connection (CC)

| Code | Standing | KPI | Monitoring points | Threshold | Calculation | Period |
|---|---|---|---|---|---|---|
| CC‑KPI‑01 | HNTAS · assessed | Consumer Connection ARMS connectivity (aggregated) | all CC points | ≥ 90% | received intervals ÷ expected intervals across ALL CC points combined | Monthly |
| CC‑KPI‑02 | HNTAS · assessed | Consumer Connection data completeness (aggregated) | all CC points | ≥ 85% | valid readings ÷ expected readings across all CCs | Monthly |
| CC‑KPI‑03 | HNTAS · assessed | Consumer Connection monitoring points operational (aggregated) | all CC points | = 100% | points with no error/negative/out-of-range values ÷ total points (two-stage; ALL heat-meter channels tF tR m³ q kW kWh) | Monthly |
| CC‑KPI‑04 | HNTAS · assessed | Consumer Connection unplanned interruptions | CC1 · 30 min · tF (heat meter, else sensor) | ≤ 3 a year | count of unplanned interruptions (≥ 12 h below minimum flow temp) | Previous 12 months |
| CC‑KPI‑05 | HNTAS · assessed | Consumer Connection planned interruptions | CC1 · 30 min · tF (heat meter, else sensor) | ≤ 1 a year | count of planned interruptions (≥ 12 h below minimum flow temp) | Previous 12 months |
| CC‑KPI‑06 | HNTAS · reported | Consumer Connection heat generation efficiency | CC1 · 30 min · tF (heat meter, else sensor) | ≥ 90% of design efficiency target | heat generated at the CC ÷ energy input to the CC | Monthly |
| CC‑KPI‑07 | HNTAS · assessed | Consumer Connection volume-weighted average return temperature | CC1 · 30 min · tR (heat meter, else sensor); heat meter m³/h | ≤ 45 °C | Σ(tR · q) ÷ Σ(q) by 5-min buckets | Monthly |
| CC‑KPI‑07A | HNTAS · reported | Consumer Connection average return temperature (reported) | CC1 · 30 min · tR (heat meter, else sensor) | expected value | time-average of tR | Monthly |
| CC‑KPI‑08 | HNTAS · assessed | Consumer Connection volume-weighted average temperature difference (VWATD) | CC1 · 30 min · heat meter kWh, m³ | ≥ 5 °C (pair: CC-07 or CC-08 must be met) | kWh register delta ÷ (1.163 · m³ register delta) | Monthly |
| **Cooling forms** | | | | | | |
| CC‑KPI‑C‑01 | HNTAS-style · proposed | Consumer Connection cooling ARMS connectivity (aggregated) | CC1 · all cooling meter channels | ≥ 90% | Σ intervals received ÷ Σ intervals expected, all cooling CC points combined | Monthly |
| CC‑KPI‑C‑02 | HNTAS-style · proposed | Consumer Connection cooling data completeness (aggregated) | CC1 · all cooling meter channels | ≥ 85% | Σ valid readings ÷ Σ expected readings, all cooling CC points combined | Monthly |
| CC‑KPI‑C‑03 | HNTAS-style · proposed | Consumer Connection cooling monitoring points operational (aggregated) | CC1 · 30 min · cooling meter kWh, m³, m³/h, kW, tF, tR | = 100% | points with no error, negative or out-of-range value ÷ points connected with complete data (C-01, C-02); every cooling-meter channel | Monthly |
| CC‑KPI‑C‑04 | HNTAS-style · proposed | Consumer Connection cooling unplanned interruptions | CC1 · 30 min · cooling meter tF | ≤ 3 a year | count of unplanned periods ≥ 12 h with chilled flow tF > maximum chilled flow temperature. Uses design/tFMaxCool (proposed) | Previous 12 months |
| CC‑KPI‑C‑05 | HNTAS-style · proposed | Consumer Connection cooling planned interruptions | CC1 · 30 min · cooling meter tF | ≤ 1 a year | count of planned periods ≥ 12 h with chilled flow tF > maximum chilled flow temperature. Uses design/tFMaxCool (proposed) | Previous 12 months |
| CC‑KPI‑C‑07 | HNTAS-style · proposed | Consumer Connection cooling volume-weighted average return temperature | CC1 · 30 min · cooling meter tR, m³/h | ≥ design cooling return − 2 °C (proposed; pair: C-07 or C-08 must be met) | Σ(tR · q) ÷ Σ q over 5-minute buckets. Uses design/tRCool (proposed) | Monthly |
| CC‑KPI‑C‑07A | HNTAS-style · reported · proposed | Consumer Connection cooling average return temperature (reported) | CC1 · 30 min · cooling meter tR | expected value | Σ tR ÷ n (time average) | Monthly |
| CC‑KPI‑C‑08 | HNTAS-style | Consumer Connection cooling volume-weighted average temperature difference | CC1 · 30 min · cooling meter kWh, m³ | ≥ 4 °C (proposed; pair: C-07 or C-08 must be met) | ΔT = ΔE ÷ (1.163 · ΔV); ΔE, ΔV = register deltas over the period (kWh, m³) | Monthly |
| **Meter health** | | | | | | |
| CC‑KPI‑M‑01 | Heatweb | Meter reporting (not silent) | CC1 · 30 min · heat meter kWh; cooling meter kWh | last reading within 72 h of period end | a reading on every meter within the last 72 h of the period | Rolling 7 days; month |
| CC‑KPI‑M‑02 | Heatweb | Meter channel coverage | CC1 · 30 min · heat meter kWh, m³, m³/h, kW, tF, tR | 6 of 6 channels | channels with ≥ 1 reading among kWh, m³, m³/h, kW, tF, tR (the fewest on any of the dwelling’s meters) | Rolling 7 days; month |
| CC‑KPI‑M‑03 | Heatweb | Meter reading cadence | CC1 · 30 min · heat meter kWh; cooling meter kWh | ≥ 0.9 readings per day | energy-register readings ÷ days in period | Rolling 7 days; month |
| CC‑KPI‑M‑04 | Heatweb | Register integrity | CC1 · 30 min · heat meter kWh; cooling meter kWh | 0 faults | days with ΔE < 0 (register stepped back) or ΔE > 500 kWh (implausible jump), all the dwelling’s meters | Rolling 7 days; month |
| CC‑KPI‑M‑05 | Heatweb | Plausible temperature difference | CC1 · 30 min · heat meter kWh, m³; cooling meter kWh, m³ | 0 °C ≤ ΔT ≤ 80 °C | ΔT = ΔE ÷ (1.163 · ΔV) within bounds; outside = scaling, units or a replaced meter | Rolling 7 days; month |
| CC‑KPI‑M‑06 | Heatweb | Flow comes to rest (no constant flow) | CC1 · 30 min · heat meter m³/h; cooling meter m³/h | ≥ 2% of flow readings at zero | readings with q = 0 ÷ all q readings, per meter (needs ≥ 6 readings); below target = flow never at rest: bypass or control fault | Rolling 7 days; month |
| CC‑KPI‑M‑07 | Heatweb | No low temperature difference at volume | CC1 · 30 min · heat meter kWh, m³; cooling meter kWh, m³ | heat: not (ΔT < 5 °C and > 150 L/day); cooling: not (ΔT < 2 °C and > 1,000 L/day) | ΔT = ΔE ÷ (1.163 · ΔV); L/day = 1000 · ΔV ÷ days | Rolling 7 days; month |
| CC‑KPI‑M‑08 | Heatweb | No simultaneous heating and cooling | CC1 · 30 min · heat meter kWh; cooling meter kWh | < 30% of active days | days with heat ΔE > 0.5 kWh and cooling ΔE > 0.5 kWh ÷ days with either | Rolling 7 days; month |
| CC‑KPI‑M‑09 | Heatweb | Load follows demand (no flat load) | CC1 · 30 min · heat meter kWh | CV ≥ 0.2 | CV = σ ÷ μ of daily heat ΔE over ≥ 7 days, applied when μ > 2 kWh/day; below target = constant load: control fault | Rolling 7 days; month |
| CC‑KPI‑M‑10 | Heatweb · reported | Consumption band (reported) | CC1 · 30 min · heat meter kWh, m³; cooling meter kWh, m³ | low: < 2 kWh/day and < 40 L/day; high: > max(15 kWh/day, 2 × site median) | daily ΔE and ΔV compared with the site's median dwelling | Rolling 7 days; month |
| CC‑KPI‑M‑11 | Heatweb · reported | Cooling offset by heating (24 h overlap) | CC1 · 30 min · heat meter kWh; cooling meter kWh | expected value (reported; site-wide figure on the combined element) | Σ_d min(ΔE_heat,d, ΔE_cool,d) ÷ Σ_d ΔE_cool,d over the period's days | Rolling 7 days; month |

