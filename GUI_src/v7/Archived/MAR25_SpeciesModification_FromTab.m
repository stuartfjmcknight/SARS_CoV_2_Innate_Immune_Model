function SpeciesModification_FromTab(app)

Model = app.Model;
Units_on = 1;

data_table = app.SpeciesTable.Data; % This is a function which will be used to import the data
SpeciesIndex = str2double(data_table(:,1)); % Extract the species index column
ModelName = data_table(:,2); % Extract the name of the species as defined in the model
IC = str2double(data_table(:,3));
Units = data_table(:,4); % Extract the units column from the data set

%% Modify the Parameters

for i = 1:length(SpeciesIndex) % Loop over all of the species
    if strcmp(ModelName(i),string(Model.Species(i).Name)) %compare that the name in the spreadsheet matches the name in the model
        Model.Species(i).InitialAmount = IC(i);  % update the initial condition to what is defined in the spreadsheet.
        %               Units
        if Units_on
            Model.Species(i).Units = char(Units(i)); %update the units to what is defined in the spreadsheet
        end
    else
        warning('Model Name and Spreadsheet Name are not the same')
    end
    
    fprintf('%s now has an Initial Amount of %4.5f %s\n',Model.Species(i).Name,Model.Species(i).InitialAmount,Model.Species(i).Units)
    disp('=========================================================================')
    disp(' ')
end %for loop over species


%% Update Model Infomration to Reflect These changes
GenerateSpeciesIndex_Name_Value(app); %Update Model Info property to match the changes that were made
PopulateSpeciesTable(app) % Update the table in the GUI to match


end %function