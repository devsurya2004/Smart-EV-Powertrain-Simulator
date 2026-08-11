# Smart EV Powertrain Simulator
# User Manual

## 1. Introduction

This document explains how to operate the **Smart EV Powertrain Simulator** after the project has been installed and configured.

The simulator combines MATLAB calculation scripts with an integrated Simulink EV powertrain model.

The main system consists of:

- Drive Cycle
- Driver Controller
- Battery
- Inverter
- PMSM Motor
- Transmission
- Vehicle Dynamics
- Regenerative Braking
- Dashboard and Monitoring

The general operating sequence is:

```text
Project Initialisation
        ↓
Parameter Configuration
        ↓
Engineering Calculations
        ↓
Simulink Model
        ↓
Closed-Loop Simulation
        ↓
Dashboard Monitoring
        ↓
Results Analysis
```

This manual walks through each stage in order. For first-time setup, see the [Installation Guide](Installation_Guide.md) first.

---

## 2. Project Initialisation

Every session starts by opening the MATLAB Project file:

```text
Smart-EV-Powertrain-Simulator.prj
```

This puts the project's folders on the MATLAB path and makes every script and model reachable by name.

---

## 3. Parameter Configuration

All design parameters — vehicle, battery cell, motor, transmission, inverter, regeneration, driver limits, environment and simulation settings — live in one place:

```text
Scripts/Project_Parameters.m
```

To explore a different vehicle configuration (a different mass, a bigger battery, a higher-power motor, and so on), edit the relevant values in this file and re-run the calculation modules described next. Every downstream script and the Simulink model itself reads from this single source of truth via the shared `EV` structure, so a change here propagates everywhere automatically.

---

## 4. Running the Engineering Calculations

From the MATLAB command window, run:

```matlab
Run_Project
```

This executes, in order: **Battery → Motor → Transmission → Inverter → Vehicle → Vehicle Dynamics → Drive Cycle → Regenerative Braking → Performance Summary**, printing a design report for each and finishing with a total execution time. Each stage's results are written to `Data/*.mat` and, where applicable, plotted to `Results/<Module>/`.

Individual modules can also be run on their own — for example, running just `Motor_Characteristics` after tweaking a motor parameter to regenerate its torque-speed and power-speed plots without repeating every other calculation.

See the individual subsystem pages for what each module calculates: [Battery](Battery.md) · [Inverter](Inverter.md) · [Motor](Motor.md) · [Transmission](Transmission.md) · [Vehicle](Vehicle.md) · [Drive Cycle](Drive_Cycle.md) · [Regenerative Braking](Regenerative_Braking.md).

---

## 5. Running the Simulink Model

Open the main powertrain model:

```text
Models/Smart_EV_Powertrain.slx
```

The model wires the subsystems together into the closed loop described in the [README](../README.md#-about-the-project): Drive Cycle → Driver Controller → Battery → Inverter → PMSM Motor → Transmission → Vehicle Dynamics → Vehicle Speed → feedback to the Driver Controller.

Press **Run** ▶️ to simulate. The [Driver Controller](Controller.md) will track the drive cycle's speed profile, and each subsystem's internal scopes will log its variables as the simulation progresses.

> The calculation scripts (step 4) must be run at least once in the current MATLAB session before simulating, since the model reads several parameters (motor limits, gear ratio, efficiencies, and so on) from the `EV` structure in the base workspace.

---

## 6. Monitoring the Dashboard

Open the companion dashboard model:

```text
Models/Smart_EV_Powertrain_Dashboard.slx
```

and run it alongside (or after) the main model. The dashboard is organised into three sections:

| Section | Displays |
|---|---|
| **Vehicle** | Vehicle Speed, Brake Force, Vehicle Distance, Vehicle Acceleration |
| **Battery** | SOC, Battery Voltage, Battery Current, Battery Power |
| **Motor / Powertrain** | Motor Torque, Motor Power, Motor RPM |

The SOC gauge is scaled 0–100%, matching the pack's usable state-of-charge range. This is the fastest way to sanity-check a simulation run at a glance without digging into individual scope traces.

![Smart EV Powertrain Dashboard](../Images/Dashboard.png)

---

## 7. Results Analysis

Every calculation module saves its plots to `Results/<Module>/` as `.png` files, ready to review directly or reference elsewhere:

```text
Results/
├── DriveCycle/            Speed, Acceleration, TractiveForce, BatteryPower, Energy
├── Motor/                 Torque_Speed, Power_Speed
├── RegenerativeBraking/   BrakingPower, RecoveredPower, RecoveredEnergy, StateOfCharge
└── PerformanceSummary/    SystemArchitecture, PowerFlow, EnergyDistribution, EfficiencyBreakdown
```

For a narrated walkthrough of what these results mean, see the **Results at a Glance** section on each subsystem's documentation page, which quotes the actual figures produced by the reference SEV-01 configuration.

---

## 8. Typical Workflow Summary

| Step | Action | Where |
|---|---|---|
| 1 | Open the project | `Smart-EV-Powertrain-Simulator.prj` |
| 2 | (Optional) adjust design parameters | `Scripts/Project_Parameters.m` |
| 3 | Run all calculations | `Run_Project` in the MATLAB command window |
| 4 | Run the closed-loop simulation | `Models/Smart_EV_Powertrain.slx` |
| 5 | Monitor key variables | `Models/Smart_EV_Powertrain_Dashboard.slx` |
| 6 | Review results | `Results/` folder or [Documentation](../README.md) |

---

## Related Documentation

| ← Previous | Index |
|---|---|
| [Installation Guide](Installation_Guide.md) | [Documentation Home](../README.md) |