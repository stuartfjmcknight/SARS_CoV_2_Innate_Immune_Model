function ConfirmSolverTab(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 21Mar2021
%% ---------------------
%% This function is used to populate the entires to the confirmation window on the "Solving the Model" tab. 

% Confirm the stoptime
app.ConfirmStopTimeEditField.Value = sprintf('%s %s',num2str(app.SolverProperties.StopTime),app.TimeUnits);

% Confirm the Solver Type
app.ConfirmSolverTypeEditField.Value = app.SolverProperties.SolverType;

% Confirm Wall Clock 
if app.SolverProperties.MaximumWallClock == Inf
    str_wallclock = "No Stop Time (Infinity)";
else
    str_wallclock = sprintf('%s seconds', string(app.SolverProperties.MaximumWallClock));
end
app.ConfirmWallClockEditField.Value = str_wallclock;

% Confirm the Absolute Tolerance Value
app.ConfirmAbsoluteToleranceEditField.Value = num2str(app.SolverProperties.SolverOptions.AbsoluteTolerance);

% Confirm Absolute Tolerance Scaling
ScalingBool = app.SolverProperties.SolverOptions.AbsoluteToleranceScaling;
if ScalingBool
    app.ConfirmAbsoluteToleranceScalingEditField.Value = "On";
else
    app.ConfirmAbsoluteToleranceScalingEditField.Value = "Off";
end

% Confirm Relative Tolerance
app.ConfirmRelativeToleranceEditField.Value = num2str(app.SolverProperties.SolverOptions.RelativeTolerance);

% Confirm Absolute Tolerance Scaling
SensitivityBool = app.SolverProperties.SolverOptions.SensitivityAnalysis;
if SensitivityBool
    app.ConfirmSensitivityAnalysisEditField.Value = "On";
else
    app.ConfirmSensitivityAnalysisEditField.Value = "Off";
end





end