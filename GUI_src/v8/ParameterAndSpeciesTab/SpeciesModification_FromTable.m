function SpeciesModification_FromTable(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 24Mar2021
%% ---------------------
% This function will allow the user to update and change only the
% species that they modified in the table. The indicies and new values
% will be stored as properties to the app. As the user changes values, the
% indecies and new values will be recorded in these vectors. 

% These vectors will be imported into this function, which will update only
% the species specified by the user. 

%% Define the Model
Model = app.Model;

%% import the vectors of indecies and values
Indecies = app.SpeciesIndexToChange;
NewValues = app.SpeciesNewValueToChage;

%% Update Model Species
for i = 1:length(Indecies) % Loop over all of the species
    Model.Species(Indecies(i)).InitialAmount = NewValues(i);  % update the initial condition to what is defined in the spreadsheet.
    fprintf('%s now has an Initial Amount of %4.5f %s\n',Model.Species(Indecies(i)).Name,Model.Species(Indecies(i)).InitialAmount,Model.Species(Indecies(i)).Units)
    disp('=========================================================================')
    disp(' ')
end %for loop over species

%% Update Model Infomration to Reflect These changes
GenerateSpeciesIndex_Name_Value(app); %Update Model Info property to match the changes that were made
PopulateSpeciesTable(app) % Update the table in the GUI to match

%% Reset the vectors of indecies and new values back to empty for the next time
app.SpeciesIndexToChange = [];
app.SpeciesNewValueToChage = [];

end %function

% 
% 
% data_table = app.SpeciesTable.Data; % This is a function which will be used to import the data
% SpeciesIndex = str2double(data_table(:,1)); % Extract the species index column
% ModelName = data_table(:,2); % Extract the name of the species as defined in the model
% IC = str2double(data_table(:,3));
% Units = data_table(:,4); % Extract the units column from the data set
% 
% %% Modify the Parameters
% 
% for i = 1:length(SpeciesIndex) % Loop over all of the species
%     if strcmp(ModelName(i),string(Model.Species(i).Name)) %compare that the name in the spreadsheet matches the name in the model
%         Model.Species(i).InitialAmount = IC(i);  % update the initial condition to what is defined in the spreadsheet.
%         %               Units
%         if Units_on
%             Model.Species(i).Units = char(Units(i)); %update the units to what is defined in the spreadsheet
%         end
%     else
%         warning('Model Name and Spreadsheet Name are not the same')
%     end
%     
%     fprintf('%s now has an Initial Amount of %4.5f %s\n',Model.Species(i).Name,Model.Species(i).InitialAmount,Model.Species(i).Units)
%     disp('=========================================================================')
%     disp(' ')
% end %for loop over species
% 
% 
% %% Update Model Infomration to Reflect These changes
% GenerateSpeciesIndex_Name_Value(app); %Update Model Info property to match the changes that were made
% PopulateSpeciesTable(app) % Update the table in the GUI to match
% 
%end %function