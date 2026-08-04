%%=========================================================================
% Smart EV Powertrain Simulator
%
% Project    : SEV-01
% Version    : 1.0
% Author     : Suryadev
%
% Description:
% Master configuration file for the Smart EV Powertrain Simulator.
% All project design parameters are defined here.
%
%==========================================================================

%%=========================================================================
% VEHICLE REQUIREMENTS
%==========================================================================

EV.Requirements.VehicleName            = "SEV-01";
EV.Requirements.VehicleType            = "Compact Electric SUV";

EV.Requirements.TopSpeed_kmh           = 150;         % km/h
EV.Requirements.TopSpeed               = EV.Requirements.TopSpeed_kmh/3.6; % m/s

EV.Requirements.Acceleration0_100      = 9.5;         % s

EV.Requirements.PassengerCapacity      = 5;

EV.Requirements.DriveConfiguration     = "Front Wheel Drive";

EV.Requirements.BatteryVoltage         = 400;         % V

EV.Requirements.BatteryCapacity        = 45;          % kWh

EV.Requirements.DriveCycle             = "FTP75";

%%=========================================================================
% VEHICLE
%==========================================================================

EV.Vehicle.Mass                        = 1650;        % kg

EV.Vehicle.DragCoefficient             = 0.30;

EV.Vehicle.FrontalArea                 = 2.40;        % m^2

EV.Vehicle.RollingResistanceCoeff      = 0.010;

EV.Vehicle.WheelRadius                 = 0.34;        % m


%%=========================================================================
% MOTOR
%==========================================================================

EV.Motor.Type                          = "PMSM";

EV.Motor.RatedPower                    = 105e3;       % W

EV.Motor.PeakPower                     = 160e3;       % W

EV.Motor.RatedTorque                   = [];          % Nm (Calculated)

EV.Motor.PeakTorque                    = 196.62;      % Nm

EV.Motor.BaseSpeedRPM                  = 6000;        % rpm

EV.Motor.MaximumSpeedRPM               = 12000;       % rpm

EV.Motor.MaximumEfficiency             = 0.96;        % -

%%=========================================================================
% Battery Parameters
%==========================================================================

% Battery Pack Specifications
EV.Battery.TargetPackVoltage     = 400;        % V
EV.Battery.TargetPackEnergykWh   = 45;         % kWh
EV.Battery.TargetPackEnergyWh    = EV.Battery.TargetPackEnergykWh * 1000;

%%=========================================================================
% Battery Cell Specifications (LFP 32700 Cell)
%%=========================================================================

EV.Battery.Cell.Chemistry        = "Lithium Iron Phosphate (LFP)";
EV.Battery.Cell.FormFactor       = "32700 Cylindrical";

EV.Battery.Cell.NominalVoltage   = 3.2;        % V
EV.Battery.Cell.MaximumVoltage   = 3.65;       % V
EV.Battery.Cell.MinimumVoltage   = 2.50;       % V

EV.Battery.Cell.CapacityAh       = 6.0;        % Ah
EV.Battery.Cell.EnergyWh         = ...
    EV.Battery.Cell.NominalVoltage * ...
    EV.Battery.Cell.CapacityAh;

EV.Battery.Cell.ContinuousCurrent = 18;        % A
EV.Battery.Cell.PeakCurrent       = 30;        % A

EV.Battery.Cell.InternalResistance = 0.006;    % Ohm
EV.Battery.Cell.Mass              = 0.145;     % kg

%%=========================================================================
% Calculated Battery Parameters
%==========================================================================

% Cell Configuration
EV.Battery.Calculated.Cells.Series      = [];
EV.Battery.Calculated.Cells.Parallel    = [];
EV.Battery.Calculated.Cells.Total       = [];

% Pack Voltage
EV.Battery.Calculated.Voltage.Nominal   = [];
EV.Battery.Calculated.Voltage.Maximum   = [];
EV.Battery.Calculated.Voltage.Minimum   = [];

% Pack Capacity
EV.Battery.Calculated.Capacity.Ah       = [];

% Pack Energy
EV.Battery.Calculated.Energy.Wh         = [];
EV.Battery.Calculated.Energy.kWh        = [];

% Pack Current
EV.Battery.Calculated.Current.Continuous = [];
EV.Battery.Calculated.Current.Peak    = [];

% Pack Mass
EV.Battery.Calculated.Mass.Total        = [];
%%=========================================================================
% TRANSMISSION
%==========================================================================

EV.Transmission.Type                   = "Single Speed";

EV.Transmission.GearRatio              = 10.25;

EV.Transmission.Efficiency             = 0.97;

%%=========================================================================
% INVERTER
%==========================================================================

EV.Inverter.Type = "Three-Phase Voltage Source Inverter";

EV.Inverter.Topology = "Two-Level";

EV.Inverter.SwitchingFrequency = 10000;      % Hz

EV.Inverter.Efficiency = 0.98;

EV.Inverter.ModulationIndex = 0.95;
%%=========================================================================
% Regenerative Braking Parameters
%==========================================================================

EV.Regeneration.Efficiency = 0.75;

EV.Regeneration.MaxPowerkW = 80;

EV.Regeneration.MinSpeedkmh = 10;

%%=========================================================================
% DRIVER
%==========================================================================

EV.Driver.MaximumThrottle              = 100;         % %

EV.Driver.MaximumBrake                 = 100;         % %

%%=========================================================================
% ENVIRONMENT
%==========================================================================

EV.Environment.Gravity                 = 9.81;        % m/s^2

EV.Environment.AirDensity              = 1.225;       % kg/m^3

%%=========================================================================
% CALCULATED PARAMETERS
%==========================================================================

EV.Calculated.RollingResistanceForce   = [];          % N

EV.Calculated.AerodynamicDragForce     = [];          % N

EV.Calculated.TotalResistanceForce     = [];          % N

EV.Calculated.RequiredMotorPower       = [];          % W

EV.Calculated.RequiredMotorTorque      = [];          % Nm

EV.Calculated.RequiredGearRatio        = [];

EV.Calculated.EstimatedRange           = [];          % km

%%=========================================================================
% SIMULATION
%==========================================================================

EV.Simulation.SampleTime               = 1e-4;        % s

EV.Simulation.StopTime                 = 100;         % s

EV.Simulation.Solver                   = "ode23t";
