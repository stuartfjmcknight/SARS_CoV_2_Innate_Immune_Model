function AdvancedSolverSetup(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 21Mar2021
%% ---------------------
%% Function Info
% This function is used to set the solver configuration defined by the user
% which will be used to solve the simulation. This function allows the user
% to modify:
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
csObj.SolverType = app.SolverTypeDropDown.Value;

%% Model Stop Time
csObj.StopTime = app.StopTimeEditFieldAdvanced.Value;

%% WallClock Stop Time
csObj.MaximumWallClock = app.WallClockEditField.Value;

%% Solver Options


%Absolute Tolerance
csObj.SolverOptions.AbsoluteTolerance = app.AbsoluteToleranceEditField.Value;
%Absolute Tolerance Scaling
if string(app.AbsoluteToleranceSclaingDropDown.Value) == "Off"
    csObj.SolverOptions.AbsoluteToleranceScaling = false;
elseif string(app.AbsoluteToleranceSclaingDropDown.Value) == "On"
    csObj.SolverOptions.AbsoluteToleranceScaling = true;
else
    warning('error in defining the tolerance scaling option')
end
%Relative Tolerance
csObj.SolverOptions.RelativeTolerance = app.RelativeToleranceEditField.Value;

%Sensitivity Analysis
if string(app.SensitivityAnalysisDropDown.Value) == "Off"
    csObj.SolverOptions.SensitivityAnalysis = false;
elseif string(app.SensitivityAnalysisDropDown.Value) == "On"
    csObj.SolverOptions.SensitivityAnalysis = true;
else
    warning('error in defining whether to perform a sensitivity analysis')
end



%% Run Time Options
csObj.RuntimeOptions.StatesToLog = 'all';

% %% Unit Conversion
% if string(app.UnitConversionDropDown.Value) == "Off"
%     csObj.CompileOptions.UnitConversion = false;
% elseif string(app.UnitConversionDropDown.Value) == "On"
%     csObj.CompileOptions.UnitConversion = true;
% else
%     warning('error in defining the unit conversion option')
% end
%
% %% Dimensional Analysis
% if string(app.DimensionalAnalysisDropDown.Value) == "Off"
%     csObj.CompileOptions.DimensionalAnalysis = false;
% elseif string(app.DimensionalAnalysisDropDown.Value) == "On"
%     csObj.CompileOptions.DimensionalAnalysis = true;
% else
%     warning('error in defining the dimensional analysis option')
% end

app.SolverProperties = csObj;
app.SolverProperties

%% Update Default Time of Exposure
app.TimeofViralExposureEditField.Value = app.StopTimeEditFieldAdvanced.Value / 25;
app.XMaxSlider.Limits = [0, app.StopTimeEditFieldAdvanced.Value];
app.XMaxSlider.Limits = [0, app.StopTimeEditFieldAdvanced.Value];
app.XMaxSlider.Value = app.StopTimeEditFieldAdvanced.Value;

% Change Slider Limits on Plotting Tab
app.XMinSpeciesPlot.Limits = [0, app.StopTimeEditFieldAdvanced.Value];
app.XMaxSpeciesPlot.Limits = [0, app.StopTimeEditFieldAdvanced.Value];

% Update the Model Update Window
app.ModelSolvingUpdate.Value = " ";
app.ModelSolvingUpdate.FontColor = [1,0.77,0.06];
app.ModelSolvingUpdate.Value = "Model Solution Outdated";

end %end to function
