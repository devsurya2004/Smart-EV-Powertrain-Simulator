function [EV, scriptFolder, projectRoot] = Initialize_Project()
%%=========================================================================
% Initialize_Project
%
% Project : Smart EV Powertrain Simulator
% Author  : Suryadev
%
% Description:
%   Initializes the Smart EV Powertrain Simulator by:
%       1. Clearing the command window (Desktop MATLAB only)
%       2. Determining project paths
%       3. Verifying required project folders
%       4. Creating output folders if they do not exist
%       5. Loading project parameters
%       6. Exporting commonly used variables to the base workspace
%
% Outputs:
%   EV            - Complete project parameter structure
%   scriptFolder  - Absolute path of the Scripts folder
%   projectRoot   - Absolute path of the project root directory
%
%==========================================================================

%% Clear Command Window
if usejava('desktop')
    clc;
end

%%=========================================================================
% Project Paths
%==========================================================================

scriptFolder = fileparts(mfilename('fullpath'));
projectRoot  = fileparts(scriptFolder);

%%=========================================================================
% Verify Required Project Folders
%==========================================================================

requiredFolders = { ...
    'Scripts', ...
    'Models', ...
    'Documentation'};

for k = 1:numel(requiredFolders)

    folderPath = fullfile(projectRoot, requiredFolders{k});

    if ~exist(folderPath,'dir')
        error('Required project folder not found: %s', requiredFolders{k});
    end

end

%%=========================================================================
% Create Output Folders (if missing)
%==========================================================================

outputFolders = { ...
    'Data', ...
    'Results'};

for k = 1:numel(outputFolders)

    folderPath = fullfile(projectRoot, outputFolders{k});

    if ~exist(folderPath,'dir')
        mkdir(folderPath);
    end

end

%%=========================================================================
% Load Project Parameters
%==========================================================================

parameterFile = fullfile(scriptFolder,'Project_Parameters.m');

if ~isfile(parameterFile)
    error('Project_Parameters.m not found in Scripts folder.');
end

run(parameterFile);

%%=========================================================================
% Export Variables to Base Workspace
%==========================================================================

assignin('base','EV',EV);
assignin('base','projectRoot',projectRoot);
assignin('base','scriptFolder',scriptFolder);

%%=========================================================================
% Initialization Complete
%==========================================================================

fprintf('\n');
fprintf('===============================================\n');
fprintf(' Smart EV Powertrain Simulator Initialized\n');
fprintf('===============================================\n');
fprintf(' Project Root : %s\n', projectRoot);
fprintf(' Scripts Path : %s\n', scriptFolder);
fprintf(' Status       : Initialization Successful\n');
fprintf('===============================================\n\n');

end