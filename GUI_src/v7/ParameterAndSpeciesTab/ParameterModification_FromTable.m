function  ParameterModification_FromTable(app)
%% Modify only changed parameters in the table
% Last Edit: Stuart McKnight on 24Mar2021
%% ---------------------
% This function will allow the user to update and change only the
% parameters that they modified in the table. The indicies and new values
% will be stored as properties to the app. As the user changes values, the
% indecies and new values will be recorded in these vectors. 

% These vectors will be imported into this function, which will update only
% the parameters specified by the user. 


%% Define the Model
%app = m
Model = app.Model; %define the name of the model


%% import the vectors of indecies and values
Indecies = app.ParameterIndexToChange;
NewValues = app.ParameterNewValueToChage;

%% Assign a reaction # and parameter # 
% Since the index of the changed parameter does not align with the reaction
% number in the code, we must use some knowledge on the model to do this.

ReactionIndex = double(app.ModelReactionInformation.Reaction_Index(Indecies)');
ParameterIndex = double(app.ModelReactionInformation.Parameter_Index(Indecies)');

%% 
for i = 1:length(Indecies)
    % Display some information on the reaction about to be modified
    disp('************************')
    fprintf('Reaction Index %i | Reaction Name: %s | Chemical Eqn.: %s\n',ReactionIndex(i),Model.Reactions(i).Name, Model.Reactions(i).Reaction)
    fprintf('Rate Equation: Rate = %s\n',Model.Reactions(i).ReactionRate)
    
    % Update the parameter
    Model.Reaction(ReactionIndex(i),1).KineticLaw.Parameters(ParameterIndex(i)).Value = NewValues(i); % update the rate constant using the RateConstant vector which was removed from the spreadsheet

    % Confirm the reaction was updated
    fprintf('Reaction Parameter is now: %s [%s]\n', string(Model.Reaction(ReactionIndex(i),1).KineticLaw.Parameters(ParameterIndex(i)).Value),...
        Model.Reaction(ReactionIndex(i),1).KineticLaw.Parameters(ParameterIndex(i)).Units)
    fprintf('Reaction Updated\n')
    disp('------------------------')
end

%% Update Model Infomration to Reflect These changes
GenerateReactionIndexes_Name_Value_ParameterIndex(app); %Update Model Info property to match the changes that were made
PopulateParameterTable(app) % Update the table in the GUI to match

%% Reset the vectors of indecies and new values back to empty for the next time
app.ParameterIndexToChange = [];
app.ParameterNewValueToChage = [];

end%function

