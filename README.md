# Smart EV Powertrain Simulator

> A modular MATLAB/Simulink-based electric vehicle powertrain simulation platform for analysing vehicle dynamics, battery behaviour, motor performance, power flow, energy consumption, regenerative braking, and closed-loop speed control.

---

## Overview

The **Smart EV Powertrain Simulator** is a modular electric vehicle (EV) powertrain simulation project developed using **MATLAB and Simulink**.

The project is designed to model and analyse the behaviour of an electric vehicle from the desired driving cycle to the final vehicle motion. It combines individual powertrain components into an integrated system consisting of a **Drive Cycle, Driver Controller, Battery, Inverter, PMSM Motor, Transmission, and Vehicle Dynamics**.

The simulator also includes **regenerative braking**, subsystem-level engineering calculations, result storage, performance analysis, and visual monitoring of important vehicle and powertrain variables.

The main power-flow path of the simulator is:

```text
Drive Cycle
     │
     ▼
Driver Controller
     │
     ▼
Battery
     │
     ▼
Inverter
     │
     ▼
PMSM Motor
     │
     ▼
Transmission
     │
     ▼
Vehicle Dynamics
     │
     ▼
Vehicle Motion
     │
     └────────────── Feedback ──────────────┐
                                           │
                                           ▼
                                    Driver Controller
# System Requirements

The Smart EV Powertrain Simulator requires a MATLAB and Simulink environment capable of opening and running the included models.

## Software Requirements

| Requirement | Purpose |
|---|---|
| MATLAB | Engineering calculations, parameter management and result processing |
| Simulink | Dynamic EV powertrain simulation |
| MATLAB Project | Project organisation and path management |
| Git | Version control |
| GitHub | Remote repository and project sharing |

The project should preferably be opened using the MATLAB project file:

```text
Smart-EV-Powertrain-Simulator.prj
# Reference Vehicle Specifications

The simulator uses a compact electric SUV as the reference vehicle.

## Vehicle Parameters

| Parameter | Value | Unit |
|---|---:|---|
| Vehicle Name | SEV-01 | — |
| Vehicle Type | Compact Electric SUV | — |
| Vehicle Mass | 1650 | kg |
| Drive Configuration | Front Wheel Drive | — |
| Top Speed | 150 | km/h |
| Acceleration Target | 0–100 km/h in 9.5 | s |
| Passenger Capacity | 5 | passengers |
| Drag Coefficient | 0.30 | — |
| Frontal Area | 2.40 | m² |
| Rolling Resistance Coefficient | 0.010 | — |
| Wheel Radius | 0.34 | m |

---

# Battery Specifications

The battery model is based on a high-voltage LFP battery pack.

## Battery Pack Requirements

| Parameter | Value | Unit |
|---|---:|---|
| Target Pack Voltage | 400 | V |
| Target Pack Energy | 45 | kWh |
| Initial SOC | 100 | % |
| Maximum SOC | 100 | % |
| Minimum SOC | 0 | % |
| Maximum Battery Power | 50 | kW |
| Discharge Efficiency | 95 | % |
| Charge Efficiency | 90 | % |

---

## Battery Cell Specifications

The selected reference cell is an LFP 32700 cylindrical cell.

| Parameter | Value | Unit |
|---|---:|---|
| Chemistry | Lithium Iron Phosphate (LFP) | — |
| Form Factor | 32700 Cylindrical | — |
| Nominal Voltage | 3.2 | V |
| Maximum Voltage | 3.65 | V |
| Minimum Voltage | 2.50 | V |
| Capacity | 6.0 | Ah |
| Continuous Current | 18 | A |
| Peak Current | 30 | A |
| Internal Resistance | 0.006 | Ω |
| Cell Mass | 0.145 | kg |

The cell energy is calculated from:

```text
Cell Energy = Cell Nominal Voltage × Cell Capacity
# How to Run the Project

The project can be operated in two main stages:

1. MATLAB-based engineering calculations
2. MATLAB/Simulink-based dynamic simulation

The recommended workflow is to complete the MATLAB calculations first and then run the integrated Simulink model.

---

# Stage 1 — MATLAB Calculation Workflow

## Step 1: Open the MATLAB Project

Open:

```text
Smart-EV-Powertrain-Simulator.prj
