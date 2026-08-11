# ⚙️ Transmission Model

## 1. Overview

The Smart EV Powertrain Simulator uses a **single-speed transmission** between the PMSM traction motor and the vehicle's wheels — the near-universal choice in production EVs, since an electric motor's wide, flat torque curve makes a multi-speed gearbox largely unnecessary.

The transmission performs two jobs:

- **Reduces** motor speed down to wheel speed
- **Multiplies** motor torque up to wheel torque

It also accounts for mechanical losses (gear mesh, bearings) through a fixed efficiency figure, so the torque delivered to the wheel is always slightly less than a lossless gear ratio would suggest.

The transmission calculations are implemented in `Scripts/Transmission.m`.

---

## 2. Transmission Specifications

| Parameter | Value |
|---|---:|
| Type | Single Speed |
| Gear Ratio | 10.25 : 1 |
| Efficiency | 97% |

This gear ratio isn't picked in isolation — it's the value the [Motor](Motor.md#32-gear-ratio) design calculation converges on when matching the motor's maximum speed to the wheel speed needed at the vehicle's 150 km/h top speed.

---

## 3. Transmission Design Method

### 3.1 Output Speed

Output (wheel) speed is simply motor speed divided by the gear ratio:

```matlab
EV.Transmission.Calculated.Output.SpeedRPM = ...
    EV.Motor.MaximumSpeedRPM / EV.Transmission.GearRatio;
```

### 3.2 Output Torque

Output torque is motor torque multiplied by the gear ratio, then de-rated by the transmission's mechanical efficiency:

$$
T_{out} = T_{motor} \cdot GR \cdot \eta_{trans}
$$

```matlab
EV.Transmission.Calculated.Output.TorqueNm = ...
    EV.Motor.PeakTorque * EV.Transmission.GearRatio * EV.Transmission.Efficiency;
```

### 3.3 Speed Reduction and Torque Multiplication Ratios

```matlab
EV.Transmission.Calculated.Ratio.SpeedReduction = EV.Transmission.GearRatio;

EV.Transmission.Calculated.Ratio.TorqueMultiplication = ...
    EV.Transmission.GearRatio * EV.Transmission.Efficiency;
```

The torque multiplication ratio (9.9425) is always slightly below the raw gear ratio (10.25), because the 3% mechanical loss eats into the torque gain the gearing would otherwise provide.

### 3.4 Power Flow

```matlab
InputAngularSpeed = EV.Motor.MaximumSpeedRPM * (2 * pi / 60);
OutputAngularSpeed = EV.Transmission.Calculated.Output.SpeedRPM * (2 * pi / 60);

EV.Transmission.Calculated.Power.InputkW = ...
    EV.Motor.PeakTorque * InputAngularSpeed / 1000;

EV.Transmission.Calculated.Power.OutputkW = ...
    EV.Transmission.Calculated.Output.TorqueNm * OutputAngularSpeed / 1000;

EV.Transmission.Calculated.Power.LosseskW = ...
    EV.Transmission.Calculated.Power.InputkW - EV.Transmission.Calculated.Power.OutputkW;
```

### 3.5 Validation

```matlab
PowerError = abs(EV.Transmission.Calculated.Power.OutputkW - ...
    EV.Transmission.Calculated.Power.InputkW * EV.Transmission.Efficiency);

PowerErrorPercent = (PowerError / EV.Transmission.Calculated.Power.InputkW) * 100;

ValidationStatus = "PASS";
if PowerErrorPercent > 0.1
    ValidationStatus = "FAIL";
end
```

---

## 4. Results at a Glance

Actual output from `Data/Transmission_Calculations.mat`:

| Result | Value |
|---|---:|
| Output Speed | 1,170.73 RPM |
| Output Torque | 1,954.89 Nm |
| Speed Reduction | 10.25 : 1 |
| Torque Multiplication | 9.9425 |
| Input Power | 247.08 kW |
| Output Power | 239.67 kW |
| Power Loss | 7.41 kW |
| Power Error | 0.0000% |
| Validation | PASS |

At the motor's maximum operating point, about 7.4 kW is lost to mechanical inefficiency on its way from motor shaft to wheel — consistent with the configured 97% transmission efficiency.

---

## 5. Simulink Runtime Model

Unlike the Battery, Motor and Inverter subsystems, the `Transmission` block inside `Models/Smart_EV_Powertrain.slx` (subsystem `system_19`) doesn't need a MATLAB Function block — the physics here is linear, so it's built entirely from standard Simulink blocks:

- **Wheel RPM to Motor RPM** — a `Gain` block implementing the 10.25:1 speed step-up
- **Motor Torque → Wheel Torque** (Gear Reduction) — a `Gain` block implementing the matching torque step-up
- **Vehicle Speed to Wheel RPM** — converts linear vehicle speed into wheel rotational speed ahead of the gear stage

Because both directions of the transmission (speed down, torque up) are pure proportional relationships, no efficiency loss is modelled at runtime — the 97% figure only appears in the offline sizing calculation above. Adding a runtime efficiency gain to the dynamic model would make the two views fully consistent.

---

## Related Documentation

| ← Previous | Index | Next → |
|---|---|---|
| [Motor](Motor.md) | [Documentation Home](../README.md) | [Vehicle](Vehicle.md) |
