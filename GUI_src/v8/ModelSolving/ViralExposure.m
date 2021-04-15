function ViralExposure(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 21Mar2021
%% ---------------------
%% Function Information
% This function is used to set the initial dose of virus that the person is
% exposed to. Simbiology can use dosing to add a spike of a component at
% some amount of time. This funciton will either make a new dose, or add a
% dose with a specified initial amount, and at a specific time into the
% simulation.

%% Set the amount present initially in the body
app.Model.Species(1).InitialAmount = app.VirusInBodyBeforeExposureEditField.Value;

%% Define the exposure to the virus

%%
try 
    exposure = adddose(app.Model, 'Exposure', 'schedule');
catch
    exposure = getdose(app.Model, 'Exposure');
end

exposure.Amount = app.ViralDoseExposureEditField.Value;
exposure.Time = app.TimeofViralExposureEditField.Value;
exposure.TargetName = 'Covid';
exposure.Active = true;

app.ExposureProperties = get(exposure);


% Update the Model Update Window
app.ModelSolvingUpdate.Value = " ";
app.ModelSolvingUpdate.FontColor = [1,0.77,0.06];
app.ModelSolvingUpdate.Value = "Model Solution Outdated";

end %function