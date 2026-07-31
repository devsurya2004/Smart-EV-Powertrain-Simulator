%%=========================================================================
% Motor Characteristics
%
% Project : Smart EV Powertrain Simulator
% Author  : Suryadev
%
% Description:
% Generates the continuous Torque-Speed and Power-Speed
% characteristics of the PMSM traction motor.
%
%==========================================================================

clear

[EV, scriptFolder, projectRoot] = Initialize_Project();

loadedData = load(fullfile(projectRoot,'Data','Motor_Calculations.mat'),'EV');

EV = loadedData.EV;

%%=========================================================================
% Motor Speed Vector
%==========================================================================

MotorSpeedRPM = linspace(0,EV.Motor.MaximumSpeedRPM,500);

MotorSpeedRadPerSec = MotorSpeedRPM * 2 * pi / 60;

%%=========================================================================
% Continuous Torque-Speed Characteristics
%==========================================================================

MotorTorqueNm = zeros(size(MotorSpeedRPM));

for k = 1:length(MotorSpeedRPM)

    if MotorSpeedRPM(k) <= EV.Motor.BaseSpeedRPM

        % Constant Torque Region
        MotorTorqueNm(k) = EV.Motor.RatedTorque;

    else

        % Constant Power Region
        MotorTorqueNm(k) = ...
            EV.Motor.RatedPower / MotorSpeedRadPerSec(k);

    end

end

%%=========================================================================
% Power-Speed Characteristics
%==========================================================================

MotorPowerW = MotorTorqueNm .* MotorSpeedRadPerSec;

MotorPowerkW = MotorPowerW / 1000;

%%=========================================================================
% Store Characteristics
%==========================================================================

EV.Characteristics.Motor.SpeedRPM = MotorSpeedRPM;

EV.Characteristics.Motor.TorqueNm = MotorTorqueNm;

EV.Characteristics.Motor.PowerW = MotorPowerW;

EV.Characteristics.Motor.PowerkW = MotorPowerkW;
%%=========================================================================
% Torque-Speed Plot
%=========================================================================

figure('Name','Motor Torque-Speed Characteristic');

plot(MotorSpeedRPM, MotorTorqueNm, ...
    'LineWidth',2);

hold on

% Base Speed Marker
xline(EV.Motor.BaseSpeedRPM,'--r','Base Speed',...
    'LineWidth',1.5,...
    'LabelVerticalAlignment','bottom');

grid on
box on

xlabel('Motor Speed (RPM)','FontSize',11)
ylabel('Torque (Nm)','FontSize',11)

title('Continuous Motor Torque-Speed Characteristic')

legend('Continuous Torque','Location','northeast')

xlim([0 EV.Motor.MaximumSpeedRPM])
ylim([0 max(MotorTorqueNm)*1.15])

text(1800,...
    EV.Motor.RatedTorque+5,...
    'Constant Torque Region',...
    'HorizontalAlignment','center');

text(9000,...
    130,...
    'Constant Power Region',...
    'HorizontalAlignment','center');

%%=========================================================================
% Power-Speed Plot
%=========================================================================

figure('Name','Motor Power-Speed Characteristic');

plot(MotorSpeedRPM, MotorPowerkW,...
    'LineWidth',2);

hold on

xline(EV.Motor.BaseSpeedRPM,'--r','Base Speed',...
    'LineWidth',1.5,...
    'LabelVerticalAlignment','bottom');

grid on
box on

xlabel('Motor Speed (RPM)','FontSize',11)
ylabel('Power (kW)','FontSize',11)

title('Continuous Motor Power-Speed Characteristic')

legend('Continuous Power','Location','southeast')

xlim([0 EV.Motor.MaximumSpeedRPM])
ylim([0 EV.Motor.RatedPower/1000*1.15])

text(2600,...
    55,...
    'Increasing Power',...
    'HorizontalAlignment','center');

text(9300,...
    EV.Motor.RatedPower/1000+5,...
    'Constant Power',...
    'HorizontalAlignment','center');
%%=========================================================================
% Save Figures
%=========================================================================

resultsFolder = fullfile(projectRoot,'Results');

if ~exist(resultsFolder,'dir')
    mkdir(resultsFolder);
end

exportgraphics(figure(1),...
    fullfile(resultsFolder,'Motor_Torque_Speed.png'),...
    'Resolution',300);

exportgraphics(figure(2),...
    fullfile(resultsFolder,'Motor_Power_Speed.png'),...
    'Resolution',300);

%%=========================================================================
% Display Summary
%==========================================================================

fprintf('\n');
fprintf('========== Motor Characteristics ==========\n');

fprintf('Rated Power        : %.2f kW\n', ...
    EV.Motor.RatedPower/1000);

fprintf('Peak Power         : %.2f kW\n', ...
    EV.Motor.PeakPower/1000);

fprintf('Rated Torque       : %.2f Nm\n', ...
    EV.Motor.RatedTorque);

fprintf('Peak Torque        : %.2f Nm\n', ...
    EV.Motor.PeakTorque);

fprintf('Base Speed         : %.0f RPM\n', ...
    EV.Motor.BaseSpeedRPM);

fprintf('Maximum Speed      : %.0f RPM\n', ...
    EV.Motor.MaximumSpeedRPM);

fprintf('===========================================\n');

%%=========================================================================
% Save Results
%==========================================================================

save(fullfile(projectRoot,'Data','Motor_Characteristics.mat'),'EV');