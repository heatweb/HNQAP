# Varkeys

Generated from `vocabulary.json` exported 2026-10-02T01:15:50.927Z. 868 names.

A varkey may be allowed under more than one vargroup; it is listed under each. The shape (type, units) is the same everywhere.

## Index
- [`acceptance`](#acceptance) (238)
- [`callout`](#callout) (5)
- [`design`](#design) (120)
- [`device`](#device) (1)
- [`emeter`](#emeter) (7)
- [`gmeter`](#gmeter) (3)
- [`hnes_application`](#hnes_application) (31)
- [`hnes_asmt`](#hnes_asmt) (140)
- [`hnes_rev_study`](#hnes_rev_study) (77)
- [`hnes_rfi`](#hnes_rfi) (25)
- [`model_signoff`](#model_signoff) (18)
- [`onboarding`](#onboarding) (16)
- [`sensor`](#sensor) (4)
- [`set`](#set) (1)
- [`setpoint`](#setpoint) (1)
- [`site`](#site) (1)
- [`status`](#status) (7)
- [`survey`](#survey) (201)
- [`system`](#system) (3)
- [`wp_replace_pressure_gauge`](#wp_replace_pressure_gauge) (7)

## acceptance

| Varkey | Type | Units | Title | Meaning | Aliases | Status |
|---|---|---|---|---|---|---|
| `3AFusedSpur` | passfail |  | 3 Amp Fused Spur |  |  | approved |
| `adeyProChecked` | boolean |  | Adey Pro-Checked |  |  | approved |
| `adjustedDPCV` | boolean |  | DPCV Adjusted to Design Flowrate |  |  | approved |
| `allAppliancesCommissioned` | passfail |  | All Appliances Commissioned |  |  | approved |
| `allLabelsAttached` | passfail |  | All Labels Attached |  |  | approved |
| `allOff1` | select |  | Check All Off |  |  | approved |
| `allOff2` | select |  | Check All Off |  |  | approved |
| `allOff2b` | select |  | Check Bath Off |  |  | approved |
| `allOff3` | select |  | Check All Off |  |  | approved |
| `allStrainersCleaned` | passfail |  | All Strainers Cleaned |  |  | approved |
| `benchmarkCompleted` | boolean |  | CYLINDER BENCHMARK FORM BEEN COMPLETED |  |  | approved |
| `bleedHIU` | select |  | Bleed air from HIU |  |  | approved |
| `checkCasing` | boolean |  | HIU Casing |  |  | approved |
| `checkFLoop1` | passfail |  | Check Filling Loop |  |  | approved |
| `checkFLoop2` | select |  | Filling Loop Disconnected & Capped |  |  | approved |
| `checkFlushingBypass` | select |  | Flushing Bypass |  |  | approved |
| `checkHeatMeter` | boolean |  | Heat Meter |  |  | approved |
| `checkParameters` | select |  | Paramaters Adjusted |  |  | approved |
| `checkPrimaryStrainer` | select |  | Check Primary Strainer |  |  | approved |
| `checkPumpOff` | boolean |  | Check Pump Off |  |  | approved |
| `checkTestPoints` | boolean |  | Differential Pressure Test Points |  |  | approved |
| `checkTRVs` | select |  | TRVs Adjusted |  |  | approved |
| `ciuCondition` | passfail |  | CIU Condition |  |  | approved |
| `ciuDataPlate` | passfail |  | Data Plate |  |  | approved |
| `classBS8635` | number |  | classBS8635 |  |  | approved |
| `cleanCombiValve` | boolean |  | Clean Combination Valve |  |  | approved |
| `connectionsCheckedBasin` | boolean |  | APPLIANCE CONNECTIONS CHECKED |  |  | approved |
| `connectorCheckedToilet` | boolean |  | FLUSH PIPE/ SOIL PAN CONNECTOR CHECKED |  |  | approved |
| `coolingOperation` | passfail |  | Cooling Operation |  |  | approved |
| `dateToday` | number |  | dateToday |  |  | approved |
| `dp1` | number | kPa | Initial Readings, Differential Pressure |  |  | approved |
| `dp1calc` | number |  | dp1calc |  |  | approved |
| `dpDHWPeak` | number | kPa | DHW Readings, Differential Pressure |  |  | approved |
| `failsafeBasin` | passfail |  | Bathroom Basin Tap Fail Safe |  |  | approved |
| `fcuWorking` | passfail |  | FCU Working |  |  | approved |
| `fDHW` | number | ltr/min | DHW Readings, Kitchen Tap Flow Rate |  |  | approved |
| `fDHWBasin` | number | ltr/min | Bathroom Basin Tap Flow Rate |  |  | approved |
| `fDHWBath` | number | ltr/min | Bath Tap Flow Rate |  |  | approved |
| `flowLimitKitchen` | boolean |  | Flow Limiters Installed on Kitchen Tap |  |  | approved |
| `flushedCylinder` | boolean |  | Hot water cylinder drained and flushed |  |  | approved |
| `flusherCheckedToilet` | passfail |  | Toilet Flusher Checked |  |  | approved |
| `followUpBy` | select |  | Follow Up By |  |  | approved |
| `followUpRequired` | textarea |  | Follow Up |  |  | approved |
| `heatingFlushed` | boolean |  | Central Heating Flushed |  |  | approved |
| `heatingLeakFree` | boolean |  | Central Heating Free from Leaks |  |  | approved |
| `heatingStrainerClean` | boolean |  | Central Heating Strainer Clean |  |  | approved |
| `hiuModel` | text |  | HIU Make and Model |  |  | approved |
| `hiuParameters` | sheet |  | HIU Parameters |  |  | approved |
| `hiuType` | select |  | HIU Type |  |  | approved |
| `hotColdCheckedBasin` | passfail |  | Hot and Cold Taps Checked |  |  | approved |
| `hotColdCheckedBath` | boolean |  | HOT AND COLD CHECKED |  |  | approved |
| `hotColdCheckedKitchen` | boolean |  | HOT AND COLD CHECKED |  |  | approved |
| `hotColdCheckedShower` | boolean |  | HOT AND COLD CHECKED |  |  | approved |
| `htgControlsChecked` | passfail |  | Heating Controls Checked |  |  | approved |
| `immersionsBothOn` | boolean |  | Setup Times |  |  | approved |
| `indexTap3Bar` | boolean |  | PRV set for 3 bar at Index Tap |  |  | approved |
| `isBath` | boolean |  | Bath tub fitted |  |  | approved |
| `isEnsuite1` | boolean |  | Ensuite with Shower |  |  | approved |
| `isolationCheckedToilet` | boolean |  | ISOLATION VALVE CHECKED |  |  | approved |
| `issue1` | textarea |  | Issue 1 |  |  | approved |
| `issue2` | textarea |  | Issue 2 |  |  | approved |
| `issue3` | textarea |  | Issue 3 |  |  | approved |
| `issue4` | textarea |  | Issue 4 |  |  | approved |
| `issue5` | textarea |  | Issue 5 |  |  | approved |
| `issue6` | textarea |  | Issue 6 |  |  | approved |
| `issue7` | textarea |  | Issue 7 |  |  | approved |
| `issue8` | textarea |  | Issue 8 |  |  | approved |
| `isToilet` | boolean |  | Bathroom fitted with toilet |  |  | approved |
| `kw1` | number | kW | Initial Readings, Meter Power |  |  | approved |
| `kwDHW1` | number | kW | DHW Readings, Meter Power |  |  | approved |
| `kwDHWPeak` | number | kW | DHW Readings, Meter Power |  |  | approved |
| `kwh1` | number | kWh | Initial Readings, Meter Energy |  |  | approved |
| `kwhFinal` | number | kWh | Final Meter Reading and Photo |  |  | approved |
| `kwHTGPeak` | number | kW | HTG Readings, Meter Power |  |  | approved |
| `labelledFusedSpur` | passfail |  | Labelled Fused Spur |  |  | approved |
| `labelsFitted` | passfail |  | COMMISSIONING LABELS |  |  | approved |
| `lengthD1` | number |  | Length of D1 discharge pipework |  |  | approved |
| `lengthD1Below600` | boolean |  | D1 Length Below 600mm |  |  | approved |
| `lengthD2` | number |  | Length of D2 discharge pipework |  |  | approved |
| `lengthD2Drop300` | passfail |  | D2 Length 300mm Before Elbow |  |  | approved |
| `limescaleReducerFitted` | boolean |  | Limescale Reducer Fitted |  |  | approved |
| `limiterBathTap` | text |  | Bath Tap Flow Restrictor |  |  | approved |
| `litresInhibitor` | text | l | Inhibitor Volume Added |  |  | approved |
| `locationCombiValve` | text |  | Position of Combination Valve |  |  | approved |
| `locationCyl` | text |  | Cylinder Location |  |  | approved |
| `lphPeak` | number | ltr/h | Peak HTG Primary Flow Rate (litres per hour) |  |  | approved |
| `m31` | number | m3 | Initial Readings, Meter Volume |  |  | approved |
| `m3h1` | number | m³/h | Initial Readings, Meter Flow Rate |  |  | approved |
| `m3hDHW1` | number | m³/h | DHW Readings, Meter Flow Rate |  |  | approved |
| `m3hDHWPeak` | number | m³/h | DHW Readings, Meter Flow Rate |  |  | approved |
| `m3hHTGPeak` | number | m³/h | HTG Readings, Meter Flow Rate |  |  | approved |
| `m3WaterMeter` | number | m3 | Cold Water Meter Reading |  |  | approved |
| `mainsStopcock` | text |  | Cold Mains Stopcock |  |  | approved |
| `makeCleansingAgent` | text |  | Cleansing Agent |  |  | approved |
| `makeControl` | text |  | Time Controller Make |  |  | approved |
| `makeInhibitor` | text |  | Inhibitor Make |  |  | approved |
| `makeModelHeatMeter` | text |  | Heat Meter Make and Model |  |  | approved |
| `makePump` | text |  | Pump Make |  |  | approved |
| `manualsHandedOver` | boolean |  | Manuals and Certificates Handed to Client |  |  | approved |
| `manualUFH` | text |  | UFH Manual Override |  |  | approved |
| `manufacturer` | text |  | Cylinder Make |  |  | approved |
| `metersAccessible` | passfail |  | Heat Meters Accessible |  |  | approved |
| `model` | text |  | Cylinder Model |  |  | approved |
| `modelControl` | text |  | Time Controller Model |  |  | approved |
| `modelPump` | text |  | Pump Model |  |  | approved |
| `mvhrVentsFitted` | passfail |  | MVHR Ceiling Vents Fitted |  |  | approved |
| `mvhrWorking` | passfail |  | MVHR Working |  |  | approved |
| `nFloors` | number |  | Number of floors |  |  | approved |
| `nRads` | number |  | Number of radiators |  |  | approved |
| `nZones` | number |  | Number of zones |  |  | approved |
| `opTime` | number | h | Initial Readings, Operating Time |  |  | approved |
| `overflowBasin` | passfail |  | Bathroom Basin Overflow |  |  | approved |
| `overflowBath` | passfail |  | Bath Overflow |  |  | approved |
| `overflowKitchen` | passfail |  | OVERFLOW TESTED |  |  | approved |
| `p1` | number | bar | Initial Readings, Static Primary Flow Pressure |  |  | approved |
| `p2` | number | bar | Initial Readings, Static Primary Return Pressure |  |  | approved |
| `passfailDHWBathTemp` | number |  | passfailDHWBathTemp |  |  | approved |
| `passfailDHWResponse` | number |  | passfailDHWResponse |  |  | approved |
| `passfailDHWSetpointH` | number |  | passfailDHWSetpointH |  |  | approved |
| `passfailDHWSetpointL` | number |  | passfailDHWSetpointL |  |  | approved |
| `passfailHeatMeter` | number |  | passfailHeatMeter |  |  | approved |
| `passfailHTGRtnTemp` | number |  | passfailHTGRtnTemp |  |  | approved |
| `passfailHTGSetpoint` | number |  | passfailHTGSetpoint |  |  | approved |
| `pCHWFinal` | number |  | Cooling System Pressure |  |  | approved |
| `pCWS` | text |  | Incoming Cold Water Pressure |  |  | approved |
| `pHTG1` | number | bar | Initial Readings, Central Heating Pressure |  |  | approved |
| `pHTG2` | number | bar | Top-up Heating Pressure |  |  | approved |
| `pHTGFill` | number | bar | Fill Central Heating Pressure |  |  | approved |
| `pHTGFinal` | number | bar | Final Central Heating Pressure |  |  | approved |
| `pHTGMin` | number | bar | Minimum system fill pressure |  |  | approved |
| `pipeworkFixed` | boolean |  | Pipework Fastened |  |  | approved |
| `primaryInsulation` | text |  | Primary Insulation |  |  | approved |
| `primaryStrainerClean` | passfail |  | Primary Strainer Clean |  |  | approved |
| `productGroup` | number |  | productGroup |  |  | approved |
| `programmerDateTimeCorrect` | passfail |  | Check Programmer Times |  |  | approved |
| `propertyType` | select |  | Select Property Type |  |  | approved |
| `proveFlowToZones` | passfail |  | Flow to all UFH zones |  |  | approved |
| `proveStatsMatchZones` | passfail |  | Check each room stat controls the correct zones. |  |  | approved |
| `pumpFree` | passfail |  | Pump Free and Bled |  |  | approved |
| `pumpHTG` | number |  | pumpHTG |  |  | approved |
| `pumpSpeedHTG` | text |  | Pump Speed |  |  | approved |
| `radsAndTowelRailsWorking` | passfail |  | Rads and Towel Rails Working |  |  | approved |
| `rechargedExpansion` | boolean |  | Cylinder internal expansion recharged |  |  | approved |
| `refitCasing` | select |  | Refit Casing |  |  | approved |
| `relayRoomStat` | select |  | Room thermostat relay |  |  | approved |
| `removeCasing` | boolean |  | Remove Casing |  |  | approved |
| `runDHWPeak` | select |  | Run Peak DHW |  |  | approved |
| `runHTG` | select |  | Run Central Heating |  |  | approved |
| `runHTGDP` | boolean |  | Run Central Heating |  |  | approved |
| `safeCylinderInstall` | boolean |  | Installed Safe and Secure |  |  | approved |
| `safetyControlsInstall` | boolean |  | Installed Safety Controls Correctly |  |  | approved |
| `schematicAvailable` | passfail |  | Schematic Available |  |  | approved |
| `secureBasin` | passfail |  | Bathrom Basin Pedastal & Taps Secure |  |  | approved |
| `secureBath` | passfail |  | BATH AND TAPS SECURE |  |  | approved |
| `secureKitchen` | passfail |  | Kitchen Sink Pedastal & Taps Secure |  |  | approved |
| `serialBilling` | text |  | Metering Home Display Serial Number |  |  | approved |
| `serialCyl` | text |  | Cylinder Serial Number |  |  | approved |
| `serialHeatMeter` | text |  | Heat Meter Serial Number |  |  | approved |
| `serialHIU` | text |  | HIU Serial Number |  |  | approved |
| `serialPump` | text |  | Pump Serial Number |  |  | approved |
| `serialWaterMeter` | text |  | Cold Water Meter Serial Number |  |  | approved |
| `settingDPCV` | text |  | DPCV Setting |  |  | approved |
| `settingIHPT` | number |  | IPHT Setting |  |  | approved |
| `settingImmersionStat` | text |  | Temperature Setting of Immersion Heaters |  |  | approved |
| `settingRAVK` | number |  | RAVK (Htg) Setting |  |  | approved |
| `setupControllerTimes` | boolean |  | Setup Times |  |  | approved |
| `showerEnclosureChecked` | boolean |  | ENCLOSURE CHECKED FOR LEAKS |  |  | approved |
| `showerTraySealed` | passfail |  | TRAY / WASTE MASTIC SEALED |  |  | approved |
| `signsOfLeaks` | text |  | Leaks on Pipework |  |  | approved |
| `soilAccessGapsOK` | boolean |  | ACCESS GAPS SECURE AND ACCESSIBLE |  |  | approved |
| `soilDurgos110` | boolean |  | DURGOS 110MM DB20 |  |  | approved |
| `soilDurgosVentilated` | boolean |  | DURGOS VENTILATED |  |  | approved |
| `spares` | sheet |  | Spare Parts |  |  | approved |
| `stickerFitted` | passfail |  | INSTALLATION STICKER |  |  | approved |
| `storageVolume` | text |  | Cylinder Volume |  |  | approved |
| `supportD2` | boolean |  | D2 Pipework Clipped at 300mm |  |  | approved |
| `systemCleansed` | boolean |  | Central Heating Chemically Cleansed |  |  | approved |
| `systemTreated` | boolean |  | System Chemically Treated |  |  | approved |
| `systemVolume` | number | l | Central Heating Volume |  |  | approved |
| `tap45in45` | passfail |  | DHW Response |  |  | approved |
| `tapTime45C` | number | seconds | Time for Kitchen Tap to reach 45°C |  |  | approved |
| `tapTime50C` | number | seconds | DHW Readings, Time for Kitchen Tap to reach 50°C |  |  | approved |
| `tColdHot` | number | °C | DHW pipework cold prior to response time testing. |  |  | approved |
| `tCWS` | number | °C | Kitchen Tap Cold Temperature |  |  | approved |
| `tDesignHTGRtn` | number |  | tDesignHTGRtn |  |  | approved |
| `tDHW` | number | °C | DHW Readings, Kitchen Tap Temperature |  |  | approved |
| `tDHW1` | number | °C | Kitchen Tap Temperature |  |  | approved |
| `tDHW2` | boolean | °C | Adjusted Kitchen Tap Temperature |  |  | approved |
| `tDHWBasin` | number | °C | Bathroom Basin Tap Temperature |  |  | approved |
| `tDHWBasinMaintained` | passfail |  | Bathroom Basin Tap Temperature Maintained |  |  | approved |
| `tDHWBath` | number | °C | Bath Tap Temperature |  |  | approved |
| `tDHWPeak` | number | °C | DHW Readings, Peak Output Temperature |  |  | approved |
| `tDHWShower` | number | °C | DHW Readings, Shower Output Temperature |  |  | approved |
| `tDHWTap` | number |  | tDHWTap |  |  | approved |
| `testoFittedDHW` | select |  | Test sensors ready |  |  | approved |
| `testoPrefix` | number |  | testoPrefix |  |  | approved |
| `tF1` | number | °C | Initial Readings, Meter Flow Temperature |  |  | approved |
| `tFDHW1` | number | °C | DHW Readings, Meter Flow Temperature |  |  | approved |
| `tFDHWPeak` | number | °C | DHW Readings, Meter Flow Temperature |  |  | approved |
| `tFHTGPeak` | number | °C | HTG Readings, Meter Flow Temperature |  |  | approved |
| `tHTGOut` | number | °C | HTG Readings, Tertiary Output Temperature |  |  | approved |
| `tHTGRtn` | number | °C | HTG Readings, Tertiary Return Temperature |  |  | approved |
| `tLimitHTGRtn` | number |  | tLimitHTGRtn |  |  | approved |
| `tmvBasin` | boolean |  | Bathroom Basin TMV |  |  | approved |
| `tmvBasinLocation` | text |  | Bathroom Basin TMV Location |  |  | approved |
| `tmvBasinMakeModel` | text |  | Bathroom Basin TMV Make and Model |  |  | approved |
| `tmvBasinType` | text |  | Bathroom Basin TMV Certification Scheme |  |  | approved |
| `tR1` | number | °C | Initial Readings, Meter Return Temperature |  |  | approved |
| `trapChecked` | passfail |  | Trap Checked |  |  | approved |
| `trapInstall` | boolean |  | Waterless Waste Trap Vertical |  |  | approved |
| `tRDHW1` | number | °C | DHW Readings, Meter Return Temperature |  |  | approved |
| `tRDHWPeak` | number | °C | DHW Readings, Meter Return Temperature |  |  | approved |
| `tRHTGPeak` | number | °C | HTG Readings, Meter Return Temperature |  |  | approved |
| `trvPresets` | sheet |  | Radiator Return Temperatures |  |  | approved |
| `tSetDHW` | number |  | tSetDHW |  |  | approved |
| `tSetHTG` | number |  | tSetHTG |  |  | approved |
| `tSetpointDHW` | number | °C | DHW Setpoint Temperature |  |  | approved |
| `tSetpointHTG` | number | °C | HIU Heating Setpoint Temperature |  |  | approved |
| `tTolerance` | number | °C | DHW Temperature Tolerance |  |  | approved |
| `tToleranceHTG` | number | °C | HTG Temperature Tolerance |  |  | approved |
| `tundishInstall` | boolean |  | Tundish Installed Vertical in Space |  |  | approved |
| `typeDHW` | select |  | DHW Type |  |  | approved |
| `typeEmitter` | select |  | Central heating emitter |  |  | approved |
| `typeEmitterD` | number |  | typeEmitterD |  |  | approved |
| `typeHTG` | number |  | typeHTG |  |  | approved |
| `typeRoomStat` | text |  | Room thermostat |  |  | approved |
| `typeRTL` | select |  | Radiator return control |  |  | approved |
| `typeTRV` | select |  | Radiator flow control |  |  | approved |
| `ufhFlowRates` | textarea |  | Underfloor Heating Zone Flow Rates |  |  | approved |
| `ufhLabelled` | boolean |  | Underfloor Heating Labelling |  |  | approved |
| `ufhOverheat` | boolean |  | Underfloor Heating Overheat Protection |  |  | approved |
| `ufhOverheatStatFitted` | passfail |  | UFH Overheat Fitted |  |  | approved |
| `ufhOverheatStatTested` | passfail |  | UFH Overheat Tested |  |  | approved |
| `unswitchedFusedSpur` | passfail |  | Unswitched Fused Spur |  |  | approved |
| `voltageRoomStat` | select |  | Room thermostat volt-free |  |  | approved |
| `washingMachineWasteChecked` | passfail |  | Washing Machine Waste Pipe Checked |  |  | approved |
| `wastePipeFloodTested` | passfail |  | Waste Pipe Flood Tested |  |  | approved |
| `waterSamplesTaken` | boolean |  | Water Samples Taken |  |  | approved |

## callout

| Varkey | Type | Units | Title | Meaning | Aliases | Status |
|---|---|---|---|---|---|---|
| `actionsPerformed` | richtext |  | Actions Performed |  |  | approved |
| `actionsRecommended` | richtext |  | Actions Recommended |  |  | approved |
| `initialFindings` | richtext |  | Initial Findings |  |  | approved |
| `scopeOfWorks` | richtext |  | Scope of Works |  |  | approved |
| `spares` | sheet |  | Spare Parts |  |  | approved |

## design

| Varkey | Type | Units | Title | Meaning | Aliases | Status |
|---|---|---|---|---|---|---|
| `allowPipeDiff` | boolean |  | Allow different flow and return pipe sizing |  |  | approved |
| `ASHPkW` | number |  | ASHPkW |  |  | approved |
| `ASHPkWPeak` | number |  | ASHPkWPeak |  |  | approved |
| `ASHPkWxN1` | number |  | ASHPkWxN1 |  |  | approved |
| `ASHPQty` | number |  | ASHPQty |  |  | approved |
| `baseTemp` | select |  | Base temperature |  |  | approved |
| `boilerEmissions` | number | kgCO2/kWh | Boiler Emissions |  |  | approved |
| `boilerFuel` | select |  | Boiler fuel type |  |  | approved |
| `boilerkWPeak` | number |  | boilerkWPeak |  |  | approved |
| `boilerkWxN1` | number |  | boilerkWxN1 |  |  | approved |
| `borePeak` | number |  | borePeak |  |  | approved |
| `bufferkWh` | number |  | bufferkWh |  |  | approved |
| `carbonFactorElec` | number | kgCO2e/kWh | Electricity carbon factor | Carbon factor for grid electricity | co2Elec | approved |
| `carbonFactorGas` | number | kgCO2e/kWh | Gas carbon factor | Carbon factor for gas (UK Government GHG conversion factors) | co2Gas | approved |
| `connectionCH` | select |  | Central heating connection |  |  | approved |
| `dDaysCalc` | number |  | dDaysCalc |  |  | approved |
| `dDaysPeak` | number |  | dDaysPeak |  |  | approved |
| `degDays` | number | °days | Central heating degree-days at base temperature |  |  | approved |
| `degDaysAvg` | csv | °days | Central heating degree-days |  |  | approved |
| `density` | number |  | density |  |  | approved |
| `divCH` | number | % | Central heating diversity |  |  | approved |
| `efficiency` | number | % | Minimum Generation Efficiency |  |  | approved |
| `elecEmissions` | number | kgCO2/kWh | Electrical Supply Emissions |  |  | approved |
| `elecPrice` | number | p/kWh | Electricity unit price | Electricity unit price | costElec | approved |
| `email` | email |  | Email address |  |  | approved |
| `eqDaysPeak` | number |  | eqDaysPeak |  |  | approved |
| `eqPropDS439` | number |  | eqPropDS439 |  |  | approved |
| `fridgeASHP` | select |  | ASHP refrigerant |  |  | approved |
| `fridgeWSHP` | select |  | WSHP refrigerant |  |  | approved |
| `gasCalorificValue` | number | MJ/m³ | Gas calorific value | Calorific value used to convert metered gas m³ to kWh (kWh = m³ × correction × CV ÷ 3.6) | calorificGas | approved |
| `gasPrice` | number | p/kWh | Gas unit price | Gas unit price | costGas | approved |
| `gasVolumeCorrection` | number | factor | Gas volume correction | Gas volume correction factor applied to metered m³ |  | approved |
| `goASHP` | boolean |  | Air Source Heat Pumps |  |  | approved |
| `goBoilers` | boolean |  | Boilers |  |  | approved |
| `goCHP` | boolean |  | Combined Heat & Power |  |  | approved |
| `goHN` | boolean |  | External Heat Network Supply |  |  | approved |
| `goReclaim` | boolean |  | Cooling Source Heat Pumps |  |  | approved |
| `goSave` | boolean |  | Save design |  |  | approved |
| `goSolar` | boolean |  | Solar Thermal |  |  | approved |
| `goWSHP` | boolean |  | Water Source Heat Pumps |  |  | approved |
| `hHighPoint` | number | m | System height |  |  | approved |
| `kwCH` | number |  | kwCH |  |  | approved |
| `kwDHWEst` | number |  | kwDHWEst |  |  | approved |
| `kwDS439` | number |  | kwDS439 |  |  | approved |
| `kwh365` | number |  | kwh365 |  |  | approved |
| `kwhAnnualPump` | number | kWh | Design Annual Pump Energy Use |  |  | approved |
| `kwhCH` | number |  | kwhCH |  |  | approved |
| `kwhCH365` | number |  | kwhCH365 |  |  | approved |
| `kwhDHW365` | number |  | kwhDHW365 |  |  | approved |
| `kwhDHWEST` | number |  | kwhDHWEST |  |  | approved |
| `kwhDistLoss365` | number |  | kwhDistLoss365 |  |  | approved |
| `kwhP24` | number |  | kwhP24 |  |  | approved |
| `kwhUsed365` | number |  | kwhUsed365 |  |  | approved |
| `kWInPeak` | number |  | kWInPeak |  |  | approved |
| `kwP24` | number |  | kwP24 |  |  | approved |
| `kwPeak` | number |  | kwPeak |  |  | approved |
| `kWxN1` | number |  | kWxN1 |  |  | approved |
| `listASHPSizes` | csv | kW | Available heat pump outputs |  |  | approved |
| `listBSizes` | csv | kW | Available boiler outputs |  |  | approved |
| `listWSHPSizes` | csv | kW | Available heat pump outputs |  |  | approved |
| `loadSchedule` | sheet |  | Schedule of loads |  |  | approved |
| `m3hCHPeak` | number |  | m3hCHPeak |  |  | approved |
| `m3hDHWPeak` | number | m³/h | DHW Readings, Meter Flow Rate |  |  | approved |
| `m3hPeak` | number |  | m3hPeak |  |  | approved |
| `maxApproachTemp` | number | °C | Maximum PHE Approach Temperature |  |  | approved |
| `maxBypassFlow` | number | m³/h | Design maximum bypass flowrate |  |  | approved |
| `maxDPOff` | number | kPa | Maximum Supply DP |  |  | approved |
| `maxDPSupply` | number | kPa | Maximum Supply DP |  |  | approved |
| `maxPressure` | number | bar | Maximum System Pressure |  |  | approved |
| `maxVelocity` | number | m/s | Flow pipe sizing maximum velocity |  |  | approved |
| `minDPIndex` | number | kPa | Minimum Index Differential Pressure |  |  | approved |
| `minFlowTemp` | number | °C | Minimum Flow Temperature |  |  | approved |
| `minFlowTempOff` | number | °C | Minimum Output Temperature |  |  | approved |
| `minVelocity` | number | m/s | Return pipe sizing minimum velocity |  |  | approved |
| `nBuildings` | integer | buildings | Number of buildings |  |  | approved |
| `networkName` | text |  | Network name |  |  | approved |
| `networkTempValve` | boolean |  | Network temperature control valve |  |  | approved |
| `nIntakes` | integer | intakes | Number of intake plantrooms |  |  | approved |
| `nPeople` | integer | people | Total number of people |  |  | approved |
| `nProperties` | integer | properties | Number of properties |  |  | approved |
| `ovsersizing` | number |  | ovsersizing |  |  | approved |
| `ovsersizingN1` | number |  | ovsersizingN1 |  |  | approved |
| `peepDS439` | number |  | peepDS439 |  |  | approved |
| `pipeSizes` | sheet |  | Schedule of pipes sizes |  |  | approved |
| `pPP` | number |  | pPP |  |  | approved |
| `profileDHW` | select |  | DHW load profile |  |  | approved |
| `selectASHP` | object | n x kW | ASHP selection |  |  | approved |
| `selectBoilers` | object | n x kW | Boiler selection |  |  | approved |
| `selectWSHP` | object | n x kW | WSHP selection |  |  | approved |
| `sessionIdleMinutes` | number | min | Session idle minutes | Idle gap that closes an equipment session (spray booth firing sequence) |  | approved |
| `sparekW` | number |  | sparekW |  |  | approved |
| `substationType` | select |  | Substation Type |  |  | approved |
| `supplyCWS` | select |  | CWS Supply |  |  | approved |
| `systemVolume` | number | l | Central Heating Volume |  |  | approved |
| `tariffHP` | select |  | Electrical Tariff |  |  | approved |
| `tF` | number | °C | Design flow temperature |  |  | approved |
| `tFOff` | number | °C | Design flow temperature (secondary) |  |  | approved |
| `tPeak` | number | °C | Peak network flow temperature |  |  | approved |
| `tPriRtnCH` | number | °C | Central heating network return temperature |  |  | approved |
| `tPriRtnDHW` | number | °C | DHW network return temperature |  |  | approved |
| `tPriRtnPeak` | number |  | tPriRtnPeak |  |  | approved |
| `tR` | number | °C | Expected average return temperature |  |  | approved |
| `tRiseEST` | number |  | tRiseEST |  |  | approved |
| `tVWART24` | number |  | tVWART24 |  |  | approved |
| `tXPeak` | number | °C | External temperature at peak load |  |  | approved |
| `typeEmitter` | select |  | Central heating emitter |  |  | approved |
| `typeRTL` | select |  | Radiator return control |  |  | approved |
| `typeTRV` | select |  | Radiator flow control |  |  | approved |
| `vBuffer` | number | l | Buffer volume |  |  | approved |
| `vBuffer9` | number |  | vBuffer9 |  |  | approved |
| `vDHWEST` | number |  | vDHWEST |  |  | approved |
| `vP24` | number |  | vP24 |  |  | approved |
| `vPCH` | number |  | vPCH |  |  | approved |
| `vPDHW` | number |  | vPDHW |  |  | approved |
| `vPHEST` | number |  | vPHEST |  |  | approved |
| `vPPEST` | number |  | vPPEST |  |  | approved |
| `WSHPkW` | number |  | WSHPkW |  |  | approved |
| `WSHPkWPeak` | number |  | WSHPkWPeak |  |  | approved |
| `WSHPkWxN1` | number |  | WSHPkWxN1 |  |  | approved |
| `WSHPQty` | number |  | WSHPQty |  |  | approved |

## device

| Varkey | Type | Units | Title | Meaning | Aliases | Status |
|---|---|---|---|---|---|---|
| `typeDHW` | select |  | DHW Type |  |  | approved |

## emeter

| Varkey | Type | Units | Title | Meaning | Aliases | Status |
|---|---|---|---|---|---|---|
| `ampsL1` | number | A | Current L1 | Current, phase 1 |  | approved |
| `ampsL2` | number | A | Current L2 | Current, phase 2 |  | approved |
| `ampsL3` | number | A | Current L3 | Current, phase 3 |  | approved |
| `kwhElectric` | number | kWh | Electricity register | Electricity meter register |  | approved |
| `wattsL1` | number | W | Power L1 | Active power, phase 1 |  | approved |
| `wattsL2` | number | W | Power L2 | Active power, phase 2 |  | approved |
| `wattsL3` | number | W | Power L3 | Active power, phase 3 |  | approved |

## gmeter

| Varkey | Type | Units | Title | Meaning | Aliases | Status |
|---|---|---|---|---|---|---|
| `gasFlow` | number | m³/h | Gas flow rate | Instantaneous gas flow rate |  | approved |
| `m3` | number | m³ | Gas register (m³) | Gas meter register, whole cubic metres |  | approved |
| `mm3` | number | L | Gas register (sub-m³) | Gas meter register, sub-cubic-metre part in litres |  | approved |

## hnes_application

| Varkey | Type | Units | Title | Meaning | Aliases | Status |
|---|---|---|---|---|---|---|
| `baselineKpis` | sheet |  | Baseline and target KPIs |  |  | approved |
| `budgetLines` | sheet |  | Budget by works package |  |  | approved |
| `clientName` | text |  | Applicant organisation |  |  | approved |
| `customersInNeedPct` | number | % | Customers in need |  |  | approved |
| `dataSharingConfirm` | boolean |  | Data sharing accepted |  |  | approved |
| `deliverability` | richtext |  | Deliverability and risk |  |  | approved |
| `eoiChecklist` | sheet |  | Readiness checklist |  |  | approved |
| `eoiSummary` | richtext |  | Expression-of-interest summary |  |  | approved |
| `expectedOutcomes` | richtext |  | Expected outcomes |  |  | approved |
| `grantType` | select |  | Grant type |  |  | approved |
| `localAuthorityArea` | text |  | Local authority area |  |  | approved |
| `matchFundingValue` | number | GBP | Applicant contribution |  |  | approved |
| `meteringOverview` | richtext |  | Metering and data |  |  | approved |
| `monitoringCommit` | boolean |  | Monitoring returns and KPI reporting accepted |  |  | approved |
| `orgType` | select |  | Organisation type |  |  | approved |
| `preAwardStatement` | textarea |  | Pre-award spend |  |  | approved |
| `problemStatement` | richtext |  | The problem to be solved |  |  | approved |
| `programmeSchedule` | sheet |  | Delivery programme |  |  | approved |
| `projectDescription` | richtext |  | Project description |  |  | approved |
| `projectName` | text |  | Project name |  |  | approved |
| `projectRef` | text |  | Existing HNES reference |  |  | approved |
| `propertiesManaged` | integer |  | Properties managed by the applicant |  |  | approved |
| `propertiesTotal` | integer |  | Properties on the network |  |  | approved |
| `proposedWorks` | richtext |  | Proposed works |  |  | approved |
| `quotesStatus` | select |  | Supplier quotations |  |  | approved |
| `requestValue` | number | GBP | Grant requested |  |  | approved |
| `signatoryDate` | text |  | Date |  |  | approved |
| `signatoryName` | text |  | Signatory |  |  | approved |
| `signatoryRole` | text |  | Signatory role |  |  | approved |
| `subsidyControlConfirm` | boolean |  | Subsidy control position confirmed |  |  | approved |
| `targetRound` | text |  | Target funding round |  |  | approved |

## hnes_asmt

| Varkey | Type | Units | Title | Meaning | Aliases | Status |
|---|---|---|---|---|---|---|
| `m4_1_10_cc` | passfail |  | M4.1.10 Resilience strategy |  |  | approved |
| `m4_1_10_cd` | passfail |  | M4.1.10 Condition audit/survey |  |  | approved |
| `m4_1_10_dd` | passfail |  | M4.1.10 Condition audit/survey |  |  | approved |
| `m4_1_10_ec` | passfail |  | M4.1.10 Condition audit/survey |  |  | approved |
| `m4_1_10_ss` | passfail |  | M4.1.10 Condition audit/survey |  |  | approved |
| `m4_1_11_cc` | passfail |  | M4.1.11 Circulation after stagnation |  |  | approved |
| `m4_1_11_cd` | passfail |  | M4.1.11 Destructive testing of pipework |  |  | approved |
| `m4_1_11_dd` | passfail |  | M4.1.11 Destructive testing of pipework |  |  | approved |
| `m4_1_11_ec` | passfail |  | M4.1.11 Destructive testing of pipework |  |  | approved |
| `m4_1_11_ss` | passfail |  | M4.1.11 Destructive testing of pipework |  |  | approved |
| `m4_1_12_cc` | passfail |  | M4.1.12 Equipment disconnection |  |  | approved |
| `m4_1_12_cd` | passfail |  | M4.1.12 Resilience strategy |  |  | approved |
| `m4_1_12_dd` | passfail |  | M4.1.12 Resilience strategy |  |  | approved |
| `m4_1_12_ec` | passfail |  | M4.1.12 Resilience strategy |  |  | approved |
| `m4_1_12_ss` | passfail |  | M4.1.12 Resilience strategy |  |  | approved |
| `m4_1_13_cc` | passfail |  | M4.1.13 Working pressure assessment |  |  | approved |
| `m4_1_13_cd` | passfail |  | M4.1.13 Water quality PPM |  |  | approved |
| `m4_1_13_dd` | passfail |  | M4.1.13 Water quality PPM |  |  | approved |
| `m4_1_13_ec` | passfail |  | M4.1.13 Water quality PPM |  |  | approved |
| `m4_1_13_ss` | passfail |  | M4.1.13 Water quality PPM |  |  | approved |
| `m4_1_14_cc` | passfail |  | M4.1.14 Statement of conformity |  |  | approved |
| `m4_1_14_cd` | passfail |  | M4.1.14 Water quality KPIs |  |  | approved |
| `m4_1_14_dd` | passfail |  | M4.1.14 Water quality KPIs |  |  | approved |
| `m4_1_14_ec` | passfail |  | M4.1.14 Water quality KPIs |  |  | approved |
| `m4_1_14_ss` | passfail |  | M4.1.14 Water quality KPIs |  |  | approved |
| `m4_1_15_cc` | passfail |  | M4.1.15 KPI schedule |  |  | approved |
| `m4_1_15_cd` | passfail |  | M4.1.15 Water quality records |  |  | approved |
| `m4_1_15_dd` | passfail |  | M4.1.15 Water quality records |  |  | approved |
| `m4_1_15_ec` | passfail |  | M4.1.15 Top-up water quality |  |  | approved |
| `m4_1_15_ss` | passfail |  | M4.1.15 Water quality records |  |  | approved |
| `m4_1_16_cc` | passfail |  | M4.1.16 Technical parameters schedule |  |  | approved |
| `m4_1_16_cd` | passfail |  | M4.1.16 Circulation after stagnation |  |  | approved |
| `m4_1_16_dd` | passfail |  | M4.1.16 Circulation after stagnation |  |  | approved |
| `m4_1_16_ec` | passfail |  | M4.1.16 Water quality records |  |  | approved |
| `m4_1_16_ss` | passfail |  | M4.1.16 Circulation after stagnation |  |  | approved |
| `m4_1_17_cd` | passfail |  | M4.1.17 Equipment disconnection |  |  | approved |
| `m4_1_17_dd` | passfail |  | M4.1.17 Equipment disconnection |  |  | approved |
| `m4_1_17_ec` | passfail |  | M4.1.17 Circulation after stagnation |  |  | approved |
| `m4_1_17_ss` | passfail |  | M4.1.17 Equipment disconnection |  |  | approved |
| `m4_1_18_cd` | passfail |  | M4.1.18 Annual inspection |  |  | approved |
| `m4_1_18_dd` | passfail |  | M4.1.18 Annual inspection |  |  | approved |
| `m4_1_18_ec` | passfail |  | M4.1.18 Equipment disconnection |  |  | approved |
| `m4_1_18_ss` | passfail |  | M4.1.18 Annual inspection |  |  | approved |
| `m4_1_19_cd` | passfail |  | M4.1.19 Water quality equipment |  |  | approved |
| `m4_1_19_dd` | passfail |  | M4.1.19 Water quality equipment |  |  | approved |
| `m4_1_19_ec` | passfail |  | M4.1.19 Annual inspection |  |  | approved |
| `m4_1_19_ss` | passfail |  | M4.1.19 Water quality equipment |  |  | approved |
| `m4_1_1_cc` | passfail |  | M4.1.1 O&M manual |  |  | approved |
| `m4_1_1_cd` | passfail |  | M4.1.1 O&M manual |  |  | approved |
| `m4_1_1_dd` | passfail |  | M4.1.1 O&M manual |  |  | approved |
| `m4_1_1_ec` | passfail |  | M4.1.1 O&M manual |  |  | approved |
| `m4_1_1_ss` | passfail |  | M4.1.1 O&M manual |  |  | approved |
| `m4_1_20_cd` | passfail |  | M4.1.20 Working pressure assessment |  |  | approved |
| `m4_1_20_dd` | passfail |  | M4.1.20 Working pressure assessment |  |  | approved |
| `m4_1_20_ec` | passfail |  | M4.1.20 Water quality equipment |  |  | approved |
| `m4_1_20_ss` | passfail |  | M4.1.20 Working pressure assessment |  |  | approved |
| `m4_1_21_cd` | passfail |  | M4.1.21 Statement of conformity |  |  | approved |
| `m4_1_21_dd` | passfail |  | M4.1.21 Statement of conformity |  |  | approved |
| `m4_1_21_ec` | passfail |  | M4.1.21 Working pressure assessment |  |  | approved |
| `m4_1_21_ss` | passfail |  | M4.1.21 Statement of conformity |  |  | approved |
| `m4_1_22_cd` | passfail |  | M4.1.22 KPI schedule |  |  | approved |
| `m4_1_22_dd` | passfail |  | M4.1.22 KPI schedule |  |  | approved |
| `m4_1_22_ec` | passfail |  | M4.1.22 Statement of conformity |  |  | approved |
| `m4_1_22_ss` | passfail |  | M4.1.22 KPI schedule |  |  | approved |
| `m4_1_23_cd` | passfail |  | M4.1.23 Technical parameters schedule |  |  | approved |
| `m4_1_23_dd` | passfail |  | M4.1.23 Technical parameters schedule |  |  | approved |
| `m4_1_23_ec` | passfail |  | M4.1.23 KPI schedule |  |  | approved |
| `m4_1_23_ss` | passfail |  | M4.1.23 Technical parameters schedule |  |  | approved |
| `m4_1_24_ec` | passfail |  | M4.1.24 Technical parameters schedule |  |  | approved |
| `m4_1_2_cc` | passfail |  | M4.1.2 PPM schedule |  |  | approved |
| `m4_1_2_cd` | passfail |  | M4.1.2 PPM schedule |  |  | approved |
| `m4_1_2_dd` | passfail |  | M4.1.2 PPM schedule |  |  | approved |
| `m4_1_2_ec` | passfail |  | M4.1.2 PPM schedule |  |  | approved |
| `m4_1_2_ss` | passfail |  | M4.1.2 PPM schedule |  |  | approved |
| `m4_1_3_cc` | passfail |  | M4.1.3 As-built drawings |  |  | approved |
| `m4_1_3_cd` | passfail |  | M4.1.3 As-built drawings |  |  | approved |
| `m4_1_3_dd` | passfail |  | M4.1.3 As-built drawings |  |  | approved |
| `m4_1_3_ec` | passfail |  | M4.1.3 As-built drawings |  |  | approved |
| `m4_1_3_ss` | passfail |  | M4.1.3 As-built drawings |  |  | approved |
| `m4_1_4_cc` | passfail |  | M4.1.4 Document storage |  |  | approved |
| `m4_1_4_cd` | passfail |  | M4.1.4 Document storage |  |  | approved |
| `m4_1_4_dd` | passfail |  | M4.1.4 Document storage |  |  | approved |
| `m4_1_4_ec` | passfail |  | M4.1.4 Document storage |  |  | approved |
| `m4_1_4_ss` | passfail |  | M4.1.4 Document storage |  |  | approved |
| `m4_1_5_cc` | passfail |  | M4.1.5 Maintenance & remedial log |  |  | approved |
| `m4_1_5_cd` | passfail |  | M4.1.5 Maintenance & remedial log |  |  | approved |
| `m4_1_5_dd` | passfail |  | M4.1.5 Maintenance & remedial log |  |  | approved |
| `m4_1_5_ec` | passfail |  | M4.1.5 Maintenance & remedial log |  |  | approved |
| `m4_1_5_ss` | passfail |  | M4.1.5 Maintenance & remedial log |  |  | approved |
| `m4_1_6_cc` | passfail |  | M4.1.6 Insulation condition evidence |  |  | approved |
| `m4_1_6_cd` | passfail |  | M4.1.6 Insulation condition evidence |  |  | approved |
| `m4_1_6_dd` | passfail |  | M4.1.6 Insulation condition evidence |  |  | approved |
| `m4_1_6_ec` | passfail |  | M4.1.6 Insulation condition evidence |  |  | approved |
| `m4_1_6_ss` | passfail |  | M4.1.6 Insulation condition evidence |  |  | approved |
| `m4_1_7_cc` | passfail |  | M4.1.7 Operative training |  |  | approved |
| `m4_1_7_cd` | passfail |  | M4.1.7 Operative training |  |  | approved |
| `m4_1_7_dd` | passfail |  | M4.1.7 Operative training |  |  | approved |
| `m4_1_7_ec` | passfail |  | M4.1.7 Operative training |  |  | approved |
| `m4_1_7_ss` | passfail |  | M4.1.7 Operative training |  |  | approved |
| `m4_1_8_cc` | passfail |  | M4.1.8 Site inductions |  |  | approved |
| `m4_1_8_cd` | passfail |  | M4.1.8 Site inductions |  |  | approved |
| `m4_1_8_dd` | passfail |  | M4.1.8 Site inductions |  |  | approved |
| `m4_1_8_ec` | passfail |  | M4.1.8 Site inductions |  |  | approved |
| `m4_1_8_ss` | passfail |  | M4.1.8 Site inductions |  |  | approved |
| `m4_1_9_cc` | passfail |  | M4.1.9 Operating risk register |  |  | approved |
| `m4_1_9_cd` | passfail |  | M4.1.9 Operating risk register |  |  | approved |
| `m4_1_9_dd` | passfail |  | M4.1.9 Operating risk register |  |  | approved |
| `m4_1_9_ec` | passfail |  | M4.1.9 Operating risk register |  |  | approved |
| `m4_1_9_ss` | passfail |  | M4.1.9 Operating risk register |  |  | approved |
| `m4_2_1_cc` | passfail |  | M4.2.1 Metering & monitoring strategy |  |  | approved |
| `m4_2_1_cd` | passfail |  | M4.2.1 Metering & monitoring strategy |  |  | approved |
| `m4_2_1_dd` | passfail |  | M4.2.1 Metering & monitoring strategy |  |  | approved |
| `m4_2_1_ec` | passfail |  | M4.2.1 Metering & monitoring strategy |  |  | approved |
| `m4_2_1_ss` | passfail |  | M4.2.1 Metering & monitoring strategy |  |  | approved |
| `m4_2_2_cc` | passfail |  | M4.2.2 Meter servicing strategy |  |  | approved |
| `m4_2_2_cd` | passfail |  | M4.2.2 ARMS specification |  |  | approved |
| `m4_2_2_dd` | passfail |  | M4.2.2 ARMS specification |  |  | approved |
| `m4_2_2_ec` | passfail |  | M4.2.2 ARMS specification |  |  | approved |
| `m4_2_2_ss` | passfail |  | M4.2.2 ARMS specification |  |  | approved |
| `m4_2_3_cc` | passfail |  | M4.2.3 ARMS specification |  |  | approved |
| `m4_2_3_cd` | passfail |  | M4.2.3 Monitoring point specification |  |  | approved |
| `m4_2_3_dd` | passfail |  | M4.2.3 Monitoring point specification |  |  | approved |
| `m4_2_3_ec` | passfail |  | M4.2.3 Monitoring point specification |  |  | approved |
| `m4_2_3_ss` | passfail |  | M4.2.3 Monitoring point specification |  |  | approved |
| `m4_2_4_cc` | passfail |  | M4.2.4 Monitoring point specification |  |  | approved |
| `m4_2_4_cd` | passfail |  | M4.2.4 Thermal energy meter records |  |  | approved |
| `m4_2_4_dd` | passfail |  | M4.2.4 Thermal energy meter records |  |  | approved |
| `m4_2_4_ec` | passfail |  | M4.2.4 Thermal energy meter records |  |  | approved |
| `m4_2_4_ss` | passfail |  | M4.2.4 Thermal energy meter records |  |  | approved |
| `m4_2_5_cc` | passfail |  | M4.2.5 Thermal energy meter records |  |  | approved |
| `m4_2_5_cd` | passfail |  | M4.2.5 KPI reporting frequency |  |  | approved |
| `m4_2_5_dd` | passfail |  | M4.2.5 KPI reporting frequency |  |  | approved |
| `m4_2_5_ec` | passfail |  | M4.2.5 KPI reporting frequency |  |  | approved |
| `m4_2_5_ss` | passfail |  | M4.2.5 KPI reporting frequency |  |  | approved |
| `m4_2_6_cc` | passfail |  | M4.2.6 KPI reporting frequency |  |  | approved |
| `m4_2_6_cd` | passfail |  | M4.2.6 KPI data & thresholds |  |  | approved |
| `m4_2_6_dd` | passfail |  | M4.2.6 KPI data & thresholds |  |  | approved |
| `m4_2_6_ec` | passfail |  | M4.2.6 KPI data & thresholds |  |  | approved |
| `m4_2_6_ss` | passfail |  | M4.2.6 KPI data & thresholds |  |  | approved |
| `m4_2_7_cc` | passfail |  | M4.2.7 KPI data & thresholds |  |  | approved |

## hnes_rev_study

| Varkey | Type | Units | Title | Meaning | Aliases | Status |
|---|---|---|---|---|---|---|
| `adjustments` | textarea |  | Adjustments |  |  | approved |
| `alternativesDecision` | richtext |  | Alternatives decision |  |  | approved |
| `analysisYears` | integer | years | Analysis period |  |  | approved |
| `baselineConfidence` | select |  | Baseline confidence |  |  | approved |
| `bulkMetering` | select |  | Bulk heat metering at energy centre |  |  | approved |
| `calcAnnualCarbon` | number |  | calcAnnualCarbon |  |  | approved |
| `calcAnnualElec` | number |  | calcAnnualElec |  |  | approved |
| `calcAnnualGas` | number |  | calcAnnualGas |  |  | approved |
| `calcCarbonContent` | number |  | calcCarbonContent |  |  | approved |
| `calcDistributionEfficiency` | number |  | calcDistributionEfficiency |  |  | approved |
| `calcEb` | number |  | calcEb |  |  | approved |
| `calcHeatCost` | number |  | calcHeatCost |  |  | approved |
| `calcHeatDelivered` | number |  | calcHeatDelivered |  |  | approved |
| `calcHeatGenerated` | number |  | calcHeatGenerated |  |  | approved |
| `calcHeatLeavingEc` | number |  | calcHeatLeavingEc |  |  | approved |
| `calcHlm` | number |  | calcHlm |  |  | approved |
| `calcLossesPrimary` | number |  | calcLossesPrimary |  |  | approved |
| `calcLossesSecondary` | number |  | calcLossesSecondary |  |  | approved |
| `calcLossesTotal` | number |  | calcLossesTotal |  |  | approved |
| `calcLossPerDwelling` | number |  | calcLossPerDwelling |  |  | approved |
| `calcNetworkEfficiency` | number |  | calcNetworkEfficiency |  |  | approved |
| `carbonPrice` | number | GBP/tCO2e | Carbon value |  |  | approved |
| `causesSummary` | textarea |  | Causes of sub-optimal performance |  |  | approved |
| `clientName` | text |  | Applicant organisation |  |  | approved |
| `costBasisNotes` | textarea |  | Costing basis |  |  | approved |
| `dataGaps` | textarea |  | Data gaps and estimates |  |  | approved |
| `dataSources` | sheet |  | Data sources register |  |  | approved |
| `decarbPathway` | richtext |  | Decarbonisation pathway |  |  | approved |
| `discountRate` | number | % | Discount rate |  |  | approved |
| `disseminationPlan` | richtext |  | Dissemination |  |  | approved |
| `elecPrice` | number | p/kWh | Electricity unit price | Electricity unit price | costElec | approved |
| `elecPriceForecast` | number | p/kWh | Electricity price (analysis) |  |  | approved |
| `energyBalance` | sheet |  | Annual energy balance |  |  | approved |
| `forecastSpend` | number | GBP | Forecast to completion |  |  | approved |
| `gasPrice` | number | p/kWh | Gas unit price | Gas unit price | costGas | approved |
| `gasPriceForecast` | number | p/kWh | Gas price (analysis) |  |  | approved |
| `grantAmount` | number | GBP | HNES grant award |  |  | approved |
| `heatLossModel` | sheet |  | Heat loss model segments |  |  | approved |
| `kpiAnnualCarbon` | number | kgCO2e/yr | Annual network carbon emissions |  |  | approved |
| `kpiAnnualElec` | number | kWh/yr | Annual fuel use: electricity |  |  | approved |
| `kpiAnnualGas` | number | kWh/yr | Annual fuel use: gas |  |  | approved |
| `kpiCarbonContent` | number | kgCO2e/kWh | Carbon content of delivered heat |  |  | approved |
| `kpiDistributionEfficiency` | number | % | Distribution efficiency (heat delivered / heat leaving EC) |  |  | approved |
| `kpiFlowTemp` | number | °C | Network flow temperature |  |  | approved |
| `kpiHeatCost` | number | p/kWh | Cost of heat delivered to customer interfaces |  |  | approved |
| `kpiInterruptions` | number | count | Service interruptions over 24h in last 12 months |  |  | approved |
| `kpiLossesPrimary` | number | kWh/yr | Distribution losses: primary |  |  | approved |
| `kpiLossesSecondary` | number | kWh/yr | Distribution losses: secondary |  |  | approved |
| `kpiLossPerDwelling` | number | W/dwelling | Network heat loss per dwelling |  |  | approved |
| `kpiNetworkEfficiency` | number | % | Overall network efficiency (heat delivered / fuel in) |  |  | approved |
| `kpiReturnTemp` | number | °C | Network return temperature |  |  | approved |
| `matchFunding` | number | GBP | Match funding |  |  | approved |
| `meanFlowTemp` | number | °C | Mean network flow temperature |  |  | approved |
| `meanReturnTemp` | number | °C | Mean network return temperature |  |  | approved |
| `measuresLonglist` | sheet |  | Optimisation measures long-list |  |  | approved |
| `meterCoverage` | integer |  | Consumer meters read |  |  | approved |
| `meterCoverageOf` | integer |  | Total dwellings (meter coverage denominator) |  |  | approved |
| `monthlyProfile` | sheet |  | Monthly energy profile |  |  | approved |
| `monthlyReconciliation` | sheet |  | Monthly reconciliation |  |  | approved |
| `networkDescription` | textarea |  | Network description |  |  | approved |
| `performanceGap` | richtext |  | Performance gap analysis |  |  | approved |
| `progressNarrative` | textarea |  | Delivery progress |  |  | approved |
| `projectRef` | text |  | Existing HNES reference |  |  | approved |
| `propertiesManaged` | integer |  | Properties managed by the applicant |  |  | approved |
| `propertiesTotal` | integer |  | Properties on the network |  |  | approved |
| `quoteDocs` | select |  | Contractor quotes received |  |  | approved |
| `returnMonth` | text |  | Reporting month |  |  | approved |
| `riskRegister` | sheet |  | Risk register |  |  | approved |
| `shortList` | richtext |  | Recommended short-list |  |  | approved |
| `siteVisitBy` | text |  | Site visit carried out by |  |  | approved |
| `siteVisitDate` | text |  | Site visit date(s) |  |  | approved |
| `siteVisitSummary` | richtext |  | Site visit summary |  |  | approved |
| `spendToDate` | number | GBP | Spend to date |  |  | approved |
| `studyEndDate` | text |  | Planned completion date |  |  | approved |
| `studyStartDate` | text |  | Study start date |  |  | approved |
| `suboptimalIndicators` | textarea |  | Indicators of sub-optimal performance |  |  | approved |
| `supplierName` | text |  | Study supplier |  |  | approved |

## hnes_rfi

| Varkey | Type | Units | Title | Meaning | Aliases | Status |
|---|---|---|---|---|---|---|
| `armsLetter` | textarea |  | ARMS permission letter (template) |  |  | approved |
| `armsLetterSent` | passfail |  | ARMS permission letter sent |  |  | approved |
| `rfiAppCalcs` | select |  | Application supporting calculations |  |  | approved |
| `rfiApplication` | select |  | HNES application & project narrative |  |  | approved |
| `rfiArmsProvider` | select |  | ARMS / metering & billing provider details |  |  | approved |
| `rfiAsBuilts` | select |  | As-built / O&M record drawings |  |  | approved |
| `rfiAwardLetter` | select |  | Award letter / grant funding agreement |  |  | approved |
| `rfiBaselineWorkbook` | select |  | Corrected baseline data workbook |  |  | approved |
| `rfiBilling` | select |  | Consumption data: billing & AMR exports |  |  | approved |
| `rfiBms` | select |  | BMS details & access |  |  | approved |
| `rfiCommissioning` | select |  | Commissioning records |  |  | approved |
| `rfiDesignIntent` | select |  | Original design intent & specifications |  |  | approved |
| `rfiDrawings` | select |  | Site drawings: schematics, layouts, floor plans |  |  | approved |
| `rfiFuelBills` | select |  | Fuel bills: gas & electricity input data |  |  | approved |
| `rfiGapSummary` | textarea |  | Gap analysis summary |  |  | approved |
| `rfiMaintLogs` | select |  | Maintenance & servicing records |  |  | approved |
| `rfiMeterReads` | select |  | Meter schedule: IDs, models & locations |  |  | approved |
| `rfiOmManuals` | select |  | O&M manuals |  |  | approved |
| `rfiOutages` | select |  | Outage & interruption records |  |  | approved |
| `rfiPpmSchedule` | select |  | PPM schedule |  |  | approved |
| `rfiPreviousStudies` | select |  | Previous studies & audits |  |  | approved |
| `rfiRiskRegister` | select |  | Risk register / resilience plans |  |  | approved |
| `rfiTariff` | select |  | Tariff information & heat charges |  |  | approved |
| `rfiTraining` | select |  | Personnel training & competency records |  |  | approved |
| `rfiWaterQuality` | select |  | Water quality & treatment records |  |  | approved |

## model_signoff

| Varkey | Type | Units | Title | Meaning | Aliases | Status |
|---|---|---|---|---|---|---|
| `assumptionsConfirmed` | passfail |  | Assumptions appropriate for this network |  |  | approved |
| `dwellingsLocated` | passfail |  | Every dwelling has a block and floor |  |  | approved |
| `ecPlaced` | passfail |  | Energy centre positioned |  |  | approved |
| `elementsComplete` | passfail |  | All network elements are defined |  |  | approved |
| `footprintsAssigned` | passfail |  | Building footprints assigned |  |  | approved |
| `layoutSaved` | passfail |  | 3D layout saved to site |  |  | approved |
| `modelComplete` | passfail |  | Model complete — sign-off |  |  | approved |
| `modelledBy` | text |  | Modelled by |  |  | approved |
| `modelNotes` | textarea |  | Model notes |  |  | approved |
| `occupancyPresent` | passfail |  | Beds or occupancy recorded per dwelling |  |  | approved |
| `photoDistrictPlan` | passfail |  | District pipework plan (numbered) |  |  | approved |
| `photoFloorplan` | passfail |  | Floorplan view |  |  | approved |
| `photoHeatLoss` | passfail |  | Pipework — heat loss |  |  | approved |
| `photoRenderPipes` | passfail |  | Pipework — velocity vs limits |  |  | approved |
| `photoRenderSolid` | passfail |  | 3D view — buildings |  |  | approved |
| `photoSchematic` | passfail |  | Riser / HIU schematic |  |  | approved |
| `photoSitePlan` | passfail |  | Site plan |  |  | approved |
| `resultsPublished` | passfail |  | Model results published |  |  | approved |

## onboarding

| Varkey | Type | Units | Title | Meaning | Aliases | Status |
|---|---|---|---|---|---|---|
| `companyAddress` | textarea |  | Registered Address |  |  | approved |
| `companyName` | text |  | Company Name |  |  | approved |
| `companyRegNo` | text |  | Company Registration No. |  |  | approved |
| `contactEmail` | email |  | Contact Email |  |  | approved |
| `contactName` | text |  | Primary Contact |  |  | approved |
| `contactPhone` | text |  | Contact Phone |  |  | approved |
| `engineerName` | text |  | Engineer Name |  |  | approved |
| `engineerPhone` | text |  | Engineer Phone |  |  | approved |
| `gasSafeIdNumber` | text |  | Gas Safe ID No. |  |  | approved |
| `gasSafeNumber` | text |  | Gas Safe Registration No. |  |  | approved |
| `insuranceCertificate` | text |  | Insurance Certificate |  |  | approved |
| `publicLiabilityExpiry` | text |  | Public Liability Expiry |  |  | approved |
| `publicLiabilityInsurer` | text |  | Public Liability Insurer |  |  | approved |
| `qualifications` | textarea |  | Qualifications |  |  | approved |
| `unventedG3` | boolean |  | Unvented (G3) Qualified |  |  | approved |
| `vatNo` | text |  | VAT Number |  |  | approved |

## sensor

| Varkey | Type | Units | Title | Meaning | Aliases | Status |
|---|---|---|---|---|---|---|
| `rhumidity` | number | %RH | Relative humidity | Relative humidity |  | approved |
| `temperature` | number | °C | Temperature | Air or space temperature at the element |  | approved |
| `tInlet` | number | °C | Inlet temperature | Inlet air temperature | temperatureInlet | approved |
| `voc` | number | ppb | VOC | Volatile organic compounds concentration |  | approved |

## set

| Varkey | Type | Units | Title | Meaning | Aliases | Status |
|---|---|---|---|---|---|---|
| `jobCode` | text |  | Job code | Operator job reference in force (QR scan); none clears |  | approved |

## setpoint

| Varkey | Type | Units | Title | Meaning | Aliases | Status |
|---|---|---|---|---|---|---|
| `tSet` | number | °C | Temperature setpoint | Temperature setpoint in force |  | approved |

## site

| Varkey | Type | Units | Title | Meaning | Aliases | Status |
|---|---|---|---|---|---|---|
| `issueN1` | textarea |  | Network Wide Issue 1 |  |  | approved |

## status

| Varkey | Type | Units | Title | Meaning | Aliases | Status |
|---|---|---|---|---|---|---|
| `bake` | boolean |  | Bake mode | Bake mode active |  | approved |
| `cool` | boolean |  | Cool-down | Cool-down active |  | approved |
| `emac` | boolean |  | Emergency stop | Emergency stop / forced off |  | approved |
| `flashoff` | boolean |  | Flash-off mode | Flash-off mode active |  | approved |
| `prep` | boolean |  | Prep mode | Prep mode active |  | approved |
| `run` | boolean |  | Running | Equipment running |  | approved |
| `spray` | boolean |  | Spray mode | Spray mode active |  | approved |

## survey

| Varkey | Type | Units | Title | Meaning | Aliases | Status |
|---|---|---|---|---|---|---|
| `accessSafeToWork` | passfail |  | Safe Access |  |  | approved |
| `airVentsRiser` | passfail |  | Air Vents at Riser Tops |  |  | approved |
| `ambientRiser` | number | °C | Riser / Corridor Ambient Temperature |  |  | approved |
| `bmsAccess` | passfail |  | BMS Access |  |  | approved |
| `boilerFuel` | select |  | Boiler fuel type |  |  | approved |
| `bufferCondition` | passfail |  | Condition |  |  | approved |
| `bufferConfig` | text |  | Hydraulic Configuration |  |  | approved |
| `bufferInsulation` | passfail |  | Insulation |  |  | approved |
| `bufferSensors` | passfail |  | Temperature Sensors |  |  | approved |
| `bufferVolume` | number | l | Volume |  |  | approved |
| `bypassEndLateral` | passfail |  | End-of-Lateral Bypasses |  |  | approved |
| `bypassRegister` | sheet |  | Bypass Register |  |  | approved |
| `bypassTopRiser` | passfail |  | Top-of-Riser Bypasses |  |  | approved |
| `calcEffCurve` | number |  | calcEffCurve |  |  | approved |
| `calLegionella` | passfail |  | Legionella Regime |  |  | approved |
| `calPresent` | textarea |  | Calorifiers / Cylinders |  |  | approved |
| `calTemps` | number | °C | Storage Temperature |  |  | approved |
| `ccBypassPresent` | passfail |  | Consumer Bypass |  |  | approved |
| `ccCupboardInsulation` | passfail |  | Cupboard Insulation (BS 5422) |  |  | approved |
| `ccDhwStabilised` | number | °C | Stabilised DHW Temperature |  |  | approved |
| `ccDhwTime45` | number | s | Time to 45 °C at Kitchen Tap |  |  | approved |
| `ccVentSystem` | select |  | Ventilation System |  |  | approved |
| `chpCondition` | passfail |  | Condition |  |  | approved |
| `chpElecEff` | number | % | CHP electrical efficiency |  |  | approved |
| `chpElecOutput` | number | kWe | Electrical Output |  |  | approved |
| `chpHoursRun` | number | h | Hours Run |  |  | approved |
| `chpMakeModel` | text |  | Make and Model |  |  | approved |
| `chpQI` | number |  | Quality Index |  |  | approved |
| `chpThermalOutput` | number | kW | Thermal Output |  |  | approved |
| `commValves` | passfail |  | Commissioning Valves & Settings |  |  | approved |
| `connectionCH` | select |  | Central heating connection |  |  | approved |
| `ctrlAlarms` | passfail |  | Alarms |  |  | approved |
| `ctrlARMS` | passfail |  | Remote Monitoring (ARMS) |  |  | approved |
| `ctrlBMS` | text |  | Control System |  |  | approved |
| `ctrlSetpointsDoc` | passfail |  | Setpoints Recorded |  |  | approved |
| `ctrlTimeClock` | passfail |  | Time Schedules |  |  | approved |
| `ctrlWeatherComp` | passfail |  | Weather Compensation |  |  | approved |
| `ddAccessChambers` | passfail |  | Access Chambers |  |  | approved |
| `ddBypasses` | passfail |  | Bypasses |  |  | approved |
| `ddInsulationRoute` | passfail |  | Route Insulation |  |  | approved |
| `ddLeakDetection` | passfail |  | Leak Detection |  |  | approved |
| `ddPipeSizes` | textarea |  | Pipe Sizes |  |  | approved |
| `ddRouteCondition` | passfail |  | Route Condition |  |  | approved |
| `dooAvailable` | passfail |  | Description of Operation |  |  | approved |
| `ecAmbientTemp` | number | °C | Plant Room Ambient Temperature |  |  | approved |
| `ecBoundaryMeter` | passfail |  | Boundary Heat Meter (EC3) |  |  | approved |
| `ecFloorDrainage` | passfail |  | Drainage |  |  | approved |
| `ecFuelInputMeters` | passfail |  | Fuel Input Metering (EC1) |  |  | approved |
| `ecHeatSources` | textarea |  | Heat Source Inventory |  |  | approved |
| `ecPumpElecMeter` | passfail |  | Pump Electricity Meter (EC4) |  |  | approved |
| `ecResilience` | passfail |  | Resilience |  |  | approved |
| `ecRoomCondition` | passfail |  | Plant Room Condition |  |  | approved |
| `ecTopUpMeter` | passfail |  | Top-up Water Meter |  |  | approved |
| `ecTopUpReading` | number | m3 | Top-up Meter Reading |  |  | approved |
| `ecVentilation` | passfail |  | Ventilation |  |  | approved |
| `efficiencyCurve` | sheet |  | Generation efficiency curve |  |  | approved |
| `elementAccess` | textarea |  | Access Arrangements |  |  | approved |
| `elementLocation` | textarea |  | Location |  |  | approved |
| `elementOverviewPhoto` | text |  | Element Overview Photo |  |  | approved |
| `elementRef` | text |  | Element Reference |  |  | approved |
| `equipIsolation` | passfail |  | Safe Isolation & Maintainability |  |  | approved |
| `equipRatings` | passfail |  | Ratings vs Operating Conditions |  |  | approved |
| `gbBadgePhoto` | text |  | Data Badge Photo |  |  | approved |
| `gbCondition` | passfail |  | Condition |  |  | approved |
| `gbControls` | text |  | Boiler Controls |  |  | approved |
| `gbFlowTemp` | number | °C | Operating Flow Temperature |  |  | approved |
| `gbFlueCondition` | passfail |  | Flue Condition |  |  | approved |
| `gbFlueType` | text |  | Flue Arrangement |  |  | approved |
| `gbGrossEfficiency` | number | % | Gross Efficiency |  |  | approved |
| `gbIsolation` | passfail |  | Isolation Valves |  |  | approved |
| `gbLeaks` | passfail |  | Leaks |  |  | approved |
| `gbMakeModel` | text |  | Make and Model |  |  | approved |
| `gbOutput` | number | kW | Rated Output |  |  | approved |
| `gbReturnTemp` | number | °C | Operating Return Temperature |  |  | approved |
| `gbServiceRecord` | passfail |  | Service Record |  |  | approved |
| `gbYear` | integer |  | Year of Manufacture |  |  | approved |
| `generalCondition` | passfail |  | General Condition |  |  | approved |
| `generatorType` | select |  | Boiler type |  |  | approved |
| `hHighPoint` | number | m | System height |  |  | approved |
| `hmCalibration` | passfail |  | Calibration |  |  | approved |
| `hmClass` | text |  | Accuracy Class |  |  | approved |
| `hmEnergyRead` | number | kWh | Energy Reading |  |  | approved |
| `hmErrorCodes` | passfail |  | Error Codes |  |  | approved |
| `hmFlowRate` | number | m³/h | Flow Rate |  |  | approved |
| `hmFlowTemp` | number | °C | Flow Temperature |  |  | approved |
| `hmLocation` | text |  | Meter Location |  |  | approved |
| `hmMakeModel` | text |  | Make and Model |  |  | approved |
| `hmRemoteReads` | passfail |  | Remote Reading |  |  | approved |
| `hmReturnTemp` | number | °C | Return Temperature |  |  | approved |
| `hmSerial` | text |  | Serial Number |  |  | approved |
| `hmVolumeRead` | number | m3 | Volume Reading |  |  | approved |
| `hpBadgePhoto` | text |  | Data Badge Photo |  |  | approved |
| `hpCondition` | passfail |  | Condition |  |  | approved |
| `hpCOP` | number |  | Stated COP |  |  | approved |
| `hpElecMeter` | passfail |  | Electricity Metering |  |  | approved |
| `hpMakeModel` | text |  | Make and Model |  |  | approved |
| `hpNoise` | passfail |  | Noise / Vibration |  |  | approved |
| `hpOutput` | number | kW | Rated Output |  |  | approved |
| `hpRefrigerant` | text |  | Refrigerant |  |  | approved |
| `hpServiceRecord` | passfail |  | Service Record |  |  | approved |
| `hpType` | text |  | Heat Pump Type |  |  | approved |
| `hydraulicSeparation` | select |  | Hydraulic Separation |  |  | approved |
| `insulationCondition` | passfail |  | Insulation Condition |  |  | approved |
| `insulationSpec` | textarea |  | Insulation Material & Thickness |  |  | approved |
| `isoValveLocations` | passfail |  | Isolation Valves |  |  | approved |
| `isToilet` | boolean |  | Bathroom fitted with toilet |  |  | approved |
| `labellingAdequate` | passfail |  | Labelling |  |  | approved |
| `leaksVisible` | passfail |  | Visible Leaks |  |  | approved |
| `loadSharePct` | number | % | Annual load share |  |  | approved |
| `maintenanceRecordsPhoto` | text |  | Maintenance Records Photo |  |  | approved |
| `mpCC1` | passfail |  | Consumer Connection Boundary — heat meter |  |  | approved |
| `mpCD1` | passfail |  | Intake Boundary — heat meter |  |  | approved |
| `mpCD3` | passfail |  | DP Measuring Point — pressure/DP sensor |  |  | approved |
| `mpDD1` | passfail |  | Intake Boundary — heat meter |  |  | approved |
| `mpDD3` | passfail |  | DP Measuring Point — pressure/DP sensor |  |  | approved |
| `mpEC1` | passfail |  | Heat Generator: Heat source energy input — gas meter |  |  | approved |
| `mpEC2` | passfail |  | Heat Generator: Heat Source energy output — heat meter |  |  | approved |
| `mpEC3` | passfail |  | EC Distribution: Energy Centre boundary — heat meter |  |  | approved |
| `mpEC4` | passfail |  | EC Distribution: Distribution pump set — electricity meter |  |  | approved |
| `mpEC5` | passfail |  | Pressurisation: Make-up Water meter — water meter |  |  | approved |
| `mpEC6` | passfail |  | EC Distribution: Index differential pressure measurement point — pressure/DP sensor |  |  | approved |
| `mpEC7` | passfail |  | EC Distribution: Distribution differential pressure measurement point — pressure/DP sensor |  |  | approved |
| `mpEC8` | passfail |  | Pressurisation: Operating pressure measurement point — pressure/DP sensor |  |  | approved |
| `mpSS1` | passfail |  | Intake Boundary — heat meter |  |  | approved |
| `mpSS2` | passfail |  | Offtake Boundary — heat meter |  |  | approved |
| `mpSS3` | passfail |  | Network distribution pump — electricity meter |  |  | approved |
| `mpSS4` | passfail |  | Water meter — water meter |  |  | approved |
| `mpSS5` | passfail |  | Defined index differential pressure measurement point — pressure/DP sensor |  |  | approved |
| `mpSS6` | passfail |  | Defined differential pressure exceedance measurement point — pressure/DP sensor |  |  | approved |
| `mpSS7` | passfail |  | Defined operating pressure measurement point — pressure/DP sensor |  |  | approved |
| `mvhrFilters` | passfail |  | MVHR Filters |  |  | approved |
| `mvhrVentsFitted` | passfail |  | MVHR Ceiling Vents Fitted |  |  | approved |
| `mvhrWorking` | passfail |  | MVHR Working |  |  | approved |
| `nBuildings` | integer | buildings | Number of buildings |  |  | approved |
| `nIntakes` | integer | intakes | Number of intake plantrooms |  |  | approved |
| `nProperties` | integer | properties | Number of properties |  |  | approved |
| `omDocsAvailable` | passfail |  | O&M Documentation |  |  | approved |
| `phxApproach` | number | K | Approach Temperature |  |  | approved |
| `phxCondition` | passfail |  | Condition |  |  | approved |
| `phxControlValves` | passfail |  | Control Valves |  |  | approved |
| `phxDuty` | number | kW | Rated Duty |  |  | approved |
| `phxFlowArrangement` | select |  | Flow Arrangement |  |  | approved |
| `phxInsulated` | passfail |  | Insulation |  |  | approved |
| `phxMakeModel` | text |  | Make and Model |  |  | approved |
| `phxPrimaryFlow` | number | °C | Primary Flow Temp |  |  | approved |
| `phxPrimaryReturn` | number | °C | Primary Return Temp |  |  | approved |
| `phxSecondaryFlow` | number | °C | Secondary Flow Temp |  |  | approved |
| `phxSecondaryReturn` | number | °C | Secondary Return Temp |  |  | approved |
| `pipeSupports` | passfail |  | Pipe Supports |  |  | approved |
| `ppmInPlace` | passfail |  | Planned Maintenance |  |  | approved |
| `pressAlarms` | passfail |  | Alarms |  |  | approved |
| `pressColdFill` | number | bar | Cold Fill Pressure |  |  | approved |
| `pressCondition` | passfail |  | Condition |  |  | approved |
| `pressMakeModel` | text |  | Make and Model |  |  | approved |
| `pressOperating` | number | bar | Operating Pressure |  |  | approved |
| `pressVesselPrecharge` | number | bar | Vessel Pre-charge |  |  | approved |
| `pressVesselSize` | number | l | Expansion Vessel Size |  |  | approved |
| `pumpCondition` | passfail |  | Condition |  |  | approved |
| `pumpControlMode` | text |  | Control Mode |  |  | approved |
| `pumpDp` | number | kPa | Differential Pressure |  |  | approved |
| `pumpDpTestPoints` | passfail |  | DP Test Points |  |  | approved |
| `pumpDuty` | text |  | Duty Arrangement |  |  | approved |
| `pumpExercised` | passfail |  | Standby Rotation |  |  | approved |
| `pumpGlands` | passfail |  | Glands and Seals |  |  | approved |
| `pumpMakeModel` | text |  | Make and Model |  |  | approved |
| `pumpVSD` | passfail |  | Variable Speed |  |  | approved |
| `safEICR` | passfail |  | Electrical Certificate |  |  | approved |
| `safElectricalCondition` | passfail |  | Electrical Installation |  |  | approved |
| `safEmergencyStop` | passfail |  | Emergency Stops |  |  | approved |
| `safGasCert` | passfail |  | Gas Safety Certificate |  |  | approved |
| `safGasDetection` | passfail |  | Gas Detection |  |  | approved |
| `safSafetyValves` | passfail |  | Safety Valves |  |  | approved |
| `safSignage` | passfail |  | Safety Signage |  |  | approved |
| `schematicAvailable` | passfail |  | Schematic Available |  |  | approved |
| `ssAmbientTemp` | number | °C | Substation Ambient Temperature |  |  | approved |
| `ssDpPoints` | passfail |  | DP Measurement Points (SS5/SS6) |  |  | approved |
| `ssDpReading` | number | kPa | DP Reading |  |  | approved |
| `ssIntakeMeter` | passfail |  | Intake Heat Meter (SS1) |  |  | approved |
| `ssOfftakeMeter` | passfail |  | Offtake Heat Meter (SS2) |  |  | approved |
| `ssOperatingPressure` | number | bar | Operating Pressure (SS7) |  |  | approved |
| `ssPumpMeter` | passfail |  | Pump Energy Meter (SS3) |  |  | approved |
| `ssTopUpMeter` | passfail |  | Top-up Water Meter (SS4) |  |  | approved |
| `substationType` | select |  | Substation Type |  |  | approved |
| `supplyCWS` | select |  | CWS Supply |  |  | approved |
| `surveyNotes` | textarea |  | General Notes |  |  | approved |
| `surveyRecommendations` | textarea |  | Improvement Opportunities |  |  | approved |
| `tFlowObserved` | number | °C | Observed Flow Temperature |  |  | approved |
| `thermalImage` | text |  | Thermal Image |  |  | approved |
| `tPeak` | number | °C | Peak network flow temperature |  |  | approved |
| `tPriRtnCH` | number | °C | Central heating network return temperature |  |  | approved |
| `tPriRtnDHW` | number | °C | DHW network return temperature |  |  | approved |
| `tReturnObserved` | number | °C | Observed Return Temperature |  |  | approved |
| `tXPeak` | number | °C | External temperature at peak load |  |  | approved |
| `typeEmitter` | select |  | Central heating emitter |  |  | approved |
| `typeRTL` | select |  | Radiator return control |  |  | approved |
| `typeTRV` | select |  | Radiator flow control |  |  | approved |
| `vBuffer` | number | l | Buffer volume |  |  | approved |
| `wqInhibitor` | passfail |  | Inhibitor Dosing |  |  | approved |
| `wqLastReport` | text |  | Last Analysis Report |  |  | approved |
| `wqSampleTaken` | passfail |  | Sample Taken |  |  | approved |
| `wqSideStream` | passfail |  | Side-stream Filtration |  |  | approved |

## system

| Varkey | Type | Units | Title | Meaning | Aliases | Status |
|---|---|---|---|---|---|---|
| `imageUrl` | text |  | Image URL | Image for tiles and headers |  | approved |
| `name` | text |  | Name | Display name of the element or site (on global/network: the site name) |  | approved |
| `qrCode` | text |  | QR / Label Code |  |  | approved |

## wp_replace_pressure_gauge

| Varkey | Type | Units | Title | Meaning | Aliases | Status |
|---|---|---|---|---|---|---|
| `checkFLoop1` | passfail |  | Check Filling Loop |  |  | approved |
| `heatingLeakFree` | boolean |  | Central Heating Free from Leaks |  |  | approved |
| `newGaugeFitted` | passfail |  | Remove damaged gauge and fit new pressure gauge matching connection and range |  |  | approved |
| `pHTGFill` | number | bar | Fill Central Heating Pressure |  |  | approved |
| `pHTGFinal` | number | bar | Final Central Heating Pressure |  |  | approved |
| `powerOff` | passfail |  | Turn off power to the system |  |  | approved |
| `pumpFree` | passfail |  | Pump Free and Bled |  |  | approved |

