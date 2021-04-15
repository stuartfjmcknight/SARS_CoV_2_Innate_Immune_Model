function PopulateSensParameterTable(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 26Mar2021
%% ---------------------

%%
%app = m
%% Collect Nessisary Vectors
SensitivityParameterList = string(app.SensParameters.Items)';
ReactionTable = app.ModelReactionInformation;
ParametersToChange = string(app.SensParameters.Value');

%% Find the indecies in Sensitivity Paramerter List that relate to those to be changed
for i = 1:length(ParametersToChange)
    [RxnCountToChange(i),~] = find(ParametersToChange(i) == SensitivityParameterList);
end
%% Set Rxn and Param Indecies To Change
% Save these as a property
app.SensRxnIndexToChange = str2double(ReactionTable.Reaction_Index(RxnCountToChange));
app.SensParmIndexToChange = str2double(ReactionTable.Parameter_Index(RxnCountToChange));

%% 
for i = 1:length(ParametersToChange)
    ParameterName(i) = string(ReactionTable.RateConstantName(RxnCountToChange(i)));
    ParameterValue(i) = string(ReactionTable.Value(RxnCountToChange(i))); 
    str_Parameter(i) = string(sprintf('Rxn_%s_%s',string(RxnCountToChange(i)),ParameterName(i)));
end

app.SensParametersString = str_Parameter;
N = length(ParameterValue);
NewRow = [];
for i = 1:N
    NewRow(1,i) = ParameterValue(i);
    NewRow = [i+1,NewRow];
end

ParameterValue = [1,ParameterValue];
ParameterValue = [ParameterValue; NewRow*10^(-5);...
                                  NewRow*10^(-2);...
                                  NewRow*0.5;...
                                  NewRow*2;...
                                  NewRow*10^(2);...
                                  NewRow*10^(5)];

ParameterValue(:,1) = 1:1:size(ParameterValue,1);
ParameterValue(1,1) = "1: Original Value";


app.SensParamTable.Data = ParameterValue;
app.SensParamTable.ColumnName = ["Experiment",str_Parameter];

end%function