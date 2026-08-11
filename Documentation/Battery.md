# 🔋 Battery System

## 1. Overview

The battery subsystem designs the battery pack that powers the Smart EV Powertrain Simulator. It is the first component sized in the project, because every downstream subsystem — inverter, motor, transmission — is dimensioned around the power and voltage this pack can deliver.

The pack is built up from a single cell datasheet and a target vehicle voltage/energy requirement. Rather than picking pack numbers directly, the script works the way a real pack designer would: start from one cell, decide how many go in series to hit the voltage target, then how many strings go in parallel to hit the energy target, and let the final pack-level numbers (capacity, current, mass) fall out of that arrangement.

The MATLAB implementation (`Scripts/Battery.m`) calculates:

- Number of series cells and parallel strings
- Total cell count
- Nominal, maximum and minimum pack voltage
- Pack capacity and pack energy
- Continuous and peak current capability
- Total battery mass
- Voltage and energy design error against the original target

The results are saved to `Data/Battery_Calculations.mat` and consumed by the Inverter and Regenerative Braking scripts.

---

## 2. Battery Design Specifications

The Smart EV Powertrain Simulator uses a Lithium Iron Phosphate (LFP) cylindrical cell configuration — a chemistry chosen for its thermal stability and long cycle life rather than maximum energy density (see [Design Decisions](Design_Decisions.md#3-battery-chemistry-selection) for the reasoning).

### 2.1 Vehicle Battery Requirements

| Parameter | Target |
|---|---:|
| Battery Pack Voltage | 400 V |
| Battery Pack Energy | 45 kWh |
| Initial SOC | 100% |
| Maximum SOC | 100% |
| Minimum SOC | 0% |
| Maximum Battery Power | 50 kW |
| Discharge Efficiency | 95% |
| Charge Efficiency | 90% |

### 2.2 Cell Specifications

| Parameter | Value |
|---|---:|
| Chemistry | Lithium Iron Phosphate (LFP) |
| Form Factor | 32700 Cylindrical |
| Nominal Voltage | 3.2 V |
| Maximum Voltage | 3.65 V |
| Minimum Voltage | 2.50 V |
| Cell Capacity | 6 Ah |
| Cell Energy | 19.2 Wh |
| Continuous Current | 18 A |
| Peak Current | 30 A |
| Internal Resistance | 0.006 Ω |
| Cell Mass | 0.145 kg |

---

## 3. Battery Design Method

The battery pack follows a series-parallel (S-P) configuration: cells in series build voltage, strings of series cells in parallel build energy.

### 3.1 Series Cell Calculation

Cells connected in series increase pack voltage. The number of series cells is the smallest integer that reaches the target pack voltage:

$$
N_s = \left\lceil \frac{V_{target}}{V_{cell,nom}} \right\rceil
$$

```matlab
EV.Battery.Calculated.Cells.Series = ceil( ...
    EV.Battery.TargetPackVoltage / ...
    EV.Battery.Cell.NominalVoltage);
```

With a 400 V target and a 3.2 V nominal cell, this rounds up to **125 series cells**.

### 3.2 Parallel Cell Calculation

Once the series count is fixed, the energy of one series string is known. The number of parallel strings needed to reach the target pack energy is:

$$
N_p = \left\lceil \frac{E_{target}}{N_s \cdot E_{cell}} \right\rceil
$$

```matlab
EnergyPerSeriesStringWh = ...
    EV.Battery.Calculated.Cells.Series * ...
    EV.Battery.Cell.EnergyWh;

EV.Battery.Calculated.Cells.Parallel = ceil( ...
    EV.Battery.TargetPackEnergyWh / ...
    EnergyPerSeriesStringWh);
```

One 125-cell series string stores 125 × 19.2 Wh = 2,400 Wh. To reach 45,000 Wh the script needs ⌈45,000 / 2,400⌉ = **19 parallel strings**.

### 3.3 Total Cell Count

```matlab
EV.Battery.Calculated.Cells.Total = ...
    EV.Battery.Calculated.Cells.Series * ...
    EV.Battery.Calculated.Cells.Parallel;
```

125 × 19 = **2,375 cells** in the complete pack.

### 3.4 Voltage Calculations

Pack voltage scales directly with the series count:

$$
V_{nom} = N_s \cdot V_{cell,nom} \qquad V_{max} = N_s \cdot V_{cell,max} \qquad V_{min} = N_s \cdot V_{cell,min}
$$

```matlab
EV.Battery.Calculated.Voltage.Nominal = ...
    EV.Battery.Calculated.Cells.Series * EV.Battery.Cell.NominalVoltage;

EV.Battery.Calculated.Voltage.Maximum = ...
    EV.Battery.Calculated.Cells.Series * EV.Battery.Cell.MaximumVoltage;

EV.Battery.Calculated.Voltage.Minimum = ...
    EV.Battery.Calculated.Cells.Series * EV.Battery.Cell.MinimumVoltage;
```

### 3.5 Capacity and Energy Calculations

Pack capacity scales with the parallel count; pack energy follows from voltage × capacity:

```matlab
EV.Battery.Calculated.Capacity.Ah = ...
    EV.Battery.Calculated.Cells.Parallel * EV.Battery.Cell.CapacityAh;

EV.Battery.Calculated.Energy.Wh = ...
    EV.Battery.Calculated.Voltage.Nominal * EV.Battery.Calculated.Capacity.Ah;

EV.Battery.Calculated.Energy.kWh = EV.Battery.Calculated.Energy.Wh / 1000;
```

### 3.6 Current Calculations

Continuous and peak pack current both scale with the number of parallel strings, since each string contributes its own cell-level current in parallel:

```matlab
EV.Battery.Calculated.Current.Continuous = ...
    EV.Battery.Calculated.Cells.Parallel * EV.Battery.Cell.ContinuousCurrent;

EV.Battery.Calculated.Current.Peak = ...
    EV.Battery.Calculated.Cells.Parallel * EV.Battery.Cell.PeakCurrent;
```

### 3.7 Mass Calculation

```matlab
EV.Battery.Calculated.Mass.Total = ...
    EV.Battery.Calculated.Cells.Total * EV.Battery.Cell.Mass;
```

### 3.8 Validation

The script checks the realised pack against the original target and flags a failure if the pack drifts more than 2% off the voltage target or 5% off the energy target:

```matlab
VoltageErrorPercent = abs(EV.Battery.Calculated.Voltage.Nominal - ...
    EV.Battery.TargetPackVoltage) / EV.Battery.TargetPackVoltage * 100;

EnergyErrorPercent = abs(EV.Battery.Calculated.Energy.kWh - ...
    EV.Battery.TargetPackEnergykWh) / EV.Battery.TargetPackEnergykWh * 100;

ValidationStatus = "✓ PASS";
if VoltageErrorPercent > 2 || EnergyErrorPercent > 5
    ValidationStatus = "✗ FAIL";
end
```

Rounding to whole cells is exactly why this check exists — you can't buy 18.75 parallel strings, so the realised pack will always overshoot the target slightly.

---

## 4. Results at a Glance

Actual output from `Data/Battery_Calculations.mat` for the SEV-01 reference vehicle:

| Result | Value |
|---|---:|
| Series Cells | 125 |
| Parallel Cells | 19 |
| Total Cells | 2,375 |
| Nominal Pack Voltage | 400.00 V |
| Maximum Pack Voltage | 456.25 V |
| Minimum Pack Voltage | 312.50 V |
| Pack Capacity | 114.00 Ah |
| Pack Energy | 45.60 kWh |
| Continuous Current | 342.00 A |
| Peak Current | 570.00 A |
| Total Battery Mass | 344.38 kg |
| Voltage Error | 0.00% |
| Energy Error | 1.33% |
| Validation | ✓ PASS |

The 45 kWh target rounds up to a realised **45.6 kWh** pack — a 1.33% overshoot that comes entirely from needing a whole number of parallel strings, and comfortably inside the 5% tolerance.

---

## 5. Simulink Runtime Model

The sizing calculations above run once, offline, to *design* the pack. During simulation, the `Battery` subsystem inside `Models/Smart_EV_Powertrain.slx` models how that pack *behaves* moment to moment, using three MATLAB Function blocks:

**Battery power demand** — converts throttle position and motor power into a battery power draw, switching to a charge path under regenerative braking:

```matlab
function BatteryPower = fcn(throttle, motor_power)

MaxPower = 50000;      % W
DischargeEff = 0.96;
ChargeEff = 0.90;

if motor_power < 0
    % Regenerative charging
    BatteryPower = motor_power * ChargeEff;
else
    RequestedPower = throttle * MaxPower;
    BatteryPower = RequestedPower / DischargeEff;
end
```

**Open-circuit voltage vs. SOC** — a simple linear discharge curve between the pack's usable voltage window:

```matlab
function Voltage = fcn(SOC)

Vmax = 400;
Vmin = 320;

SOC = max(0, min(100, SOC));
Voltage = Vmin + (Vmax - Vmin) * (SOC / 100);
```

**Pack current** — Ohm's-law division of power by the modelled voltage, with a floor to avoid a divide-by-zero:

```matlab
function Current = fcn(Power, Voltage)

Voltage = max(Voltage, 0.1);
Current = Power / Voltage;
```

> **Note:** The runtime block uses a 96% discharge efficiency and a 320–400 V operating window, while the offline sizing script above uses a 95% discharge efficiency and a 312.5–456.25 V pack window. Both are reasonable engineering approximations, but they aren't the same number — a good candidate for tightening up if the two models are ever meant to match exactly (see [Future Scope](../README.md#-future-scope)).

---

## Related Documentation

| ← Previous | Index | Next → |
|---|---|---|
| [Drive Cycle](Drive_Cycle.md) | [Documentation Home](../README.md) | [Inverter](Inverter.md) |
