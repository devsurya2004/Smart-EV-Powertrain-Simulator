# PMSM Motor Model

## 1. Overview

The Smart EV Powertrain Simulator uses a Permanent Magnet Synchronous Motor (PMSM) as the traction motor.

The motor model is designed according to the vehicle performance requirements and is characterized using continuous Torque-Speed and Power-Speed curves.

Two MATLAB scripts are associated with the motor design:

- `Motor.m`
- `Motor_Characteristics.m`

`Motor.m` calculates the required motor and transmission parameters.

`Motor_Characteristics.m` generates the continuous motor operating characteristics and saves the resulting plots.

---

## 2. Motor Specifications

The project motor parameters are defined in `Project_Parameters.m`.

| Parameter | Value |
|---|---:|
| Motor Type | PMSM |
| Rated Power | 105 kW |
| Peak Power | 160 kW |
| Base Speed | 6000 RPM |
| Maximum Speed | 12000 RPM |
| Maximum Efficiency | 96% |
| Peak Torque | Calculated |

The motor is coupled to the vehicle through a single-speed transmission.

---

## 3. Motor Design Calculation

The `Motor.m` script performs the motor design calculations.

The calculation starts by loading the vehicle calculation results:

```matlab
loadedData = load( ...
    fullfile(projectRoot,'Data','Vehicle_Calculations.mat'),'EV');