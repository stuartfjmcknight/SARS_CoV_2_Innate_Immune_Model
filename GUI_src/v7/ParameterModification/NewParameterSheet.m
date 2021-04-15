function NewParameterSheet(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 12Feb2021
%% ---------------------
%% Function Information
% This function is used to generate a spreadsheet of all of the reaction rate parameters
% which are used in the model. The result of running this script is that the rate parameters,
% along with other useful info regarding the specified model will be extracted and presented
% in a spreadsheet. This spreadsheet will be saved with the specified
% filename.
% This spreadsheet can be modified by the user and then uploaded at a later
% date back into the model to modify the reaction parameters from an iterface which is more
% userfriendly than the command line.

Model = app.Model;
%% Determine File Type
%FileType = FileTypeDetermination(SpreadsheetName);
FileName = [app.ParametersFileNameEditField.Value, app.ParameterSelectFileTypeDropDown.Value];


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
end %function

