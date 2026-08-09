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