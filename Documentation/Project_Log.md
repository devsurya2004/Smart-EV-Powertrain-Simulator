# Day 1 (29/07/2026)

## Objectives
- Set up the development environment.
- Create the project architecture.
- Begin vehicle performance calculations.

## Completed

### Project Setup
- Installed MATLAB R2026a Update 4.
- Created MATLAB Project.
- Initialized Git repository.
- Created project folder structure.
- Added README.md.
- Added .gitignore.

### Documentation
- Created:
  - Design_Decisions.md
  - Battery.md
  - Motor.md
  - Vehicle.md
  - Controller.md
  - Project_Log.md

### Vehicle Configuration
- Selected project vehicle:
  - SEV-01
  - Compact Electric SUV
- Vehicle mass: 1650 kg
- Top speed: 150 km/h
- Battery voltage: 400 V
- Battery capacity: 45 kWh
- Motor type: PMSM
- Drivetrain: Front-Wheel Drive

### MATLAB Development
- Created Project_Parameters.m.
- Designed EV structure for project parameters.
- Created Vehicle_Calculations.m.

### Engineering Calculations
Calculated:
- Rolling resistance force
- Aerodynamic drag force
- Total resistance force
- Required cruising motor power
- Acceleration (0–100 km/h in 9.5 s)
- Acceleration force
- Total tractive force
- Peak mechanical power

### Results
- Rolling Resistance Force: 161.87 N
- Aerodynamic Drag Force: 765.62 N
- Total Resistance Force: 927.49 N
- Required Cruising Power: 38.65 kW
- Acceleration: 2.92 m/s²
- Acceleration Force: 4824.56 N
- Total Tractive Force: 5752.05 N
- Peak Mechanical Power: 159.78 kW

### Git
- First commit created.
- Commit message:
  "Initial project setup and vehicle dynamics calculations"

## Lessons Learned
- Use a parameter-driven project structure.
- Store calculated values inside EV.Calculated.
- Verify engineering calculations manually before trusting MATLAB outputs.
- Organize code into logical sections for maintainability.

## Next Milestone
- Determine motor rated power.
- Calculate gear ratio.
- Select PMSM specifications.
- Begin motor sizing calculations.


# Day 2 – Motor Calculations and Project Architecture Improvements

Date: 30 July 2026

---

## Overview

Today's work focused on developing the motor calculation module for the Smart-EV-Powertrain-Simulator. The drivetrain parameters required for the electric vehicle were calculated based on the results obtained from the vehicle dynamics analysis. In addition to the engineering calculations, the project architecture was improved to make the code modular, scalable, and easier to maintain.

---

## Project Architecture Improvements

Initially, every calculation script directly loaded `Project_Parameters.m`. However, the motor calculations required values that were already computed in the vehicle calculations module, such as total tractive force and peak power.

To improve modularity, the project workflow was redesigned as follows:

Project_Parameters.m
↓
Vehicle_Calculations.m
↓
Vehicle_Calculations.mat
↓
Motor_Calculations.m

With this approach, every module receives validated outputs from the previous module instead of recalculating the same values. This architecture will simplify future integration of the battery, inverter, controller, and complete Simulink model.

---

## MATLAB Code Improvements

A major issue was identified where variables such as `projectRoot` and `scriptFolder` were being deleted during execution.

The issue was traced to the presence of:

```matlab
clearvars
clc

---

## Battery Module Development

### Date
20 July 2026

### Overview
Completed the Battery Pack Design module for the Smart EV Powertrain Simulator. The module calculates the battery pack configuration, validates the design against project specifications, generates a professional console report, and saves the results for use by future modules.

---

### Commit 1 – Battery Pack Sizing

#### Features Implemented
- Added battery pack configuration calculations.
- Calculated required series cell count.
- Calculated required parallel cell count.
- Calculated total number of cells.
- Calculated nominal pack voltage.
- Calculated maximum pack voltage.
- Calculated minimum pack voltage.
- Calculated battery pack capacity.
- Calculated battery pack energy.

#### Architecture Improvements
- Introduced hierarchical calculated structure.

```
EV.Battery.Calculated
```

with the following organization:

```
Cells
Voltage
Capacity
Energy
Current
Mass
```

- Stored only final calculated values inside the project structure.
- Kept intermediate calculations as local variables to reduce unnecessary memory usage.
- Improved consistency with previous project modules.

---

### Commit 2 – Battery Performance and Validation

#### Features Implemented
- Added continuous battery current calculation.
- Added peak battery current calculation.
- Added total battery pack mass calculation.

#### Validation
- Calculated voltage error percentage.
- Calculated energy error percentage.
- Implemented automatic PASS/FAIL validation based on design limits.

Validation Criteria

- Voltage Error ≤ 2%
- Energy Error ≤ 5%

#### Console Report

Created a professional engineering report including:

- Battery Information
- Cell Configuration
- Voltage
- Capacity & Energy
- Current Capability
- Battery Mass
- Validation Summary

Standardized formatting using section headers for improved readability.

---

### Commit 3 – Module Finalization

#### Features Implemented
- Added automatic saving of battery calculations.

Output File

```
Data/Battery_Calculations.mat
```

- Added save confirmation message.
- Displayed saved file location after successful execution.

Example Output

```
Battery calculations saved successfully.
Location :
Data/Battery_Calculations.mat
```

---

### Final Battery Pack Results

| Parameter | Value |
|-----------|------:|
| Chemistry | Lithium Iron Phosphate (LFP) |
| Cell Form Factor | 32700 Cylindrical |
| Series Cells | 125 |
| Parallel Cells | 19 |
| Total Cells | 2375 |
| Nominal Voltage | 400.00 V |
| Maximum Voltage | 456.25 V |
| Minimum Voltage | 312.50 V |
| Pack Capacity | 114.00 Ah |
| Pack Energy | 45.60 kWh |
| Continuous Current | 342.00 A |
| Peak Current | 570.00 A |
| Battery Mass | 344.38 kg |
| Voltage Error | 0.00 % |
| Energy Error | 1.33 % |
| Overall Status | PASS |

---

### Files Modified

```
Scripts/Project_Parameters.m
Scripts/Battery_Calculations.m
```

### Files Generated

```
Data/Battery_Calculations.mat
```

---

### Notes

- Adopted a consistent engineering report format for console output.
- Standardized calculated value storage using the `Calculated` hierarchy.
- Prepared the battery module for integration with future inverter, vehicle dynamics, and energy consumption modules.
- Battery module is considered complete and ready for use by downstream subsystems.

---

## Current Project Status

✅ Project Initialization

✅ Vehicle Calculations

✅ Motor Calculations

✅ Motor Characteristics

✅ Battery Pack Design

⬜ Transmission

⬜ Inverter

⬜ Drive Cycle

⬜ Vehicle Dynamics

⬜ Energy Consumption

⬜ Regenerative Braking

⬜ Performance Summary
---

# Transmission Module Development

### Date
31 July 2026

### Overview

Completed the Transmission Module for the Smart EV Powertrain Simulator. The module calculates the transmission output characteristics from the motor specifications, evaluates power flow through the transmission, validates the calculations, generates a professional engineering report, and saves the results for use by future modules.

---

## Commit 1 – Transmission Calculations

### Features Implemented

- Created `Transmission_Calculations.m`.
- Calculated transmission output speed using the gear ratio.
- Calculated transmission output torque considering transmission efficiency.
- Calculated transmission speed reduction ratio.
- Calculated transmission torque multiplication ratio.
- Calculated transmission input power.
- Calculated transmission output power.
- Calculated transmission power losses.

### Architecture Improvements

Introduced the following calculated structure:

```
EV.Transmission.Calculated
```

with the following organization:

```
Output
    SpeedRPM
    TorqueNm

Ratio
    SpeedReduction
    TorqueMultiplication

Power
    InputkW
    OutputkW
    LosseskW
```

### Design Decisions

- Stored only transmission-generated outputs inside `EV.Transmission.Calculated`.
- Avoided duplicating motor parameters already available in `EV.Motor`.
- Used local variables for intermediate calculations such as angular speed.
- Maintained consistency with the project coding standard.

---

## Commit 2 – Validation and Professional Reporting

### Features Implemented

- Added automatic transmission validation.
- Calculated transmission power error.
- Calculated transmission validation status (PASS / FAIL).

### Validation Criteria

- Power Error ≤ 0.1%

### Console Report

Developed a professional engineering report including:

- Transmission Information
- Output Performance
- Transmission Ratio
- Power Flow
- Validation Summary

Standardized the report format to match the Battery Module.

---

## Commit 3 – Module Finalization

### Features Implemented

- Added automatic saving of transmission calculation results.

Output File

```
Data/Transmission_Calculations.mat
```

- Added save confirmation message.
- Displayed saved file location after successful execution.

Example Output

```
Transmission calculations saved successfully.
Location :
Data/Transmission_Calculations.mat
```

---

## Final Transmission Results

| Parameter | Value |
|-----------|------:|
| Transmission Type | Single Speed |
| Gear Ratio | 10.25 |
| Efficiency | 97.00 % |
| Output Speed | 1170.73 RPM |
| Output Torque | 1954.89 Nm |
| Speed Reduction | 10.25 : 1 |
| Torque Multiplication | 9.9425 |
| Input Power | 247.08 kW |
| Output Power | 239.67 kW |
| Power Loss | 7.41 kW |
| Power Error | 0.0000 % |
| Overall Status | PASS |

---

## Files Modified

```
Scripts/Project_Parameters.m
Scripts/Transmission_Calculations.m
```

---

## Files Generated

```
Data/Transmission_Calculations.mat
```

---

## Notes

- Adopted the project-wide coding standard for script structure and formatting.
- Implemented a professional engineering report consistent with previous modules.
- Avoided redundant storage of motor input parameters by using the existing `EV.Motor` structure.
- Maintained modular architecture to support future integration with vehicle dynamics and drive cycle simulations.
- Transmission module is complete and ready for integration with downstream subsystems.

---

## Current Project Status

✅ Project Initialization

✅ Vehicle Calculations

✅ Motor Calculations

✅ Motor Characteristics

✅ Battery Pack Design

✅ Transmission Module

⬜ Inverter Module

⬜ Vehicle Dynamics

⬜ Drive Cycle Simulation

⬜ Energy Consumption

⬜ Regenerative Braking

⬜ Performance Summary
