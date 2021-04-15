function SpeciesModification(app)

%Information on function  |  LAST UPDATE 8-DEC by SM (CSV option, Units, Popout warning)
%
% This function is used to do two thigs. 1) It will generate a new
% spreadsheet with the desired filename, which contains all of the species
% in the seleceted model. 2) It will use the information which the user
% populates into a spreadsheet to update the species initial conditions in
% the desired model so that the user can then run the model with the
% initial conditions they added to the spreadsheet.
%
%Inputs
% app.Model = sbproj model which is selected within the GUI
% app.SpeciesSpreadsheetNameEditField.Value = Filename
%
%Outputs
% Either 
%   1) Save a spreadsheet with the species information
%   3) Update the model, saving the updated model as the app.Model variable

%%
Model = app.Model;
FileName = app.SpeciesSpreadsheetNameEditField.Value;
CASE = app.SpeciesModificationDropDown.Value;
Units_on = app.UpdateSpeciesUnitsCheckBox.Value;

% sbioloadproject 'PC_Update_NOV29'
% Model = m1
% FileName = '29Nov_Species.xlsx'
% CASE = "Update Species Parameters"
% Units_on = 1;


%%
switch CASE
    
    case "New Species Parameter Sheet"
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
        
        
    case "Update Species Parameters"
        
        IndexRow = 1;
        ModelNameRow = 3;
        InitialAmountRow = 4;
        UnitsRow = 6;
        DatasheetRange = [2, 46];
        
        %% Load the Data
        data_table = importfile(FileName, 1, DatasheetRange); % Import the data spreadsheet as a data table
        SpeciesIndex = str2double(table2array(data_table(:,IndexRow))); % Extract the species index column
        ModelName = table2array(data_table(:,ModelNameRow)); % Extract the name of the species as defined in the model
        IC = table2array(data_table(:,InitialAmountRow));
        % Exctract the initial condition column from the data set
        Units = table2array(data_table(:,UnitsRow)); % Extract the units column from the data set
        
        %% Modify the Parameters
        
        for i = 1:length(SpeciesIndex) % Loop over all of the species
            if strcmp(ModelName(i),string(Model.Species(i).Name)) %compare that the name in the spreadsheet matches the name in the model
                Model.Species(i).InitialAmount = IC(i);  % update the initial condition to what is defined in the spreadsheet.
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
end %function



function data = importfile(workbookFile, sheetName, dataLines)
%IMPORTFILE Import data from a spreadsheet
%  NOVSPECIES = IMPORTFILE(FILE) reads data from the first worksheet in
%  the Microsoft Excel spreadsheet file named FILE.  Returns the data as
%  a table.
%
%  NOVSPECIES = IMPORTFILE(FILE, SHEET) reads from the specified
%  worksheet.
%
%  NOVSPECIES = IMPORTFILE(FILE, SHEET, DATALINES) reads from the
%  specified worksheet for the specified row interval(s). Specify
%  DATALINES as a positive scalar integer or a N-by-2 array of positive
%  scalar integers for dis-contiguous row intervals.
%
%  Example:
%  NovSpecies = importfile("/Users/stuartmcknight/Dropbox/SARS-CoV-2-Infection-Computational-Model/Model_2_InnateImmune/SpeciesParameterConventions/29Nov_Species.xlsx", "Sheet1", [2, 46]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 08-Dec-2020 20:46:07

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 2
    dataLines = [2, 46];
end

%% Set up the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 11);

% Specify sheet and range
opts.Sheet = sheetName;
opts.DataRange = "A" + dataLines(1, 1) + ":K" + dataLines(1, 2);

% Specify column names and types
opts.VariableNames = ["Species_Index", "Species_Name", "Model_Name", "Initial_Amount", "Range", "Units", "Constant_Amount", "Boundary_Condition", "Type", "Compartment_Type", "Compartment"];
opts.VariableTypes = ["string", "string", "string", "double", "string", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical"];

% Specify variable properties
opts = setvaropts(opts, ["Species_Index", "Species_Name", "Model_Name", "Range"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Species_Index", "Species_Name", "Model_Name", "Range", "Units", "Constant_Amount", "Boundary_Condition", "Type", "Compartment_Type", "Compartment"], "EmptyFieldRule", "auto");

% Import the data
data = readtable(workbookFile, opts, "UseExcel", false);

for idx = 2:size(dataLines, 1)
    opts.DataRange = "A" + dataLines(idx, 1) + ":K" + dataLines(idx, 2);
    tb = readtable(workbookFile, opts, "UseExcel", false);
    data = [data; tb]; %#ok<AGROW>
end

end

end



