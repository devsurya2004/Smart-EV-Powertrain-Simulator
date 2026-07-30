%%=========================================================================
% Smart EV Powertrain Simulator
%
% Project    : SEV-01
% Version    : 2.0
% Author     : Suryadev
%
% Description:
% Master configuration file for the Smart EV Powertrain Simulator.
% All project parameters are defined here.
%
%==========================================================================

%%=========================================================================
% VEHICLE REQUIREMENTS
%==========================================================================

EV.Requirements.VehicleName            = "SEV-01";
EV.Requirements.VehicleType            = "Compact Electric SUV";

EV.Requirements.TopSpeed_kmh           = 150;
EV.Requirements.TopSpeed               = EV.Requirements.TopSpeed_kmh/3.6;

EV.Requirements.Acceleration0_100      = 9.5;     % seconds

EV.Requirements.PassengerCapacity      = 5;

EV.Requirements.DriveConfiguration     = "Front Wheel Drive";

EV.Requirements.BatteryVoltage         = 400;     % V

EV.Requirements.BatteryCapacity        = 45;      % kWh

EV.Requirements.DriveCycle             = "FTP75";

%%=========================================================================
% VEHICLE
%==========================================================================

EV.Vehicle.Mass                        = 1650;    % kg

EV.Vehicle.DragCoefficient             = 0.30;

EV.Vehicle.FrontalArea                 = 2.40;    % m^2

EV.Vehicle.RollingResistanceCoeff      = 0.010;

EV.Vehicle.WheelRadius                 = 0.34;    % m

%%=========================================================================
% BATTERY
%==========================================================================

EV.Battery.Type                        = "Lithium-Ion";

EV.Battery.NominalVoltage              = [];
EV.Battery.Capacity                    = [];

EV.Battery.CellVoltage                 = [];
EV.Battery.CellCapacity_Ah             = [];

EV.Battery.SeriesCells                 = [];
EV.Battery.ParallelCells               = [];

EV.Battery.InternalResistance          = [];

EV.Battery.InitialSOC                  = 100;     % %

EV.Battery.MinimumSOC                  = 20;      % %

EV.Battery.MaximumSOC                  = 100;     % %

%%=========================================================================
% MOTOR
%==========================================================================

EV.Motor.Type                          = "PMSM";

EV.Motor.RatedPower                    = [];      % W

EV.Motor.PeakPower                     = [];      % W

EV.Motor.RatedTorque                   = [];      % N.m

EV.Motor.PeakTorque                    = [];      % N.m

EV.Motor.BaseSpeed                     = [];      % rpm

EV.Motor.MaximumSpeed                  = [];      % rpm

EV.Motor.MaximumEfficiency             = [];      % %

%%=========================================================================
% TRANSMISSION
%==========================================================================

EV.Transmission.Type                   = "Single Speed";

EV.Transmission.GearRatio              = [];

EV.Transmission.Efficiency             = 0.97;

%%=========================================================================
% INVERTER
%==========================================================================

EV.Inverter.SwitchingFrequency         = [];

EV.Inverter.Efficiency                 = 0.98;

%%=========================================================================
% DRIVER
%==========================================================================

EV.Driver.MaximumThrottle              = 100;     % %

EV.Driver.MaximumBrake                 = 100;     % %

%%=========================================================================
% ENVIRONMENT
%==========================================================================

EV.Environment.Gravity                 = 9.81;    % m/s^2

EV.Environment.AirDensity              = 1.225;   % kg/m^3

%%=========================================================================
% CALCULATED PARAMETERS
%==========================================================================

EV.Calculated.RollingResistanceForce   = [];      % N

EV.Calculated.AerodynamicDragForce     = [];      % N

EV.Calculated.TotalResistanceForce     = [];      % N

EV.Calculated.RequiredMotorPower       = [];      % W

EV.Calculated.RequiredMotorTorque      = [];      % N.m

EV.Calculated.RequiredGearRatio        = [];

EV.Calculated.EstimatedRange           = [];      % km

%%=========================================================================
% SIMULATION
%==========================================================================

EV.Simulation.SampleTime               = 1e-4;    % s

EV.Simulation.StopTime                 = 100;     % s

EV.Simulation.Solver                   = "ode23t";

EV.Vehicle.WheelRadius = 0.32;      % m

