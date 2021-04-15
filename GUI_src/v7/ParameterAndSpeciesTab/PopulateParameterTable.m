function PopulateParameterTable(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 21Mar2021
%% ---------------------
T = app.ModelReactionInformation; %save the Model Information as a variable to reduce callback delay

app.ParameterTable.Data = [T.Reaction_Index,T.Reaction_Name,T.RateConstantName,T.Value,T.Units]; % Use selected columns

end
