function DefaultSolverSetup(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 21Mar2021
%% ---------------------
%% Function Info
% This function is used to set the solver configuration which will be used
% to solve the simulation. This function allows the user to modify:
%  1) Model Solver Type
%  2) Solver Stop Time
%  3) Solver Options
% The function then solves the options which are called in when the
% simulation is run. 
%% Load in the model solver configuration
csObj = app.SolverProperties;

try
    csObj = addconfigset(app.Model, 'cs1');
catch
    %delete(csObj)
    csObj = getconfigset(app.Model, 'cs1');
    %csObj = addconfigset(app.Model, 'cs1');
end

%% Model Solver
%csObj.SolverType = 'ode15s';
csObj.SolverType = 'sundials';


%% Model Stop Time
csObj.StopTime = app.StopTimeEditFieldDefault.Value;

%% Solver Options
%Absolute Tolerance
csObj.SolverOptions.AbsoluteTolerance = 1e-06;

%Absolute Tolerance Scaling
csObj.SolverOptions.AbsoluteToleranceScaling = true;

%Relative Tolerance 
csObj.SolverOptions.RelativeTolerance = 1e-3;

%Sensitivity Analysis
csObj.SolverOptions.SensitivityAnalysis = false;

%% Run Time Options
csObj.RuntimeOptions.StatesToLog = 'all';

app.SolverProperties = csObj;
app.SolverProperties

%% Update Default Time of Exposure
app.TimeofViralExposureEditField.Value = app.StopTimeEditFieldDefault.Value / 25;
app.XMaxSlider.Limits = [0, app.StopTimeEditFieldDefault.Value];
app.XMaxSlider.Limits = [0, app.StopTimeEditFieldDefault.Value];
app.XMaxSlider.Value = app.StopTimeEditFieldDefault.Value;

% Change Slider Limits on Plotting Tab
app.XMinSpeciesPlot.Limits = [0, app.StopTimeEditFieldAdvanced.Value];
app.XMaxSpeciesPlot.Limits = [0, app.StopTimeEditFieldAdvanced.Value];

% Update the Model Update Window
app.ModelSolvingUpdate.Value = " ";
app.ModelSolvingUpdate.FontColor = [1,0.77,0.06];
app.ModelSolvingUpdate.Value = "Model Solution Outdated";
end %end to function
