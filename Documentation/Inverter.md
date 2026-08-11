# ⚡ Inverter Model

## 1. Overview

The inverter sits between the battery and the PMSM traction motor, converting the battery's DC power into the three-phase AC power the motor needs. In the Smart EV Powertrain Simulator it's modelled as a **three-phase, two-level voltage source inverter (VSI)** — the standard topology used in production EV drive units.

The inverter calculations are implemented in `Scripts/Inverter.m`, which loads the finished [battery pack design](Battery.md) and works forward through the DC input, the AC output voltages, and the resulting power flow and losses.

---

## 2. Inverter Specifications

| Parameter | Value |
|---|---:|
| Type | Three-Phase Voltage Source Inverter |
| Topology | Two-Level |
| Switching Frequency | 10,000 Hz |
| Efficiency | 98% |
| Modulation Index | 0.95 |

The modulation index describes how much of the available DC bus voltage the inverter's PWM switching pattern actually converts into fundamental-frequency AC voltage — a value of 1.0 would be full utilisation, so 0.95 represents a inverter operating close to, but safely below, its voltage ceiling.

---

## 3. Inverter Design Method

### 3.1 DC-Side Calculation

The inverter's DC input is simply the pack's nominal voltage and continuous current, carried over from the battery design:

```matlab
EV.Inverter.Calculated.DC.VoltageV = EV.Battery.Calculated.Voltage.Nominal;
EV.Inverter.Calculated.DC.CurrentA = EV.Battery.Calculated.Current.Continuous;

EV.Inverter.Calculated.DC.PowerkW = ...
    (EV.Inverter.Calculated.DC.VoltageV * EV.Inverter.Calculated.DC.CurrentA) / 1000;
```

### 3.2 AC Voltage Calculation

The AC line voltage produced by a two-level VSI under sinusoidal PWM is a function of the DC bus voltage and the modulation index:

$$
V_{line} = m \cdot \frac{V_{DC}}{\sqrt{2}} \qquad V_{phase} = \frac{V_{line}}{\sqrt{3}}
$$

```matlab
EV.Inverter.Calculated.AC.LineVoltageV = ...
    EV.Inverter.ModulationIndex * EV.Inverter.Calculated.DC.VoltageV / sqrt(2);

EV.Inverter.Calculated.AC.PhaseVoltageV = ...
    EV.Inverter.Calculated.AC.LineVoltageV / sqrt(3);
```

### 3.3 AC Power Calculation

Output power is simply input power scaled by the fixed inverter efficiency, with the difference reported as loss:

```matlab
EV.Inverter.Calculated.Power.InputkW = EV.Inverter.Calculated.DC.PowerkW;

EV.Inverter.Calculated.Power.OutputkW = ...
    EV.Inverter.Calculated.Power.InputkW * EV.Inverter.Efficiency;

EV.Inverter.Calculated.Power.LosseskW = ...
    EV.Inverter.Calculated.Power.InputkW - EV.Inverter.Calculated.Power.OutputkW;
```

### 3.4 AC Current Calculation

Phase current follows from the standard three-phase power relationship, solved for current:

$$
I_{phase} = \frac{P_{output}}{\sqrt{3} \cdot V_{line}}
$$

```matlab
EV.Inverter.Calculated.AC.PhaseCurrentA = ...
    (EV.Inverter.Calculated.Power.OutputkW * 1000) / ...
    (sqrt(3) * EV.Inverter.Calculated.AC.LineVoltageV);
```

### 3.5 Validation

```matlab
PowerError = abs(EV.Inverter.Calculated.Power.OutputkW - ...
    EV.Inverter.Calculated.Power.InputkW * EV.Inverter.Efficiency);

PowerErrorPercent = (PowerError / EV.Inverter.Calculated.Power.InputkW) * 100;

ValidationStatus = "PASS";
if PowerErrorPercent > 0.1
    ValidationStatus = "FAIL";
end
```

---

## 4. Results at a Glance

Actual output from `Data/Inverter_Calculations.mat`, using the 400 V / 342 A DC input carried over from the battery pack:

| Result | Value |
|---|---:|
| DC Voltage | 400.00 V |
| DC Current | 342.00 A |
| DC Power | 136.80 kW |
| AC Line Voltage | 268.70 V |
| AC Phase Voltage | 155.13 V |
| AC Phase Current | 288.06 A |
| Output Power | 134.06 kW |
| Power Loss | 2.74 kW |
| Power Error | 0.0000% |
| Validation | PASS |

Roughly 2.7 kW is lost to switching and conduction losses inside the inverter at this operating point — the fixed cost of turning DC into clean three-phase AC.

---

## 5. Simulink Runtime Model

The `Inverter` subsystem inside `Models/Smart_EV_Powertrain.slx` doesn't use the fixed 98% figure above during simulation. Instead it models efficiency as a function of instantaneous power — a rough but useful stand-in for the fact that switching losses matter proportionally more at light load:

```matlab
function MotorPower = fcn(BatteryPower)

% Variable inverter efficiency
if abs(BatteryPower) < 1000
    Eff = 0.85;
elseif abs(BatteryPower) < 5000
    Eff = 0.92;
else
    Eff = 0.96;
end

% Battery -> Motor
if BatteryPower >= 0
    MotorPower = BatteryPower * Eff;
else
    % Motor -> Battery (regenerative braking)
    MotorPower = BatteryPower / Eff;
end
```

> **Note:** At the pack's typical cruising power (tens of kW), the runtime block settles at 96% efficiency — close to, but not identical to, the 98% used in the offline sizing script. The three-tier efficiency curve is a simplification of a real switching-loss curve; a genuinely detailed model (IGBT/SiC conduction and switching loss vs. current, junction temperature, dead-time effects) is listed under the project's [Future Scope](../README.md#-future-scope).

---

## Related Documentation

| ← Previous | Index | Next → |
|---|---|---|
| [Battery](Battery.md) | [Documentation Home](../README.md) | [Motor](Motor.md) |
