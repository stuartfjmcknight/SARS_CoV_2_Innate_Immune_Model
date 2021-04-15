function AddRowToSensParameterTable(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 26Mar2021
%% ---------------------
ParameterValue = app.SensParamTable.Data;
N = length(ParameterValue);
for i = 1:N
    NewRow(1,i) = " ";
end
NewRow(1) = 0;
ParameterValue = [ParameterValue;NewRow];

app.SensParamTable.Data = ParameterValue;

end %function