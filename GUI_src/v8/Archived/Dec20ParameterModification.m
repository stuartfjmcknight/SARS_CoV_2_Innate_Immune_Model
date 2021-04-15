function ParameterModification(app)
%Information on function  |  LAST UPDATE 8-DEC by SM (CSV option, Units, Popout warning)
%
% This function is used to do two thigs. 1) It will generate a new
% spreadsheet with the desired filename, which contains all of the
% parameters in the seleceted model. 2) It will use the information which the user
% populates into a spreadsheet to update the parameters in
% the desired model so that the user can then run the model with the
% parameters they added to the spreadsheet.
%
%Inputs
% app.Model = sbproj model which is selected within the GUI
% app.SpeciesSpreadsheetNameEditField.Value = Filename
%
%Outputs
% Either
%   1) Save a spreadsheet with the parameters information
%   3) Update the model, saving the updated model as the app.Model variable


%%
Model = app.Model;
FileName = app.ParameterSpreadsheetNameEditField.Value;
SpreadsheetName = app.ParameterSpreadsheetNameEditField.Value;
Units_On = app.UpdateParameterUnitsCheckBox.Value;

%%
switch app.ParameterModificationDropDown.Value
    
    case "New Reaction Parameter Sheet"
        %% Function Information
        % This function is used to generate a spreadsheet of all of the reaction rate parameters
        % which are used in the model. The result of running this script is that the rate parameters,
        % along with other useful info regarding the specified model will be extracted and presented
        % in a spreadsheet. This spreadsheet will be saved with the specified
        % filename.
        % This spreadsheet can be modified by the user and then uploaded at a later
        % date back into the model to modify the reaction parameters from an iterface which is more
        % userfriendly than the command line.
        
        
        
        %% Initiate for loop for changing the reaction parameters
        N = length(Model.Reactions); %determine the number of reactions
        
        % Set a counter. This will be used as the row of the spreadsheet. Since
        % some reactions have muliple rate constants, the number of rows in the in
        % the matrix will not match the number of reactions. This counter is k.
        k = 1;
        for i = 1:N
            j = length(Model.Reactions(i).KineticLaw.Parameters); %determine how many rate constants go with the ith reaction
            if j > 1 % This part of the function inside this if statement is run when there is more than 1 rate parameter for the reaction.
                % Another for loop will be used to modify each of the reaction
                % parameters within the ith reaction. This is why the counter k is
                % important to build the rows of the matrix.
                for ii = 1:j
                    Reaction_Name(k,1) = string(Model.Reactions(i).Name); % extract the name of the ith reaction
                    Reaction_Index(k,1) = string(i); % Each reaction has a corresponding reaction index, this is kept track of here.
                    RateConstantName(k,1) = string(Model.Reactions(i).KineticLaw.Parameters(ii).Name); % Extract the name of the rate constant
                    RateEquation(k,1) = string(Model.Reactions(i).ReactionRate); % Extract the rate reaction equation
                    ChemicalEquation(k,1) = string(Model.Reaction(i).Reaction); % Extract the chemical euqation
                    Value(k,1) = string(Model.Reactions(i).KineticLaw.Parameters(ii).Value); % Extract the value of the rate constant
                    Units(k,1) = string(Model.Reactions(i).KineticLaw.Parameters(ii).Units); % Extract the units of the rate constant
                    Sources(k,1) = " ";
                    k = k+1; % update the counter to add another row to the growing matrix
                end
            else
                Reaction_Name(k,1) = string(Model.Reactions(i).Name); % extract the name of the ith reaction
                Reaction_Index(k,1) = string(i); % Each reaction has a corresponding reaction index, this is kept track of here.
                RateConstantName(k,1) = string(Model.Reactions(i).KineticLaw.Parameters.Name); % Extract the name of the rate constant
                RateEquation(k,1) = string(Model.Reactions(i).ReactionRate); % Extract the rate reaction equation
                ChemicalEquation(k,1) = string(Model.Reaction(i).Reaction); % Extract the chemical euqation
                Value(k,1) = string(Model.Reactions(i).KineticLaw.Parameters.Value); % Extract the value of the rate constant
                Units(k,1) = string(Model.Reactions(i).KineticLaw.Parameters.Units); % Extract the units of the rate constant
                Sources(k,1) = " ";
                k = k+1; % update the counter to add another row to the growing matrix
            end
            
        end
        
        T = table(Reaction_Name,Reaction_Index, RateConstantName, RateEquation, ChemicalEquation, Value, Units,Sources); % Build the table that will be exported.
        
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
        
        
        %% Parameter Modifications
    case "Update Reaction Parameters"
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
        
        
        
        DataSheetRange = [2,56]; %Position of top left cell, and bottom right cell in excel spreadsheet
        RxnColumnIndex = 2; %column which has reaction index
        RateConstantColumnIndex = 6; %column which has rate constants
        RateConstantName = 3; %column which has parameter name
        UnitsIndex = 7; %column that has the units for the rate parameter
        
        
        %% Load the Data
        %
        data_table = importfile(SpreadsheetName, "Sheet1", DataSheetRange); % This is a function which will be used to import the data
        ReactionIndex = str2double(table2array(data_table(:,RxnColumnIndex))); % Extracts the reaction index column from the data table
        RateConstants = str2double(table2array(data_table(:,RateConstantColumnIndex))); % Extracts the rate constant column from the data table
        Units = table2array(data_table(:,UnitsIndex)); % Extract the units column from the data table
        ParameterName = table2array(data_table(:,RateConstantName)); % Extract the parameter name column from the data table.
        
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

    function PARAMS = importfile(workbookFile, sheetName, dataLines)
        %IMPORTFILE Import data from a spreadsheet
        %  PARAMS = IMPORTFILE(FILE) reads data from the first worksheet in the
        %  Microsoft Excel spreadsheet file named FILE.  Returns the data as a
        %  table.
        %
        %  PARAMS = IMPORTFILE(FILE, SHEET) reads from the specified worksheet.
        %
        %  PARAMS = IMPORTFILE(FILE, SHEET, DATALINES) reads from the specified
        %  worksheet for the specified row interval(s). Specify DATALINES as a
        %  positive scalar integer or a N-by-2 array of positive scalar integers
        %  for dis-contiguous row intervals.
        %
        %  Example:
        %  PARAMS = importfile("/Users/stuartmcknight/Dropbox/SARS-CoV-2-Infection-Computational-Model/Model_2_InnateImmune/PARAMS.xlsx", "Sheet1", [2, 59]);
        %
        %  See also READTABLE.
        %
        % Auto-generated by MATLAB on 04-Nov-2020 22:35:55
        
        %% Input handling
        
        % If no sheet is specified, read first sheet
        if nargin == 1 || isempty(sheetName)
            sheetName = 1;
        end
        
        % If row start and end points are not specified, define defaults
        if nargin <= 2
            dataLines = [2, 59];
        end
        
        %% Set up the Import Options and import the data
        opts = spreadsheetImportOptions("NumVariables", 9);
        
        % Specify sheet and range
        opts.Sheet = sheetName;
        opts.DataRange = "A" + dataLines(1, 1) + ":I" + dataLines(1, 2);
        
        % Specify column names and types
        opts.VariableNames = ["Reaction_Name", "Reaction_Index", "RateConstantName", "RateEquation", "ChemicalEquation", "Value", "Units", "Sources", "VarName9"];
        opts.VariableTypes = ["categorical", "string", "string", "string", "string", "string", "string", "string", "string"];
        
        % Specify variable properties
        opts = setvaropts(opts, ["Reaction_Index", "Value", "Units", "Sources"], "WhitespaceRule", "preserve");
        opts = setvaropts(opts, ["Reaction_Name", "Reaction_Index", "RateConstantName", "RateEquation", "ChemicalEquation", "Value", "Units", "Sources", "VarName9"], "EmptyFieldRule", "auto");
        
        % Import the data
        PARAMS = readtable(workbookFile, opts, "UseExcel", false);
        
        for idx = 2:size(dataLines, 1)
            opts.DataRange = "A" + dataLines(idx, 1) + ":I" + dataLines(idx, 2);
            tb = readtable(workbookFile, opts, "UseExcel", false);
            PARAMS = [PARAMS; tb]; %#ok<AGROW>
        end
        
    end

end