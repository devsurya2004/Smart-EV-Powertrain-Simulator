# Smart EV Powertrain Simulator

# Project Coding Standard

**Version:** 1.0  
**MATLAB Version:** R2026a Update 4

---

# 1. Purpose

This document defines the coding standards, project architecture, and development workflow for the Smart EV Powertrain Simulator.

The objectives of these standards are to:

- Maintain consistency across all project modules.
- Improve code readability and maintainability.
- Simplify debugging and testing.
- Standardize project architecture.
- Produce a professional engineering project suitable for GitHub.

These standards apply to all MATLAB scripts, functions, Simulink models, documentation, and future project modules.

---

# 2. Project Directory Structure

```
Smart-EV-Powertrain-Simulator
│
├── Data
├── Documentation
├── DriveCycles
├── GitHub
├── Images
├── MATLAB
├── Models
├── Motor
├── Reports
├── Resources
├── Results
├── Scripts
├── Tests
├── Vehicle
│
├── README.md
├── Project_Log.md
├── Coding_Standard.md
└── Smart-EV-Powertrain-Simulator.prj
```

Folder descriptions

| Folder | Purpose |
|----------|----------|
| Scripts | MATLAB calculation scripts |
| Models | Simulink models |
| Data | Saved MATLAB `.mat` files |
| Results | Generated plots and exported results |
| Reports | Project reports |
| Documentation | Technical documentation |
| Images | Images used in documentation |
| Tests | Validation and testing scripts |
| DriveCycles | Standard drive cycle datasets |

---

# 3. Script Initialization

Every top-level MATLAB script shall begin with

```matlab
clear

[EV, scriptFolder, projectRoot] = Initialize_Project();
```

No script shall directly use relative paths such as

```
../Data
```

Always use

```matlab
fullfile(projectRoot,...)
```

to ensure portability.

---

# 4. Script Organization

Every calculation module shall follow the same structure.

```
Initialization

↓

Input Parameters

↓

Calculations

↓

Validation

↓

Display Results

↓

Save Results
```

Calculations shall never appear after the Display Results section.
# Loading Dependencies

When a calculation module depends on results from previously completed modules, it shall explicitly load only the required calculated data.

Example

```matlab
loadedData = load( ...
    fullfile(projectRoot,'Data','Battery_Calculations.mat'), ...
    'EV');

EV.Battery.Calculated = loadedData.EV.Battery.Calculated;
```

Do not overwrite the complete `EV` structure.

Only import the subsystem required by the current module.

This ensures modules remain independent, reusable and easy to test.

---

# 5. Section Header Format

Major Sections

```matlab
%%=========================================================================
% Section Name
% Description
%==========================================================================
```

Sub Sections

```matlab
%%-----------------------------------------------------------------------
% Section Name
%-----------------------------------------------------------------------
```

All scripts shall use this format.

---

# 6. Naming Conventions

Variable names shall be descriptive.

Good examples

```
MotorSpeedRPM
WheelTorque
BatteryMass
VoltageErrorPercent
EnergyConsumption
```

Avoid

```
x
a
temp
value
```

Use PascalCase for variables.

---

# 7. Units

Engineering units shall be included whenever appropriate.

Examples

```
VehicleSpeedkmh
MotorSpeedRPM
BatteryCapacityAh
PackEnergykWh
MotorPowerkW
```

Avoid ambiguous variable names.

---

# 8. Project Parameters

Project constants shall be stored only inside

```
Project_Parameters.m
```

Never hardcode engineering constants inside calculation scripts.

Correct

```matlab
EV.Vehicle.Mass
```

Incorrect

```matlab
Mass = 1650;
```

---

# 9. Project Structure

All project data shall be stored inside

```
EV
```

Subsystem example

```
EV

Vehicle

Motor

Battery

Transmission

Inverter

DriveCycle
```

Calculated values shall always be stored under

```
Calculated
```

Example

```
EV.Battery.Calculated
EV.Motor.Calculated
EV.Vehicle.Calculated
```

Intermediate calculations shall remain local variables.

Correct

```matlab
VoltageError = ...
```

Incorrect

```matlab
EV.Battery.VoltageError = ...
```

---

# 10. Validation

Every calculation module shall contain a Validation section.

Validation shall produce

```
PASS
```

or

```
FAIL
```

Validation logic shall be completed before the Display Results section.

---

# 11. Console Report Standard

Every module shall produce a report using the following layout.

```
============================================================
              SMART EV POWERTRAIN SIMULATOR
                 <MODULE NAME> REPORT
============================================================

Section Name
------------------------------------------------------------

...

Validation
------------------------------------------------------------

Overall Status : PASS

============================================================
```

Only the module name shall change.

---

# 12. Saving Results

Every completed module shall save its calculated results.

Example

```matlab
save( ...
    fullfile(projectRoot,'Data','Battery_Calculations.mat'), ...
    'EV');
```

The save operation shall always display

```
Save Successful
```

and the saved file location.

---

# 13. MATLAB Style Rules

Use

```matlab
...
```

for long statements.

Indent nested code using four spaces.

Leave one blank line between logical sections.

Recommended maximum line length

```
100–120 characters
```

Comments should explain

```
WHY
```

instead of

```
WHAT
```

---

# 14. Git Workflow

Development workflow

```
Implement

↓

Test

↓

Validate

↓

Update Project Log

↓

Commit

↓

Push
```

Each commit shall represent one completed feature.

Recommended commit messages

```
Add vehicle calculations

Implement motor characteristics

Complete battery pack design

Refactor initialization system
```

Avoid commit messages such as

```
Update

Changes

Fix

Final
```

---

# 15. Documentation Standard

Every completed module shall update

```
Project_Log.md
```

Documentation should include

- Features implemented
- Validation summary
- Files modified
- Architecture improvements

---

# 16. Module Completion Checklist

Before considering any module complete, verify the following.

- [ ] Parameters added to `Project_Parameters.m`
- [ ] Calculations implemented
- [ ] Validation completed
- [ ] Professional console report generated
- [ ] Results saved to `Data/`
- [ ] Code tested successfully
- [ ] `Project_Log.md` updated
- [ ] Git commit created

---

# 17. General Principles

Every piece of code should prioritize

1. Readability
2. Consistency
3. Maintainability
4. Reusability
5. Simplicity

When multiple solutions exist, prefer the simpler and more maintainable implementation.

---

# Revision History

| Version | Date | Description |
|----------|------|-------------|
| 1.0 | July 2026 | Initial coding standard created for the Smart EV Powertrain Simulator. |