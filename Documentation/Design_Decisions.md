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

For motor speeds up to the base speed:

```text
Torque = Rated Torque
---

### Constant Power Region

For motor speeds above the base speed:

```text
Torque = Rated Power / Angular Speed