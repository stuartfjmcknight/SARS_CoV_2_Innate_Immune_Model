function GenerateSpeciesIndex_Name_Value(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 24Mar2021
%% ---------------------


%% Define Model
Model = app.Model;

for i = 1:length(Model.Species)
    Species_Index(i,1) = string(i); % Extract the species name
    %Species_Name(i,1) = " "; % Create a blank which the user can add in the spreadsheet if useful
    Model_Name(i,1) = string(Model.Species(i).Name); % Extract the name of the species
    Initial_Amount(i,1) = string(Model.Species(i).InitialAmount); % Extract the initial amount
    %Range(i,1) = " "; % Create a blank for user to include a range
    Units(i,1) = string(Model.Species(i).Units); % Extract the units that go with the initial amount

end %for loop

T_species = table(Species_Index,Model_Name,Initial_Amount,Units); % Build the talbe structure which will be transformed into a spreadsheet.

app.ModelSpeciesInformation = T_species;
end %function
