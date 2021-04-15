function NewSpeciesSheet(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 12Feb2021
%% ---------------------
% This function is used to do two thigs. 1) It will generate a new
% spreadsheet with the desired filename, which contains all of the species
% in the seleceted model.


%% Define Model
Model = app.Model;
%% File Type
FileName = [app.SpeciesFileNameEditField.Value, app.SpeciesSelectFileTypeDropDown.Value];

%% Run a loop over all of the species in the model
% This will extract the key info from each of the species
for i = 1:length(Model.Species)
    Species_Index(i,1) = string(i); % Extract the species name
    Species_Name(i,1) = " "; % Create a blank which the user can add in the spreadsheet if useful
    Model_Name(i,1) = string(Model.Species(i).Name); % Extract the name of the species
    Initial_Amount(i,1) = string(Model.Species(i).InitialAmount); % Extract the initial amount
    Range(i,1) = " "; % Create a blank for user to include a range
    Units(i,1) = string(Model.Species(i).Units); % Extract the units that go with the initial amount
    % Use logic to assign the type of amount the initial condition is. This
    % is done for both if it is a constant amount and if it is a boundary
    % condition.
    if Model.Species(i).ConstantAmount == 1
        Constant_Amount(i,1) = "True";
    else
        Constant_Amount(i,1) = "False";
    end
    if Model.Species(i).BoundaryCondition == 1
        Boundary_Condition(i,1) = "True";
    else
        Boundary_Condition(i,1) = "False";
    end
    Type(i,1) = string(Model.Species(i).Type); % Extract the type of species
    Compartment_Type(i,1) = string(Model.Species(i).Parent.Type); % Extract the compartment type
    Compartment(i,1) = string(Model.Species(i).Parent.Name); % Exract the compartment where the species lives in
    
end %for loop

T = table(Species_Index,Species_Name,Model_Name,Initial_Amount,Range,Units,Constant_Amount,...
    Boundary_Condition,Type,Compartment_Type,Compartment); % Build the talbe structure which will be transformed into a spreadsheet.

%% Provides logic to prevent overwriting data
% The user will have to confirm that they want to override exising data.
% This is in an effort to prevent the user from creating a new spreadsheet
% which overrides an existing spreadsheet which has values populated in it.
if isfile(['SpeciesParameterConventions/',FileName]) %search for the file name to see if it already exists
    warning('Filename already existis')
    disp('You will override data')
    confirm = input('do you want to override this data? [Y/N]: ','s'); %the file exists, have the user say if they want to override the existing file
    if confirm == 'Y'
        writetable(T,['SpeciesParameterConventions/',FileName]) % create the excel spreadsheet
        fprintf('File generated with name: %s\n',FileName)
    elseif confirm == 'N'
        disp("Close call - Existing spreadsheet was not overwritten")
    else
        disp('Must respond with Y or N')
    end
else
    writetable(T,['SpeciesParameterConventions/',FileName]) %make the spreadsheet
    fprintf('File generated with name: %s\n',FileName)
end



end %function