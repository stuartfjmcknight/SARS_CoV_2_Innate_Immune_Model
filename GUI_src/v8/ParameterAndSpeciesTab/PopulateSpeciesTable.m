function PopulateSpeciesTable(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 21Mar2021
%% ---------------------
T = app.ModelSpeciesInformation; %save the Model Information as a variable to reduce callback delay

app.SpeciesTable.Data = [T.Species_Index,T.Model_Name,T.Initial_Amount,T.Units]; % Use selected columns

end
