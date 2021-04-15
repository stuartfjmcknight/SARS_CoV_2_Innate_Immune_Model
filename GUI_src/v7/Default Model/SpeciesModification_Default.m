function SpeciesModification_Default(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 12Feb2021
%% ---------------------

Model = app.Model;
Units_on = app.UpdateSpeciesUnitsCheckBox.Value;
SpreadsheetName = 'Default_SPECIES.xlsx';

%%
IndexRow = 1;
ModelNameRow = 3;
InitialAmountRow = 4;
UnitsRow = 6;
DataSheetRange = [2, 50];

%% Determine File Type
if string(char(SpreadsheetName(end-3:end))) == ".csv"
    FileType = ".csv";
elseif string(char(SpreadsheetName(end-4:end))) == ".xlsx"
    FileType = ".xlsx";
elseif string(char(SpreadsheetName(end-3:end))) == ".xls"
    FileType = ".xls";
else
    warning('Do not know this file type')
end

%% Load the Data
% Change the importing function based on the file type.
if strcmp(FileType,".xlsx")
    disp('Importing xlsx file')
    data_table = ImportSpeciesFile_xlsx(SpreadsheetName, "Sheet1", DataSheetRange); % This is a function which will be used to import the data
    SpeciesIndex = str2double(table2array(data_table(:,IndexRow))); % Extract the species index column
    ModelName = table2array(data_table(:,ModelNameRow)); % Extract the name of the species as defined in the model
    IC = table2array(data_table(:,InitialAmountRow));
    Units = table2array(data_table(:,UnitsRow)); % Extract the units column from the data set
    
elseif strcmp(FileType,".xls")
    disp('Importing xls file')
    data_table = ImportSpeciesFile_xls(SpreadsheetName, "Sheet1", DataSheetRange); % This is a function which will be used to import the data
    SpeciesIndex = str2double(table2array(data_table(:,IndexRow))); % Extract the species index column
    ModelName = table2array(data_table(:,ModelNameRow)); % Extract the name of the species as defined in the model
    IC = str2double(table2array(data_table(:,InitialAmountRow)));
    Units = table2array(data_table(:,UnitsRow)); % Extract the units column from the data set
    
elseif strcmp(FileType,".csv")
    disp('Importing csv file')
    data_table = ImportSpeciesFile_csv(SpreadsheetName, DataSheetRange);
    SpeciesIndex = table2array(data_table(:,IndexRow)); % Extract the species index column
    ModelName = table2array(data_table(:,ModelNameRow)); % Extract the name of the species as defined in the model
    IC = table2array(data_table(:,InitialAmountRow));
    Units = string(table2array(data_table(:,UnitsRow))); % Extract the units column from the data set
else
    warning('Error Importing the Data')
end

%% Specify Useful Parameters
%         SpeciesIndex = str2double(table2array(data_table(:,IndexRow))); % Extract the species index column
%         ModelName = table2array(data_table(:,ModelNameRow)); % Extract the name of the species as defined in the model
%         IC = table2array(data_table(:,InitialAmountRow));
%         % Exctract the initial condition column from the data set
%         Units = table2array(data_table(:,UnitsRow)); % Extract the units column from the data set
%
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
