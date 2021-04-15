function BuildDefaultModel(app)
%% %% Modify only changed parameters in the table
% Last Edit: Stuart McKnight on 24Mar2021
%% ---------------------
% This function sets up the default model for the user.

% Define the Model
app.Model = sbioloadproject("Models/Default Model/Default_Model.sbproj").m1; % Description
app.Default_Model_Info.Value = string(app.Model.Name);
disp('Default Model Updated')

%% Since we have hard coded our default model, this does not have to be run

% Set the parameter Spreadsheet
%app.UpdateParameterUnitsCheckBox.Value = 0; %

% Set the Species Spreadsheet
%app.UpdateSpeciesUnitsCheckBox.Value = 0; % 

% Run the functions that update the parameters and the species spreadsheets
%ParameterModification_Default(app)
%SpeciesModification_Default(app)

uiwait(msgbox('Default Model, Parameters, and Species have been imported. Continue to the "Solving the Model" tab','Success: Default Imported','help','modal'))
figure(app.SARSCoV2ModelUIFigure)
end %function