# Battery System

## 1. Overview

The battery subsystem is responsible for designing the battery pack required by the Smart EV Powertrain Simulator.

The battery pack is designed from the selected battery cell specifications and the target vehicle requirements defined in the project parameters.

The MATLAB implementation calculates:

- Number of series cells
- Number of parallel cells
- Total number of cells
- Nominal, maximum and minimum pack voltage
- Pack capacity
- Pack energy
- Continuous current capability
- Peak current capability
- Total battery mass
- Voltage and energy design errors

The calculated battery parameters are also saved for use by other modules of the project.

---

## 2. Battery Design Method

The battery pack follows a series-parallel configuration.

### Series Connection

Cells connected in series increase the battery pack voltage.

The required number of series cells is calculated using:

\[
N_s =
\left\lceil
\frac{V_{target}}
{V_{cell,nom}}
\right\rceil
\]

where:

- \(N_s\) = number of series cells
- \(V_{target}\) = target battery pack voltage
- \(V_{cell,nom}\) = nominal voltage of one cell

The MATLAB implementation is:

```matlab
EV.Battery.Calculated.Cells.Series = ceil( ...
    EV.Battery.TargetPackVoltage / ...
    EV.Battery.Cell.NominalVoltage);
## 2. Battery Design Specifications

The Smart EV Powertrain Simulator uses a Lithium Iron Phosphate (LFP) cylindrical cell configuration.

### Vehicle Battery Requirements

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

### Cell Specifications

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
## 3. Calculated Battery Pack Configuration

Based on the target battery voltage and energy requirements, the battery pack calculation produces the following configuration.

| Parameter | Calculated Value |
|---|---:|
| Series Cells | 125 |
| Parallel Cells | 19 |
| Total Cells | 2375 |
| Nominal Pack Voltage | 400 V |
| Maximum Pack Voltage | 456.25 V |
| Minimum Pack Voltage | 312.50 V |
| Pack Capacity | 114 Ah |
| Pack Energy | 45.60 kWh |
| Continuous Pack Current | 342 A |
| Peak Pack Current | 570 A |
| Total Battery Mass | 344.38 kg |

### Battery Configuration

The battery pack can therefore be represented as:

```text
125 cells in series
        ×
19 parallel strings

Configuration: 125S19P

Total cells = 125 × 19 = 2375 cells

Then add:

```markdown
## 4. Battery Design Validation

The calculated battery pack is compared against the project target requirements.

### Voltage Validation

Target pack voltage:

\[
V_{target}=400\ V
\]

Calculated nominal voltage:

\[
V_{nominal}=125\times3.2=400\ V
\]

Therefore:

\[
Voltage\ Error=0\%
\]

The allowable voltage error is 2%.

**Result: PASS**

### Energy Validation

Target pack energy:

\[
E_{target}=45\ kWh
\]

Calculated pack energy:

\[
E_{pack}=400\times114
\]

\[
E_{pack}=45600\ Wh=45.60\ kWh
\]

Therefore:

\[
Energy\ Error=
\frac{|45.60-45|}{45}\times100
\]

\[
Energy\ Error=1.33\%
\]

The allowable energy error is 5%.

**Result: PASS**

### Overall Battery Design Status

| Validation Parameter | Result | Limit | Status |
|---|---:|---:|---|
| Voltage Error | 0.00% | ≤ 2% | PASS |
| Energy Error | 1.33% | ≤ 5% | PASS |

**Overall Status: ✓ PASS**

