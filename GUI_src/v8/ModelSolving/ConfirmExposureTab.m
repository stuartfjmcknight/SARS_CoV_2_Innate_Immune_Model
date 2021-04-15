function ConfirmExposureTab(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 21Mar2021
%% ---------------------
%% This function will be used to define the features of the exposure which will be used when solving the model

% Initial Virus in Body
app.ConfirmVirusInBodyEditField.Value = sprintf('%s molar',num2str(app.Model.Species(1).InitialAmount));

% Viral Dose Amount
app.ConfirmViralDoseAmountEditField.Value = sprintf('%s SARS-CoV-2 Cells',num2str(app.ExposureProperties.Amount));

% Time of Exposure
app.ConfirmTimeOfExposureEditField.Value = sprintf('%s %s',num2str(app.ExposureProperties.Time),app.TimeUnits);

% Confirm Target Species
app.ConfirmTargetSpeciesEditField.Value = app.ExposureProperties.TargetName;


end