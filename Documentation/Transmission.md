# Transmission Model

## 1. Overview

The Smart EV Powertrain Simulator uses a single-speed transmission between the PMSM traction motor and the vehicle wheels.

The transmission performs two main functions:

- Reduces motor speed
- Multiplies motor torque

The transmission model also accounts for transmission efficiency and calculates the associated power loss.

The transmission calculations are implemented in:

```text
Scripts/Transmission.m