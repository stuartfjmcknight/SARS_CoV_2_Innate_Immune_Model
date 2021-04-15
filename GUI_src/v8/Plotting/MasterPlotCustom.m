function MasterPlotCustom(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 19Jan2021
%% ---------------------
%%

Results = app.Results; %Preload for speed since we will call back on this
SpeciesToPlotString = string(app.Species.Value); %Saves a cell array of the species selected to be plotted
NamesString = string(app.Results.Names);
Ntime = length(Results.Time);
NSpecies = length(app.Species.Value);
%% This loop will find the indexes for the selected species to be plotted
IndexToPlot = zeros(1,NSpecies);
SelectedTrajectories = zeros(Ntime,NSpecies);

switch app.MasterPlotCustomConcOrCountDropDown.Value
    case 'Conc'
        
        for i = 1:length(app.Species.Value)
            IndexToPlot(i) = sort(find(NamesString == SpeciesToPlotString(i))); %Returns the index which corresponds to the species
            SelectedTrajectories(:,i) = Results.Conc(:,IndexToPlot(i));
        end
        % The index which is returned in the Row in the Name vector which
        % corresponds to the selected species. This row value corresponds directly
        % to the column in the Results.Conc matrix which contains the trajectory.
        
        %% Generate the Plot
        
        % Generate the Plot
        plot(app.AxesSpeciesPlot,Results.Time,SelectedTrajectories, 'LineWidth',2)
        
        % Add a legend to the Plot
        legend(app.AxesSpeciesPlot,SpeciesToPlotString, 'Location','NorthEast','Interpreter','none')
        
        % Label Axis
        str_xlab = sprintf('Time %s',app.TimeUnits);
        xlabel(app.AxesSpeciesPlot,str_xlab);
        ylabel(app.AxesSpeciesPlot,'SARS-CoV-2  [moles/L]')
        
        
    case 'Count'
        
        
        for i = 1:length(app.Species.Value)
            IndexToPlot(i) = sort(find(NamesString == SpeciesToPlotString(i))); %Returns the index which corresponds to the species
            SelectedTrajectories(:,i) = Results.Count(:,IndexToPlot(i));
        end
        % The index which is returned in the Row in the Name vector which
        % corresponds to the selected species. This row value corresponds directly
        % to the column in the Results.Conc matrix which contains the trajectory.
        
        %% Generate the Plot
        
        % Generate the Plot
        plot(app.AxesSpeciesPlot,Results.Time,SelectedTrajectories, 'LineWidth',2)
        
        % Add a legend to the Plot
        legend(app.AxesSpeciesPlot,SpeciesToPlotString, 'Location','NorthEast','Interpreter','none')
        
        % Label Axis
        str_xlab = sprintf('Time %s',app.TimeUnits);
        xlabel(app.AxesSpeciesPlot,str_xlab);
        ylabel(app.AxesSpeciesPlot,'SARS-CoV-2  [count/Cell]')
        
end %Switch

% Save plotting data for exorting of plot
app.MasterPlot.Time = [];
app.MasterPlot.SelectedTrajectories = [];
app.MasterPlot.SpeciesToPlotString = [];

app.MasterPlot.Time = Results.Time;
app.MasterPlot.SelectedTrajectories = SelectedTrajectories;
app.MasterPlot.SpeciesToPlotString = SpeciesToPlotString;

% Set Sliderss
app.XMaxSpeciesPlot.Limits = [min(Results.Time),max(Results.Time)];
app.XMinSpeciesPlot.Limits = [min(Results.Time),max(Results.Time)];
app.XMaxSpeciesPlot.Value = max(Results.Time);
app.XMinSpeciesPlot.Value = min(Results.Time);

try
    app.YMaxSpeciesPlot.Limits = [min(min(SelectedTrajectories)),max(max(SelectedTrajectories))];
catch
warning('Y range is funky')
end
try
    app.YMinSpeciesPlot.Limits = [min(min(SelectedTrajectories)),max(max(SelectedTrajectories))];
catch
warning('Y range is funky')
end

app.YMaxSpeciesPlot.Value = max(max(SelectedTrajectories))
app.YMinSpeciesPlot.Value = min(min(SelectedTrajectories));



end %function