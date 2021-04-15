function MasterPlotDefault(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 19Jan2021
%% ---------------------
%% Extract from app.Results
Results = app.Results; %Preload for speed since we will call back on this
NamesString = string(app.Results.Names);

%% Default Species to Plot
IndexToPlot = [4,21];

switch app.MasterPlotDefaultConcOrCountDropDown.Value
    case 'Conc'
        %% This loop will find the indexes for the selected species to be plotted
        Ntime = length(Results.Time);
        NSpecies = length(IndexToPlot);
        SpeciesToPlotString = string(zeros(1,NSpecies));
        SelectedTrajectories = zeros(Ntime,NSpecies);
        for i = 1:NSpecies
            SelectedTrajectories(:,i) = Results.Conc(:,IndexToPlot(i));
            SpeciesToPlotString(1,i) = NamesString(IndexToPlot(i));
        end
        % The index which is returned in the Row in the Name vector which
        % corresponds to the selected species. This row value corresponds directly
        % to the column in the Results.Count matrix which contains the trajectory.
        
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
        
        %% This loop will find the indexes for the selected species to be plotted
        Ntime = length(Results.Time);
        NSpecies = length(IndexToPlot);
        SpeciesToPlotString = string(zeros(1,NSpecies));
        SelectedTrajectories = zeros(Ntime,NSpecies);
        for i = 1:NSpecies
            SelectedTrajectories(:,i) = Results.Count(:,IndexToPlot(i));
            SpeciesToPlotString(1,i) = NamesString(IndexToPlot(i));
        end
        % The index which is returned in the Row in the Name vector which
        % corresponds to the selected species. This row value corresponds directly
        % to the column in the Results.Count matrix which contains the trajectory.
        
        %% Generate the Plot
        
        % Generate the Plot
        plot(app.AxesSpeciesPlot,Results.Time,SelectedTrajectories, 'LineWidth',2)
        
        % Add a legend to the Plot
        legend(app.AxesSpeciesPlot,SpeciesToPlotString, 'Location','NorthEast','Interpreter','none')
        
        % Label Axis
        str_xlab = sprintf('Time %s',app.TimeUnits);
        xlabel(app.AxesSpeciesPlot,str_xlab);
        ylabel(app.AxesSpeciesPlot,'SARS-CoV-2  [count/Cell]')
        
        app.XMaxSpeciesPlot.Value = max(Results.Time);
        app.XMinSpeciesPlot.Value = min(Results.Time);
        
        app.YMaxSpeciesPlot.Limits = [min(min(SelectedTrajectories)),max(max(SelectedTrajectories))];
        app.YMinSpeciesPlot.Limits = [min(min(SelectedTrajectories)),max(max(SelectedTrajectories))];
        app.YMaxSpeciesPlot.Value = max(max(SelectedTrajectories));
        app.YMinSpeciesPlot.Value = min(min(SelectedTrajectories));
        
        
end %switch for conc vs count

% Save plotting data for exorting of plot
app.MasterPlot.Time = [];
app.MasterPlot.SelectedTrajectories = [];
app.MasterPlot.SpeciesToPlotString = [];

app.MasterPlot.Time = Results.Time;
app.MasterPlot.SelectedTrajectories = SelectedTrajectories;
app.MasterPlot.SpeciesToPlotString =SpeciesToPlotString;

% Set sliders
app.XMinSpeciesPlot.Limits = [min(Results.Time),max(Results.Time)];
app.XMaxSpeciesPlot.Limits = [min(Results.Time),max(Results.Time)];
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
app.YMaxSpeciesPlot.Value = max(max(SelectedTrajectories));
app.YMinSpeciesPlot.Value = min(min(SelectedTrajectories));



end %function