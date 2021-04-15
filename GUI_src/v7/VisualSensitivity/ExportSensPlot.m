function ExportSensPlot(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 26Mar2021
%% ---------------------
Time = app.SensResults.Time;
Count = app.SensResults.Count;
Conc = app.SensResults.Conc;

%% Species to Plot
SpeciestoPlot = app.SensSpeciesToPlot;

%% Legend
Experiments = app.SensParamTable.Data(:,1);
for j = 1:length(Experiments)
    ExperimentString(j) = string(sprintf('Exp %s',Experiments(j)));
end

%% Build Plot
figure()
switch app.SensPlotConcOrCountDropDown.Value
    case 'Conc'
        %% Generate Plot for Conc
        Nexp = length(Time);
        for i = 1:Nexp
            
            plot(Time{i},Conc{i}(:,SpeciestoPlot))
            hold on
            
        end %plotting loop
        ylab_str = sprintf('%s [molar]',app.Model.Species(SpeciestoPlot).Name);
        ylabel(ylab_str, 'Interpreter','none')
    case 'Count'
        %% Generate Plot for Count
        Nexp = length(Time);
        for i = 1:Nexp
            plot(Time{i},Count{i}(:,SpeciestoPlot))
            hold on
            
        end %plotting loop
        
        ylab_str = sprintf('%s [number/cell]',app.Model.Species(SpeciestoPlot).Name);
        ylabel(ylab_str,'Interpreter','none')
end
%% Plot information
legend(ExperimentString, 'Location', 'NorthWest')
xlab_str = sprintf('Time [%s]',app.TimeUnits);
xlabel(xlab_str)

end %function