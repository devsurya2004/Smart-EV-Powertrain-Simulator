# Design Decisions

## Smart EV Powertrain Simulator

**Project:** Smart EV Powertrain Simulator  
**Project ID:** SEV-01  
**Author:** Suryadev  
**Version:** 1.0  

---

## 1. Purpose

This document records the major engineering decisions made during the development of the Smart EV Powertrain Simulator.

The decisions are based on the implemented MATLAB scripts, Simulink subsystems, vehicle model, motor model, battery model, regenerative braking model, and dashboard.

---

## 2. Vehicle Configuration

### Decision

A compact electric SUV configuration was selected as the reference vehicle.

### Selected Parameters

| Parameter | Selected Value |
|---|---:|
| Vehicle Type | Compact Electric SUV |
| Vehicle Mass | 1650 kg |
| Drive Configuration | Front Wheel Drive |
| Top Speed | 150 km/h |
| 0–100 km/h Target | 9.5 s |
| Frontal Area | 2.40 m² |
| Drag Coefficient | 0.30 |
| Rolling Resistance Coefficient | 0.010 |
| Wheel Radius | 0.34 m |

### Reason

These parameters provide a realistic reference vehicle for evaluating acceleration, aerodynamic resistance, rolling resistance, motor power, and overall powertrain behaviour.

---

## 3. Battery Chemistry Selection

### Decision

Lithium Iron Phosphate (LFP) cells were selected for the simulated battery pack.

### Selected Cell

- Chemistry: Lithium Iron Phosphate (LFP)
- Form Factor: 32700 cylindrical
- Nominal Voltage: 3.2 V
- Maximum Voltage: 3.65 V
- Minimum Voltage: 2.50 V
- Capacity: 6 Ah
- Continuous Current: 18 A
- Peak Current: 30 A
- Internal Resistance: 0.006 Ω
- Cell Mass: 0.145 kg

### Reason

The LFP cell model provides a suitable reference for a high-voltage EV battery simulation and allows the battery pack to be designed using series and parallel cell calculations.

---

## 4. Battery Pack Design

### Decision

The battery pack is sized using the required pack voltage and energy capacity.

The model calculates:

- Number of series cells
- Number of parallel cells
- Total number of cells
- Nominal pack voltage
- Maximum pack voltage
- Minimum pack voltage
- Pack capacity
- Pack energy
- Continuous current capability
- Peak current capability
- Battery mass

### Reason

Separating cell-level specifications from calculated pack-level parameters makes the battery model easier to modify and reuse for different vehicle requirements.

---

## 5. PMSM Motor Selection

### Decision

A Permanent Magnet Synchronous Motor (PMSM) was selected as the traction motor.

### Selected Parameters

| Parameter | Value |
|---|---:|
| Motor Type | PMSM |
| Rated Power | 105 kW |
| Peak Power | 160 kW |
| Base Speed | 6000 RPM |
| Maximum Speed | 12000 RPM |
| Maximum Efficiency | 96% |

### Reason

The PMSM model provides the required torque and speed characteristics for an EV traction application.

The implemented motor model represents:

1. Constant torque operation below base speed.
2. Constant power operation above base speed.

This allows the simulation to represent the typical torque-speed behaviour of an EV traction motor.

---

## 6. Motor Torque-Speed Modelling

### Decision

The motor characteristic is divided into two operating regions.

### Constant Torque Region

For motor speeds up to the base speed (6,000 RPM):

```text
Torque = Rated Torque
```

The motor delivers a fixed 167.11 Nm regardless of speed, so power rises linearly with RPM up to the base speed.

### Constant Power Region

Above base speed, up to the maximum speed (12,000 RPM):

```text
Power = Rated Power
Torque = Rated Power / Speed
```

Torque falls off as 1/speed so that power stays pinned at the 105 kW rated value — the classic field-weakening behaviour of a PMSM operating above base speed.

### Reason

Splitting the characteristic into these two regions is the simplest model that still captures how a real traction PMSM actually behaves, and it's what `Motor_Characteristics.m` plots directly.

---

## 7. Gear Ratio and Transmission

### Decision

A **single-speed transmission** (10.25:1, 97% efficiency) was used instead of a multi-speed gearbox.

### Reason

An EV motor's torque is available from zero RPM and stays roughly flat across a wide speed range, so the primary job of the transmission is simply to match the motor's speed range to the wheel's — a multi-speed gearbox adds cost, mass and complexity without a clear performance benefit. The 10.25:1 ratio itself falls directly out of matching the motor's 12,000 RPM maximum speed to the wheel speed needed at the vehicle's 150 km/h top speed (see [Motor.md §3.2](Motor.md#32-gear-ratio)).

---

## 8. Inverter Topology

### Decision

A **three-phase, two-level voltage source inverter** (98% efficiency, 10 kHz switching, 0.95 modulation index) was used to interface the battery and the PMSM.

### Reason

The two-level VSI is the standard, well-understood topology for EV traction inverters, and a fixed efficiency figure is sufficient for system-level power-flow sizing without needing a full switching-loss model. A separate, power-dependent efficiency model is used in the Simulink runtime block for more realistic dynamic behaviour (see [Inverter.md §5](Inverter.md#5-simulink-runtime-model)).

---

## 9. Drive Cycle Profile

### Decision

A short, hand-built synthetic urban drive cycle (accelerate → cruise → decelerate → stop, 120 s) was used to exercise the powertrain, rather than importing a full standard test cycle.

### Reason

A compact profile is enough to validate that every subsystem — controller, battery, inverter, motor, transmission, vehicle dynamics, regen — responds correctly across acceleration, cruise and braking, while keeping simulation and plotting fast during development. `Project_Parameters.m` still labels the drive cycle `"FTP75"`, reflecting the original intent to eventually substitute a certified cycle from `DriveCycles/`; this is tracked as future work (see [README — Future Scope](../README.md#-future-scope)).

---

## 10. Regenerative Braking Strategy

### Decision

Regeneration was modelled as a simple efficiency-and-cap model (75% efficiency, 80 kW maximum, active only above 10 km/h) applied to the braking power implied by the drive cycle, rather than a full motor-side regen torque control loop.

### Reason

This keeps the energy-recovery bookkeeping (recovered energy, net battery energy, resulting SOC) transparent and easy to validate by hand, while the separate Simulink `Torque-Speed Limit` block in the PMSM Motor subsystem independently models regenerative *torque* blending during simulation — giving the project both a simple analytical energy view and a more physical dynamic view.

---

## 11. Closed-Loop Speed Control

### Decision

A PID-based Driver Controller (P = 0.03, I = 0.001, D = 0.001) with a dead zone, output saturation and a rate limiter was used to track the drive cycle, rather than an open-loop throttle profile.

### Reason

A closed loop is necessary for the simulated vehicle to actually follow the reference speed trace under real inertia and resistance forces, and mirrors how a real driver (or a production Adaptive Cruise Control system) modulates throttle and brake. The dead zone and rate limiter were added specifically to prevent the throttle/brake outputs from chattering, which produces a much more realistic-looking response in the Dashboard scopes (see [Controller.md](Controller.md)).

---

## 12. Dashboard Design

### Decision

A dedicated Simulink dashboard (`Models/Smart_EV_Powertrain_Dashboard.slx`) was built with three sections — **Vehicle**, **Battery**, and **Motor / Powertrain** — rather than folding gauges into the main powertrain model.

### Reason

Separating the dashboard into its own model keeps the main powertrain model focused on the physics, while giving a single, readable view of the variables that matter most for judging a simulation run at a glance: vehicle speed and distance, battery SOC/voltage/current/power, and motor torque/power/RPM. See the [User Manual](User_Manual.md#5-monitoring-the-dashboard) for how to read it.

---

## Related Documentation

| ← Previous | Index | Next → |
|---|---|---|
| [Controller](Controller.md) | [Documentation Home](../README.md) | [Installation Guide](Installation_Guide.md) |