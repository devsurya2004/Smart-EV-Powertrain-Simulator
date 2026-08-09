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

## Date
02 August 2026

---

# Smart EV Powertrain Simulator

## Objectives Completed

Today's work focused on completing the dynamic simulation module and improving the overall software architecture, coding standards, project organization, and visualization quality.

---

# 1. Inverter Module Completed

## Completed

- Loaded battery calculation results from Battery_Calculations.mat.
- Fixed dependency loading between modules.
- Implemented DC side calculations.
- Implemented AC side calculations.
- Calculated:
  - DC Voltage
  - DC Current
  - DC Power
  - AC Line Voltage
  - AC Phase Voltage
  - AC Phase Current
  - Input Power
  - Output Power
  - Power Loss
- Added inverter validation.
- Generated professional inverter report.
- Saved calculation results to:

Data/Inverter_Calculations.mat

---

# 2. Vehicle Dynamics Module Completed

## Implemented

Created Vehicle_Dynamics.m.

Added dependency loading from:

- Vehicle_Calculations.mat
- Transmission_Calculations.mat
- Inverter_Calculations.mat

Implemented calculations for:

- Wheel Tractive Force
- Rolling Resistance
- Aerodynamic Drag
- Net Tractive Force
- Vehicle Acceleration
- Wheel Power
- Power-to-Weight Ratio

Added validation logic.

Generated professional Vehicle Dynamics Report.

Saved results to:

Data/Vehicle_Dynamics.mat

---

# 3. Drive Cycle Module Completed

Created Drive_Cycle.m.

Implemented:

## Time Vector

- 120 second simulation
- 1 second sampling interval

## Custom Urban Drive Cycle

Vehicle operating phases:

- Acceleration
- Cruise
- Deceleration
- Braking
- Standstill

Generated:

- Vehicle Speed
- Vehicle Acceleration
- Distance Travelled

---

## Dynamic Calculations

Calculated:

- Required Tractive Force
- Wheel Power
- Motor Power
- Battery Power
- Energy Consumption

Saved results to:

Data/Drive_Cycle.mat

---

# 4. Drive Cycle Visualization

Generated professional engineering plots.

Created:

- Speed vs Time
- Acceleration vs Time
- Tractive Force vs Time
- Battery Power vs Time
- Energy Consumption vs Time

All figures are exported using:

exportgraphics(...)

Resolution:

300 DPI

Images are automatically stored inside:

Results/DriveCycle/

---

# 5. Project Architecture Improvements

Improved module dependency handling.

Each module now explicitly loads only the required calculated data instead of overwriting the complete EV structure.

Adopted a modular dependency chain:

Vehicle

↓

Battery

↓

Inverter

↓

Motor

↓

Transmission

↓

Vehicle Dynamics

↓

Drive Cycle

---

# 6. Coding Standard Improvements

Standardized every calculation script.

Every script now follows:

1. Startup
2. Load Required Data
3. Calculations
4. Validation
5. Display Results
6. Generate Figures
7. Save Figures
8. Close Figures
9. Save Results

---

# 7. Startup Standardization

Every calculation script now starts with:

clc

close all

clear

followed by:

Initialize_Project()

This guarantees a clean execution environment.

---

# 8. Plot Standardization

All plots now use:

- White background
- LineWidth = 2
- Grid enabled
- Box enabled
- Consistent axis font size
- Bold titles
- Figure handles
- exportgraphics()
- Automatic figure closing

This plotting standard will be used throughout the remainder of the project.

---

# 9. Results Folder Reorganization

Created module-based results structure.

Results/

- Battery
- Inverter
- Motor
- Transmission
- VehicleDynamics
- DriveCycle
- RegenerativeBraking
- PerformanceSummary
- Simulink

Moved existing Motor plots into:

Results/Motor/

Updated Motor_Characteristics.m to use the new folder structure.

---

# 10. Documentation Improvements

Created documentation structure for future modules.

Added placeholders for:

- Battery.md
- Inverter.md
- Motor.md
- Transmission.md
- Vehicle.md
- DriveCycle.md
- RegenerativeBraking.md
- PerformanceSummary.md
- Simulink.md
- Design_Decisions.md
- References.md

Updated Coding_Standard.md with:

- Script organization
- Dependency loading
- Plot standards
- Result saving conventions

---

# Project Status

Completed Modules

- Project Initialization
- Vehicle Parameters
- Vehicle Calculations
- Motor Calculations
- Motor Characteristics
- Battery Module
- Inverter Module
- Transmission Module
- Vehicle Dynamics
- Drive Cycle Simulation

Remaining Modules

- Regenerative Braking
- Performance Summary
- Simulink Integration
- Final Documentation
- README
- GitHub Repository Finalization

Estimated Project Completion

Approximately 80%

---

# Next Session Plan

Continue development with:

1. Regenerative Braking Module

Followed by:

2. Performance Summary Dashboard

3. Simulink Integration

4. Final Documentation

5. GitHub Release Preparation
# Project Log – Day 2

**Date:** 03 August 2026

## Overview

Today's work focused on completing the first functional version of the Smart EV Powertrain Simulator by integrating the MATLAB calculation scripts with the Simulink model. A complete closed-loop EV powertrain simulation was successfully achieved.

---

## MATLAB Development

### Completed Modules

- Battery
- Motor
- Transmission
- Inverter
- Vehicle
- Vehicle Dynamics
- Drive Cycle
- Regenerative Braking
- Performance Summary

### Project Initialization

- Created `Initialize_Project.m`.
- Automatically loads `Project_Parameters.m`.
- Creates required project folders (`Data`, `Models`, `Results`).
- Initializes the complete `EV` parameter structure.

### Project Organization

Renamed calculation scripts for a cleaner architecture:

- `Battery_Calculations.m` → `Battery.m`
- `Motor_Calculations.m` → `Motor.m`
- `Transmission_Calculations.m` → `Transmission.m`
- `Inverter_Calculations.m` → `Inverter.m`
- `Vehicle_Calculations.m` → `Vehicle.m`

Updated all dependent files using MATLAB's **Rename and Update** feature.

### Performance Summary

Successfully executed `Run_Project.m`.

The script now:

- Loads every subsystem automatically.
- Calculates complete vehicle parameters.
- Displays a formatted performance summary.
- Saves performance plots in the `Results` folder.

---

## Simulink Development

### Overall Architecture

Implemented the complete EV powertrain:

```text
Drive Cycle
      ↓
Driver Controller
      ↓
Battery
      ↓
Inverter
      ↓
PMSM Motor
      ↓
Transmission
      ↓
Vehicle Dynamics
      ↓
Vehicle Speed
```

---

## Drive Cycle

Created a custom drive cycle using the **Signal Editor**.

Vehicle profile:

- Accelerate from 0 km/h to 50 km/h
- Cruise at 50 km/h
- Decelerate to 20 km/h
- Stop at 0 km/h

Simulation duration: **120 seconds**

---

## Driver Controller

Implemented a closed-loop speed controller.

**Inputs**

- Desired Speed
- Actual Speed

**Output**

- Throttle

Controller:

- PID Controller
- Unit Delay feedback
- Closed-loop speed regulation

---

## Battery Model

Implemented the battery subsystem.

**Input**

- Throttle

**Output**

- Battery Power

Battery power is calculated using the peak motor power and throttle demand.

---

## Inverter Model

Implemented inverter efficiency.

**Input**

- Battery Power

**Output**

- Motor Power

The inverter output is calculated by multiplying battery power with inverter efficiency.

---

## PMSM Motor

Implemented the PMSM motor subsystem.

**Input**

- Motor Power

**Output**

- Motor Torque

Motor torque is calculated from motor power using the motor's base angular speed.

Torque output is limited using a Saturation block with the maximum motor torque.

---

## Transmission

Implemented a single-speed gearbox.

**Input**

- Motor Torque

**Output**

- Wheel Torque

Wheel torque is calculated using:

- Gear ratio
- Transmission efficiency

---

## Vehicle Dynamics

Implemented a simple longitudinal vehicle model.

The subsystem includes:

- Torque-to-force conversion
- Rolling resistance
- Aerodynamic drag
- Net force calculation
- Force-to-acceleration conversion
- Vehicle speed integration

Vehicle speed is fed back to the Driver Controller through a Unit Delay block, creating a complete closed-loop system.

---

## Debugging and Improvements

Resolved several issues during development:

- Workspace initialization errors
- Simulink callback issues
- Missing `EV` variables
- Script naming conflicts
- Empty calculated parameters
- Invalid Gain block expressions
- Rolling resistance initialization errors
- Aerodynamic drag initialization errors
- Parameter loading issues

---

## Simulation Results

The complete powertrain simulation now runs successfully without errors.

Observations:

- Desired speed profile is generated correctly.
- Closed-loop feedback is functioning.
- Vehicle accelerates and decelerates according to the drive cycle.
- Speed tracking is operational.

Current limitations:

- Driver controller requires PID tuning.
- Motor model uses a simplified power-to-torque conversion.
- Vehicle dynamics require a speed-dependent aerodynamic drag model.
- Regenerative braking is not yet integrated into the Simulink model.

---

## Current Project Status

| Module | Status |
|---------|--------|
| MATLAB Backend | ✅ Complete |
| Project Initialization | ✅ Complete |
| Drive Cycle | ✅ Complete |
| Driver Controller | ✅ Working |
| Battery | ✅ Working |
| Inverter | ✅ Working |
| PMSM Motor | ✅ Working |
| Transmission | ✅ Working |
| Vehicle Dynamics | ✅ Working |
| Closed-Loop Simulation | ✅ Successful |
| Performance Summary | ✅ Complete |

---

## Next Steps

- Tune the PID controller for improved speed tracking.
- Replace simple motor model with a more realistic PMSM model.
- Implement speed-dependent aerodynamic drag.
- Add regenerative braking to the Simulink model.
- Create dashboard gauges and visualization.
- Validate simulation results against MATLAB calculations.
# Project Log – Smart EV Powertrain Simulator

**Project:** Smart EV Powertrain Simulator  
**Version:** 1.0  
**Date:** 04-Aug-2026

---

# Objectives

- Improve the realism of the Smart EV Powertrain Simulator.
- Replace simplified vehicle dynamics with physics-based equations.
- Improve battery and motor response.
- Tune the driver controller for smoother speed tracking.

---

# Work Completed

## 1. Driver Controller

### Improvements
- Tuned the PID controller.
- Enabled output saturation.
- Enabled anti-windup using Back Calculation.
- Reduced oscillations in vehicle speed response.

### Final PID Parameters

| Parameter | Value |
|-----------|------:|
| Proportional Gain (P) | 0.015 |
| Integral Gain (I) | 0.0005 |
| Derivative Gain (D) | 0 |
| Filter Coefficient (N) | 100 |
| Output Limits | -1 to 1 |
| Anti-Windup | Back Calculation |
| Back Calculation Coefficient (Kb) | 1 |

---

## 2. Battery Subsystem

### Improvements
- Replaced fixed battery model with MATLAB Function.
- Added realistic battery power calculation.
- Added first-order battery dynamics.
- Implemented State of Charge (SOC) estimation.
- Included charging and discharging efficiencies.
- Verified SOC changes during acceleration and regenerative braking.

### Outputs
- Battery Power
- Battery SOC

---

## 3. PMSM Motor Subsystem

### Improvements
- Added first-order motor dynamics.

Transfer Function:

\[
G(s)=\frac{1}{0.5s+1}
\]

- Added motor torque saturation.
- Improved torque response during acceleration and braking.

---

## 4. Vehicle Dynamics Subsystem

The simplified vehicle model was replaced with a physics-based longitudinal dynamics model.

### Features Added

- Tractive force calculation
- Rolling resistance
- Aerodynamic drag
- Road grade force
- Vehicle acceleration calculation
- Vehicle speed integration
- Vehicle distance integration
- Vehicle speed saturation

---

## Vehicle Equations

### Tractive Force

\[
F_t=\frac{T_{wheel}}{R_{wheel}}
\]

---

### Rolling Resistance

\[
F_r=C_rmg
\]

---

### Aerodynamic Drag

\[
F_d=\frac{1}{2}\rho C_dAv^2
\]

---

### Road Grade Force

\[
F_g=mg\sin(\theta)
\]

(Currently tested with **θ = 0°**)

---

### Net Force

\[
F_{net}=F_t-F_r-F_d-F_g
\]

---

### Vehicle Acceleration

\[
a=\frac{F_{net}}{m}
\]

---

### Vehicle Speed

\[
v=\int a\,dt
\]

---

### Vehicle Distance

\[
x=\int v\,dt
\]

---

## 5. Simulink Model Improvements

### Added

- Vehicle acceleration output
- Vehicle distance output
- Speed saturation
- Feedback loop for drag calculation
- Feedback loop for rolling resistance
- Road grade model

### Corrected

- MATLAB Function parsing errors
- Workspace variable access issues
- Parameter initialization errors
- Signal routing

---

# Simulation Results

The updated model successfully demonstrates:

- Smooth drive cycle tracking
- Realistic acceleration
- Realistic deceleration
- Regenerative braking
- Continuous battery power calculation
- Battery SOC estimation
- Rolling resistance effects
- Aerodynamic drag effects
- Vehicle speed limitation

---

# Issues Encountered

### MATLAB Function Errors

Resolved:

- Undefined variable `EV.Vehicle`
- Undefined variable `EV.Environment`
- Undefined variable `EV.Road`
- MATLAB Function parser errors
- Incorrect workspace variable access

### Solution

- Replaced workspace references with local constants inside MATLAB Function blocks.
- Added missing project parameters.
- Corrected subsystem connections.

---

# Files Modified

- Project_Parameters.m
- Driver Controller
- Battery Subsystem
- PMSM Motor
- Vehicle Dynamics

---

# Current Model Outputs

The simulator currently provides:

- Vehicle Speed
- Vehicle Acceleration
- Vehicle Distance
- Motor Torque
- Wheel Torque
- Battery Power
- Battery State of Charge (SOC)

---

# Progress Summary

| Subsystem | Status |
|------------|--------|
| Drive Cycle | ✅ Complete |
| Driver Controller | ✅ Complete |
| Battery Model | ✅ Complete |
| PMSM Motor | ✅ Complete (Basic) |
| Vehicle Dynamics | ✅ Complete |
| Vehicle Speed | ✅ Complete |
| Vehicle Distance | ✅ Complete |
| Vehicle Acceleration | ✅ Complete |
| Regenerative Braking | ✅ Basic |
| Transmission | ⏳ Pending |
| Inverter Model | ⏳ Pending |
| Motor Speed Model | ⏳ Pending |
| Thermal Model | ⏳ Pending |
| BMS | ⏳ Pending |

---

# Overall Progress

**Estimated Completion:** **~70%**

The simulator now includes a complete closed-loop EV powertrain with:

- Driver controller
- Battery model
- PMSM motor
- Vehicle longitudinal dynamics
- Regenerative braking
- SOC estimation

The remaining work primarily involves drivetrain refinement and advanced subsystem modeling.

---

# Next Session Plan

## Priority 1
- Build the **Transmission Subsystem**
- Calculate Motor RPM from Vehicle Speed

## Priority 2
- Implement PMSM Torque-Speed Characteristics
  - Constant Torque Region
  - Constant Power Region
  - Maximum Motor Speed Limit

## Priority 3
- Add Inverter Efficiency Model

## Priority 4
- Improve Regenerative Braking Strategy

## Priority 5
- Replace hardcoded constants with `Simulink.Parameter` objects for cleaner parameter management.

---
# Project Log

---

## Day 8 – Vehicle Dynamics Enhancement and Mechanical Braking Integration

**Date:** 06 August 2026

### Objectives
- Improve vehicle deceleration performance.
- Reduce speed tracking error during braking.
- Implement a realistic mechanical braking system.
- Refine driver controller and regenerative braking.

### Work Completed

#### 1. Vehicle Dynamics Enhancement
- Reviewed the complete Vehicle Dynamics subsystem.
- Verified tractive force, rolling resistance, aerodynamic drag, and road grade calculations.
- Confirmed force balance and acceleration calculations.

#### 2. Mechanical Braking Implementation
- Added a new Brake input to the Vehicle Dynamics subsystem.
- Designed a Mechanical Brake MATLAB Function block.
- Implemented braking force generation based on brake command and vehicle speed.
- Connected mechanical braking force to the net force summation block.
- Tuned maximum braking force for stable deceleration.

#### 3. Driver Controller Improvements
- Refined throttle and brake control logic.
- Added deadband handling to reduce unnecessary switching.
- Improved regenerative braking transition.
- Prevented simultaneous throttle and brake commands.

#### 4. Controller Testing
- Performed multiple simulation runs.
- Compared Desired Speed and Actual Speed responses.
- Evaluated braking performance after integrating mechanical brakes.
- Verified smoother deceleration and improved stopping behavior.

### Results
- Successfully integrated mechanical braking.
- Improved vehicle stopping performance.
- Reduced coasting during braking.
- Eliminated major oscillations in vehicle speed.
- Achieved more realistic braking characteristics.

### Status
✅ Mechanical braking successfully integrated and validated.

---

## Day 9 – PID Optimization and Final Controller Tuning

**Date:** 07 August 2026

### Objectives
- Optimize PID controller performance.
- Improve speed tracking accuracy.
- Finalize throttle and brake logic.
- Prepare the EV model for documentation.

### Work Completed

#### 1. PID Controller Tuning
- Optimized proportional, integral, and derivative gains.
- Improved acceleration response.
- Reduced steady-state tracking error.
- Enhanced controller stability.

#### 2. Throttle Logic Redesign
- Redesigned complete throttle and brake MATLAB Function.
- Added desired speed and actual speed comparison.
- Introduced speed tolerance and stop conditions.
- Eliminated throttle activation after vehicle stop.

#### 3. Brake Logic Optimization
- Improved brake command generation.
- Reduced throttle–brake conflict.
- Smoothed braking response.
- Verified proper regenerative and mechanical braking coordination.

#### 4. Simulation Validation
- Compared Desired Speed vs Actual Speed.
- Verified throttle response.
- Verified brake response.
- Evaluated overall controller performance.
- Confirmed stable vehicle operation throughout the drive cycle.

### Results
- Significant improvement in speed tracking.
- Stable throttle and brake operation.
- Vehicle successfully follows the drive cycle.
- No unwanted oscillations after stopping.
- Achieved a robust closed-loop EV speed control system.

### Final Status
- ✅ Driver Controller Completed
- ✅ Vehicle Dynamics Completed
- ✅ Mechanical Braking Completed
- ✅ Regenerative Braking Completed
- ✅ Battery Model Completed
- ✅ Inverter Model Completed
- ✅ PMSM Motor Completed
- ✅ Transmission Completed
- ✅ Closed-Loop Speed Control Validated

### Overall Project Progress
**Estimated Completion:** **98–99%**

### Next Planned Work
- Final technical review of the complete project.
- GitHub repository setup.
- Project documentation.
- IEEE-style report preparation.
- Presentation (PPT) development.
- Viva preparation.
---

## Dashboard Development and Final Integration

### Dashboard Implementation

- Created a dedicated Simulink dashboard model:
  `Smart_EV_Powertrain_Dashboard.slx`
- Integrated the major EV powertrain subsystems with the dashboard.
- Added real-time visualization of vehicle, battery and motor/powertrain parameters.
- Added a circular gauge for vehicle speed.
- Added a circular gauge for battery State of Charge (SOC).
- Added numerical displays for important system parameters.

### Vehicle Parameters Displayed

- Vehicle Speed (km/h)
- Brake Force (N)
- Vehicle Distance
- Vehicle Acceleration

### Battery Parameters Displayed

- Battery SOC (%)
- Battery Power (kW)
- Battery Voltage (V)
- Battery Current (A)

### Motor / Powertrain Parameters Displayed

- Motor Torque (Nm)
- Motor Power (kW)
- Motor RPM

### Dashboard Organization

The dashboard was organized into three main sections:

1. **VEHICLE**
2. **BATTERY**
3. **MOTOR / POWERTRAIN**

This arrangement provides a clear separation between vehicle-level, battery-level and motor/powertrain information.

### Dashboard Validation

The dashboard was tested through the complete Simulink model.

During testing:

- Vehicle speed response was observed.
- Battery SOC response was monitored.
- Battery voltage and current were monitored.
- Battery power was monitored.
- Motor torque and motor power were observed.
- Motor RPM was monitored.
- Brake force, acceleration and distance were displayed.
- Dashboard values were checked during different simulation durations.

### SOC Model Validation

The battery SOC subsystem was tested during simulation.

The SOC response was observed over the simulation period and the dashboard SOC gauge was configured with a range of:

- Minimum: 0%
- Maximum: 100%

### Display and Layout Improvements

The dashboard was refined to improve readability and presentation quality.

The final layout contains:

- A project title.
- Three functional sections.
- Vehicle speed gauge.
- Battery SOC gauge.
- Numerical parameter displays.
- Consistent parameter labels.
- Clear separation between vehicle, battery and motor/powertrain information.

### Final Dashboard Status

The Smart EV Powertrain Dashboard was successfully integrated with the EV powertrain simulation and provides a real-time visual representation of the major system parameters.

The dashboard is intended to serve as the primary visualization interface for the completed Smart EV Powertrain Simulator.
---

# Day 10 – Dashboard Development and Final Simulation Validation

**Date:** 08 August 2026

## Objectives

- Complete the Smart EV Powertrain dashboard.
- Improve visualization of the final simulation.
- Verify important vehicle, battery and motor parameters.
- Validate the dashboard using the completed Simulink model.
- Prepare the project for final documentation.

---

## Work Completed

### 1. Dashboard Model Finalization

Completed the dedicated dashboard model:

```text
Models/Smart_EV_Powertrain_Dashboard.slx
