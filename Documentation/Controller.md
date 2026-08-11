# 🎮 Driver Controller

## 1. Overview

The Driver Controller is responsible for converting the difference between the desired vehicle speed (from the [Drive Cycle](Drive_Cycle.md)) and the actual vehicle speed (fed back from [Vehicle Dynamics](Vehicle.md)) into throttle and brake commands. It's the closed loop at the heart of the whole simulator — everything downstream only moves because this block tells it to.

Unlike the other subsystems, the controller is implemented directly as a Simulink subsystem (`Driver Controller`, inside `Models/Smart_EV_Powertrain.slx`) rather than a MATLAB script, since it needs to run continuously and react to feedback at simulation speed.

The Driver Controller receives:

- Desired Speed
- Actual Speed

and produces:

- Throttle
- Brake

---

## 2. Controller Architecture

```text
Desired Speed
      │
      ├──────────────┐
      │              │
      ▼              │
   (+) Sum           │
      │              │
      ▼              │
   Dead Zone         │
      │              │
      ▼              │
     PID             │
      │              │
      ▼              │
  Saturation         │
      │              │
      ▼              │
 Rate Limiter        │
      │              │
      ▼              │
 Throttle Logic ◄────┼──── Actual Speed
      │              │
      ├──────────────┤
      │
      ▼
 Throttle / Brake
```

Speed error is formed by the `Sum` block, passed through a `Dead Zone` to reject small tracking noise, driven through a `PID` controller, clamped by a `Saturation` block, smoothed by a `Rate Limiter`, and finally split into separate throttle and brake commands by the `Throttle Logic` block — which also looks directly at actual and desired speed to decide when the vehicle should simply be held at a stop.

---

## 3. Block Parameters

Pulled directly from the Simulink model, the tuned values are:

| Block | Parameter | Value |
|---|---|---:|
| Dead Zone | Lower / Upper threshold | ±0.1 |
| PID Controller | Proportional gain (P) | 0.03 |
| PID Controller | Integral gain (I) | 0.001 |
| PID Controller | Derivative gain (D) | 0.001 |
| PID Controller | Derivative filter coefficient (N) | 20 |
| Saturation | Lower / Upper limit | ±1 |
| Rate Limiter | Rising / falling slew rate | ±0.05 per second |

The dead zone means speed errors smaller than 0.1 m/s produce no controller response at all — useful for preventing the throttle from hunting around zero once the vehicle is tracking the drive cycle closely. The rate limiter then keeps the PID's raw output from changing by more than 5% per second, which is what gives the simulated vehicle a smooth, realistic throttle/brake transition rather than a jumpy one.

### 3.1 Throttle Logic

The final stage is a MATLAB Function block that turns the single signed PID output (`u`, ranging −1 to +1) into two independent, always-non-negative throttle and brake signals — and adds a special case to hold the vehicle stationary once both desired and actual speed are effectively zero:

```matlab
function [throttle, brake] = fcn(u, actual_speed, desired_speed)

neutral = 0.02;      % Neutral zone around zero

throttle = 0.03;
brake = 0;

% Vehicle stopped
if desired_speed < 0.1 && actual_speed < 0.1

    throttle = 0;
    brake = 0;

    % Accelerate
elseif u > neutral

    throttle = min(u, 1);
    brake = 0;

    % Brake
elseif u < -neutral

    throttle = 0;
    brake = min(-u, 1);

    % Neutral (no throttle, no brake)
else

    throttle = 0;
    brake = 0;

end
```

A small 0.02-wide neutral band around zero (independent of the upstream 0.1 dead zone) prevents the vehicle from flickering between light throttle and light braking when the controller output sits right around zero — for example, while holding a steady cruise speed.

---

## 4. How It Fits Together

| Stage | Block | Purpose |
|---|---|---|
| 1 | Sum | Computes speed error = desired − actual |
| 2 | Dead Zone | Ignores speed errors under ±0.1 m/s |
| 3 | PID Controller | Converts speed error into a normalised drive/brake demand |
| 4 | Saturation | Clamps the demand to ±1 |
| 5 | Rate Limiter | Limits how fast the demand can change (±0.05/s) |
| 6 | Throttle Logic | Splits the signed demand into separate throttle (0–1) and brake (0–1) commands |

The resulting throttle feeds the [Battery](Battery.md#5-simulink-runtime-model) power-demand block; the brake feeds both the [Motor](Motor.md#5-simulink-runtime-model)'s regenerative torque limit and the [Vehicle](Vehicle.md#6-simulink-runtime-model)'s hydraulic brake force block.

---

## Related Documentation

| ← Previous | Index | Next → |
|---|---|---|
| [Regenerative Braking](Regenerative_Braking.md) | [Documentation Home](../README.md) | [Design Decisions](Design_Decisions.md) |
