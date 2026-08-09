# Driver Controller

## 1. Overview

The Driver Controller is responsible for converting the difference between the desired vehicle speed and actual vehicle speed into throttle and brake commands.

The controller is implemented as a Simulink subsystem rather than a separate MATLAB script.

The Driver Controller receives:

- Desired Speed
- Actual Speed

and produces:

- Throttle
- Brake

The controller is used to regulate the vehicle speed according to the selected drive cycle.

---

## 2. Controller Architecture

The implemented control structure is:

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
  Signal Limiting    │
      │              │
      ▼              │
 Dynamic Response    │
      │              │
      ▼              │
 Throttle Logic ◄────┼──── Actual Speed
      │              │
      ├──────────────┤
      │
      ▼
 Throttle / Brake