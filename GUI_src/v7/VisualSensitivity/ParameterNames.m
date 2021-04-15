function ParameterNames(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 26Mar2021
%% ---------------------

%% Import Useful Reaction Table
T = app.ModelReactionInformation;

%% Extract Reaction Names
Reaction_Name = T.Reaction_Name;

%% Extract Reaction Parameter Names
Reaction_Parameter_Name = T.RateConstantName;

%% Extract Reaction Parameter Current Value
Reatcion_Parameter_Value = T.Value;

%% Extract Reaction Units
Reaction_Parameter_Units = T.Units;

%% Generate String with Useful information for each Reaction (Nx1) with N reactions
NRxns = length(T.RxnCount);
Parameter_Info_String = string(zeros(NRxns,1));
for i = 1:NRxns
    Parameter_Info_String(i) = string(sprintf('Reaction: %s | Rate Constant: %s = %s [%s]',...
    Reaction_Name(i), Reaction_Parameter_Name(i), Reatcion_Parameter_Value(i), Reaction_Parameter_Units(i)))';
end
%% Update Sensitivity Parameters List
app.SensParameters.Items = Parameter_Info_String;

end%function