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