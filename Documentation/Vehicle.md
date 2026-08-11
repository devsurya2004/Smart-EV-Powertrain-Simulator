# 🚘 Vehicle Model

## 1. Overview

The Vehicle model is the starting point of the entire Smart EV Powertrain Simulator. Before a single cell or motor parameter is chosen, `Scripts/Vehicle.m` works out the physical forces a "compact electric SUV" (SEV-01) needs to overcome — rolling resistance, aerodynamic drag, and the extra force needed to accelerate — and turns those into the power figures every other subsystem is sized against.

Later, once the battery, inverter, motor and transmission have all been designed, `Scripts/Vehicle_Dynamics.m` runs the numbers **forward** through the finished powertrain to check that what actually reaches the wheels is consistent with what the vehicle needs. This document covers both halves: the upfront sizing calculation and the downstream validation.

---

## 2. Reference Vehicle Specifications

| Parameter | Value |
|---|---:|
| Vehicle Type | Compact Electric SUV |
| Vehicle Mass | 1,650 kg |
| Drive Configuration | Front Wheel Drive |
| Top Speed | 150 km/h (41.67 m/s) |
| 0–100 km/h Target | 9.5 s |
| Frontal Area | 2.40 m² |
| Drag Coefficient | 0.30 |
| Rolling Resistance Coefficient | 0.010 |
| Wheel Radius | 0.34 m |

---

## Part A — Vehicle Force and Power Sizing (`Vehicle.m`)

### A.1 Rolling Resistance Force

$$
F_{roll} = C_{rr} \cdot m \cdot g
$$

```matlab
EV.Calculated.RollingResistanceForce = ...
    EV.Vehicle.RollingResistanceCoeff * EV.Vehicle.Mass * EV.Environment.Gravity;
```

0.010 × 1,650 kg × 9.81 m/s² = **161.87 N**, constant regardless of speed.

### A.2 Aerodynamic Drag Force

Evaluated at the vehicle's top speed, since that's the worst case for drag:

$$
F_{drag} = \tfrac{1}{2} \rho \, C_d \, A \, v_{top}^2
$$

```matlab
EV.Calculated.AerodynamicDragForce = ...
    0.5 * EV.Environment.AirDensity * EV.Vehicle.DragCoefficient * ...
    EV.Vehicle.FrontalArea * EV.Requirements.TopSpeed^2;
```

0.5 × 1.225 × 0.30 × 2.40 × 41.67² = **765.62 N** at 150 km/h.

### A.3 Total Resistance and Required Cruising Power

```matlab
EV.Calculated.TotalResistanceForce = ...
    EV.Calculated.RollingResistanceForce + EV.Calculated.AerodynamicDragForce;

EV.Calculated.RequiredMotorPower = ...
    EV.Calculated.TotalResistanceForce * EV.Requirements.TopSpeed;
```

927.49 N total resistance at top speed requires **38.65 kW** just to hold 150 km/h on a level road.

### A.4 Acceleration Performance

```matlab
TargetSpeed = EV.Requirements.AccelerationTargetSpeed;      % 100 km/h in m/s
AccelerationTime = EV.Requirements.ZeroToHundredTime;        % 9.5 s

EV.Calculated.Acceleration = TargetSpeed / AccelerationTime;
EV.Calculated.AccelerationForce = EV.Vehicle.Mass * EV.Calculated.Acceleration;

EV.Calculated.TotalTractiveForce = ...
    EV.Calculated.RollingResistanceForce + ...
    EV.Calculated.AerodynamicDragForce + ...
    EV.Calculated.AccelerationForce;

EV.Calculated.PeakMechanicalPower = EV.Calculated.TotalTractiveForce * TargetSpeed;
```

27.78 m/s ÷ 9.5 s = **2.92 m/s²** average acceleration to hit the 0–100 km/h target, requiring **4,824.56 N** of pure acceleration force on top of the resistance forces above.

### A.5 Sizing Results

| Result | Value |
|---|---:|
| Rolling Resistance Force | 161.87 N |
| Aerodynamic Drag Force | 765.62 N |
| Total Resistance Force | 927.49 N |
| Required Cruising Motor Power | 38.65 kW |
| Target Acceleration | 2.92 m/s² |
| Acceleration Force | 4,824.56 N |
| Total Tractive Force | 5,752.05 N |
| Peak Mechanical Power | 159.78 kW |

That 159.78 kW peak mechanical power figure is why the motor is specified with a **160 kW peak power** rating in [Motor.md](Motor.md#2-motor-specifications) — the sizing calculation and the chosen motor line up almost exactly.

---

## Part B — Vehicle Dynamics Validation (`Vehicle_Dynamics.m`)

Once the [Battery](Battery.md), [Inverter](Inverter.md), [Motor](Motor.md) and [Transmission](Transmission.md) are all designed, `Vehicle_Dynamics.m` works the chain in the opposite direction — starting from the transmission's actual torque output and checking that it still produces the tractive force and acceleration the vehicle needs.

### B.1 Tractive Force at the Wheel

```matlab
EV.VehicleDynamics.Calculated.Forces.TractiveN = ...
    EV.Transmission.Calculated.Output.TorqueNm / EV.Vehicle.WheelRadius;
```

1,954.89 Nm ÷ 0.34 m = **5,749.69 N** — within 0.04% of the 5,752.05 N the Part A sizing calculation called for, confirming the powertrain chain (motor → transmission → wheel) delivers what the vehicle actually needs.

### B.2 Net Force and Resulting Acceleration

```matlab
EV.VehicleDynamics.Calculated.Forces.NetForceN = ...
    EV.VehicleDynamics.Calculated.Forces.TractiveN - ...
    EV.VehicleDynamics.Calculated.Forces.RollingResistanceN - ...
    EV.VehicleDynamics.Calculated.Forces.AerodynamicDragN;

EV.VehicleDynamics.Calculated.Performance.Acceleration = ...
    EV.VehicleDynamics.Calculated.Forces.NetForceN / EV.Vehicle.Mass;
```

4,822.20 N net force ÷ 1,650 kg = **2.9225 m/s²** — matching the 2.9240 m/s² target from Part A to within 0.05%.

### B.3 Wheel Power and Power-to-Weight Ratio

```matlab
WheelPower = EV.VehicleDynamics.Calculated.Forces.TractiveN * EV.Requirements.TopSpeed;
EV.VehicleDynamics.Calculated.Performance.WheelPowerkW = WheelPower / 1000;

VehicleMassTon = EV.Vehicle.Mass / 1000;
EV.VehicleDynamics.Calculated.Performance.PowerToWeightkWPerTon = ...
    EV.Motor.PeakPower / 1000 / VehicleMassTon;
```

### B.4 Validation

```matlab
ValidationStatus = "PASS";
if EV.VehicleDynamics.Calculated.Forces.NetForceN <= 0
    ValidationStatus = "FAIL";
end
```

### B.5 Dynamics Results

| Result | Value |
|---|---:|
| Tractive Force | 5,749.69 N |
| Rolling Resistance | 161.87 N |
| Aerodynamic Drag | 765.62 N |
| Net Force | 4,822.20 N |
| Resulting Acceleration | 2.9225 m/s² |
| Wheel Power | 239.57 kW |
| Power-to-Weight Ratio | 96.97 kW/ton |
| Validation | PASS |

A power-to-weight ratio just under 97 kW/ton is comfortably in hot-hatch territory — consistent with the 9.5 s 0–100 km/h target the vehicle was sized around.

---

## 6. Simulink Runtime Model

The `Vehicle Dynamics` subsystem inside `Models/Smart_EV_Powertrain.slx` (`system_10`) computes the same resistance forces continuously during simulation, using MATLAB Function blocks whose hard-coded constants match the vehicle specification table above exactly — unlike the Motor and Inverter blocks, there's no drift here between design-time and run-time values.

**Aerodynamic drag**, evaluated at the *instantaneous* vehicle speed rather than just top speed:

```matlab
function Drag = fcn(v)

rho = 1.225;
Cd  = 0.30;
A   = 2.40;

Drag = 0.5 * rho * Cd * A * v * abs(v);
```

**Rolling resistance**, with a small dead-band so the vehicle doesn't fight a resistance force while truly stationary:

```matlab
function Fr = fcn(v)

m = 1650;
g = 9.81;
Cr = 0.01;

if abs(v) < 0.05
    Fr = 0;
else
    Fr = Cr * m * g * sign(v);
end
```

**Hydraulic brake force**, applied on top of motor regen when the driver commands braking:

```matlab
function Fbrake = fcn(brake, v)

MaxBrakeForce = 10000;   % Newton

if abs(v) < 0.2
    Fbrake = 0;
else
    Fbrake = brake * MaxBrakeForce;
end
```

These three forces, together with the transmission's tractive force, feed a `Sum` block whose output is integrated twice (via two `Integrator` blocks) to produce vehicle speed and then vehicle distance — the same net-force-to-acceleration relationship as §B.2, but evaluated continuously rather than at a single operating point.

---

## Related Documentation

| ← Previous | Index | Next → |
|---|---|---|
| [Transmission](Transmission.md) | [Documentation Home](../README.md) | [Drive Cycle](Drive_Cycle.md) |
