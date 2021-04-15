function ParameterModification_Default(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 12Feb2021
%% ---------------------
Model = app.Model;

SpreadsheetName = 'Default_PARAMS.xlsx';
Units_On = app.UpdateParameterUnitsCheckBox.Value;

%% Parameter Modifications

%% This function will take a model (M) as the input, as well as the name of the spreadsheety
%which will be used to set the parameter values. From this spreadsheet this
%function will
% . 1) Find the correct reaction based on the reaction indexes in the
% spreadsheet
%   2) Change the rate constant of this reaction to reflect what is in the
%   spreadsheet.

% The spreadsheet must include ALL reactions!

% The spreadsheet which is uploaded, will default to reaction index as the
% second (2nd) column, and the desired rate constant as the 10th column.



DataSheetRange = [2,200]; %Position of top left cell, and bottom right cell in excel spreadsheet
RxnColumnIndex = 2; %column which has reaction index
RateConstantColumnIndex = 6; %column which has rate constants
RateConstantName = 3; %column which has parameter name
UnitsIndex = 7; %column that has the units for the rate parameter

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

SpreadsheetName = string(SpreadsheetName);

%% Load the Data
% Change the importing function based on the file type.
if strcmp(FileType,".xlsx")
    data_table = ImportParamfile_xlsx(SpreadsheetName, "Sheet1", DataSheetRange); % This is a function which will be used to import the data
    ReactionIndex = str2double(table2array(data_table(:,RxnColumnIndex))); % Extracts the reaction index column from the data table
    RateConstants = str2double(table2array(data_table(:,RateConstantColumnIndex))); % Extracts the rate constant column from the data table
    Units = table2array(data_table(:,UnitsIndex)); % Extract the units column from the data table
    ParameterName = table2array(data_table(:,RateConstantName)); % Extract the parameter name column from the data table.
    
elseif strcmp(FileType,".xls")
    data_table = ImportParamFile_xls(SpreadsheetName, "Sheet1", DataSheetRange); % This is a function which will be used to import the data
    ReactionIndex = str2double(table2array(data_table(:,RxnColumnIndex))); % Extracts the reaction index column from the data table
    RateConstants = table2array(data_table(:,RateConstantColumnIndex)); % Extracts the rate constant column from the data table
    Units = table2array(data_table(:,UnitsIndex)); % Extract the units column from the data table
    ParameterName = table2array(data_table(:,RateConstantName)); % Extract the parameter name column from the data table.
    
    
elseif strcmp(FileType,".csv")
    data_table = ImportParamFile_csv(SpreadsheetName, DataSheetRange);
    ReactionIndex = table2array(data_table(:,RxnColumnIndex)); % Extracts the reaction index column from the data table
    RateConstants = table2array(data_table(:,RateConstantColumnIndex)); % Extracts the rate constant column from the data table
    Units = string(table2array(data_table(:,UnitsIndex))); % Extract the units column from the data table
    ParameterName = table2array(data_table(:,RateConstantName)); % Extract the parameter name column from the data table.
    
else
    error('Error Importing the Data')
end

%         %% Separate out the important information
%         ReactionIndex = str2double(table2array(data_table(:,RxnColumnIndex))); % Extracts the reaction index column from the data table
%         RateConstants = str2double(table2array(data_table(:,RateConstantColumnIndex))); % Extracts the rate constant column from the data table
%         Units = table2array(data_table(:,UnitsIndex)); % Extract the units column from the data table
%         ParameterName = table2array(data_table(:,RateConstantName)); % Extract the parameter name column from the data table.
%
Units = fillmissing(Units,'constant'," ");

%% Modify the Parameters
for i = 1:max(ReactionIndex)
    
    % Since some reaction indexes are repeated because they are
    % equilibrium, there will be more rows to the ReactionIndex vector than
    % reactions. Therefore, when the number if iterations i is = to the
    % number of reactions that
    
    disp('************************')
    fprintf('Reaction Index %i | Reaction Name: %s | Chemical Eqn.: %s\n',i,Model.Reactions(i).Name, Model.Reactions(i).Reaction)
    fprintf('Rate Equation: Rate = %s\n',Model.Reactions(i).ReactionRate)
    
    
    j = find(ReactionIndex == i); % This will find all the rows with reaction index i. There will be more than 1 row if there is more than 1 rate constant
    
    % Check if reaction is reversible / figure out how many parameters
    % there are...
    
    % Multiple Reaction Scope Parameter Modification
    if length(j) > 1 % when there are more than 1 rate parameter
        disp('Equilibrium/More than one Parameter Reaction')
        for ii = 1:length(j) % For each of the reaction parameters for the ith reaction
            if strcmp(string(Model.Reactions(i).KineticLaw.Parameters(ii).Name),string(ParameterName(j(ii))))
                % if the two names are the same, then update the parameter.
                % This requires the order in the spreadsheet to be the same
                % as the order in simbiology.
                Model.Reaction(i,1).KineticLaw.Parameters(ii).Value = RateConstants(j(ii)); % update the rate constant using the RateConstant vector which was removed from the spreadsheet
                % This is done for reaction i, and in that parameter ii,
                % which will be 1-N where N is the number of parameters
                % that reaction i has. This value will be updated with the
                % ii element of j, where j is the rows which contain
                % parameters for reaction i.
                if Units_On
                    Model.Reaction(i,1).KineticLaw.Parameters(ii).Units = Units(j(ii)); % See the above logic. The same process as above is used to change the units
                end
                fprintf('Model parameter %s was updated to %5.4f %s\n',Model.Reaction(i,1).KineticLaw.Parameters(ii).Name, RateConstants(j(ii)), Model.Reactions(i).KineticLaw.Parameters(ii).Units)
                
            else
                warning('Parameter Value was not chagned for reaction')
                fprintf('for reaction %i\n',i)
                % warn the user that there is a discrepency, and they must
                % reorder the spreadsheet to match the indexing in
                % simbiology.
            end
        end
    elseif length(j)==1 %if the reaction only has one reaction parameter
        Model.Reaction(i,1).KineticLaw.Parameters.Value = RateConstants(j); % uses the same logic as when there are multiple parameters, just without the ii desigation of the parameter.
        if Units_On
            Model.Reaction(i,1).KineticLaw.Parameters.Units = Units(j); % uses the same logic as when there are multiple parameters, just without the ii desigation of the parameter.
        end
        fprintf('Model parameter %s was updated to %5.4f %s\n',Model.Reaction(i,1).KineticLaw.Parameters.Name, RateConstants(j), Model.Reactions(i).KineticLaw.Parameters.Units)
    else
        warning('AAAHHHH something went horribly wrong')
    end
    fprintf('%ith Reaction Updated\n',i)
    disp('------------------------')
end

end %function
