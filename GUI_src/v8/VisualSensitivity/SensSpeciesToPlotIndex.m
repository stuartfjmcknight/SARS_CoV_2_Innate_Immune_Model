function SensSpeciesToPlotIndex(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 26Mar2021
%% ---------------------

SpeciesToPlotString = string(app.SensSpecies.Value); %Saves a cell array of the species selected to be plotted
NamesString = string(app.SensResults.Names{1});

IndexToPlot = find(NamesString == SpeciesToPlotString); %Returns the index which corresponds to the species

app.SensSpeciesToPlot = IndexToPlot;


end %function