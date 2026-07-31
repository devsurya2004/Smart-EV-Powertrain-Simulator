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
% BATTERY
%==========================================================================

EV.Battery.Type                        = "Lithium-Ion";

EV.Battery.NominalVoltage              = [];          % V

EV.Battery.Capacity                    = [];          % kWh

EV.Battery.CellVoltage                 = [];          % V

EV.Battery.CellCapacity_Ah             = [];          % Ah

EV.Battery.SeriesCells                 = [];

EV.Battery.ParallelCells               = [];

EV.Battery.InternalResistance          = [];          % Ohm

EV.Battery.InitialSOC                  = 100;         % %

EV.Battery.MinimumSOC                  = 20;          % %

EV.Battery.MaximumSOC                  = 100;         % %

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
% TRANSMISSION
%==========================================================================

EV.Transmission.Type                   = "Single Speed";

EV.Transmission.GearRatio              = 10.25;

EV.Transmission.Efficiency             = 0.97;

%%=========================================================================
% INVERTER
%==========================================================================

EV.Inverter.SwitchingFrequency         = [];          % Hz

EV.Inverter.Efficiency                 = 0.98;

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