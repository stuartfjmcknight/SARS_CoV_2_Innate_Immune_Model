function SensPlotting(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 26Mar2021
%% ---------------------

%% Load in Data for Plotting

Time = app.SensResults.Time;
Count = app.SensResults.Count;
Conc = app.SensResults.Conc;

%% Species to Plot
SpeciestoPlot = app.SensSpeciesToPlot;

%% Legend
Experiments = app.SensParamTable.Data(:,1);
ExperimentString = strings(length(Experiments),1);
for j = 1:length(Experiments)
    ExperimentString(j) = string(sprintf('Experiment %s',Experiments(j)));
end
cla(app.UISensAxes)
switch app.SensPlotConcOrCountDropDown.Value
    case 'Conc'
        %% Generate Plot for Conc
        Nexp = length(Time);
        maxTime = zeros(Nexp,1);
        maxSpecies = zeros(Nexp,1);
        for i = 1:Nexp
            
            plot(app.UISensAxes,Time{i},Conc{i}(:,SpeciestoPlot),'LineWidth',2)
            hold(app.UISensAxes,'on');
            maxTime(i) = max(Time{i});
            maxSpecies(i) = max(Conc{i}(:,SpeciestoPlot));
            
            
        end %plotting loop
        ylab_str = sprintf('%s [molar]',app.Model.Species(SpeciestoPlot).Name);        
        ylabel(app.UISensAxes, ylab_str,'Interpreter','none')
        
    case 'Count'
        %% Generate Plot for Count
        Nexp = length(Time);
        maxTime = zeros(Nexp,1);
        maxSpecies = zeros(Nexp,1);
        for i = 1:Nexp
            plot(app.UISensAxes,Time{i},Count{i}(:,SpeciestoPlot),'LineWidth',2)
            hold(app.UISensAxes,'on');
            maxTime(i) = max(Time{i});
            maxSpecies(i) = max(Count{i}(:,SpeciestoPlot));
            
        end %plotting loop
        ylab_str = sprintf('%s [number/cell]',app.Model.Species(SpeciestoPlot).Name);
        ylabel(app.UISensAxes, ylab_str,'Interpreter','none')
end

%% Plot information
legend(app.UISensAxes, ExperimentString, 'Location', 'NorthWest')
xlab_str = sprintf('Time [%s]',app.TimeUnits);
xlabel(app.UISensAxes, xlab_str)

%% Update Sliders on GUI
app.XMinSensPlot.Limits = [0,max(maxTime)];
app.XMinSensPlot.Value = 0;
app.XMaxSensPlot.Limits = [0,max(maxTime)];
app.XMaxSensPlot.Value = max(maxTime);

app.YMinSensPlot.Limits = [0,max(maxSpecies)];
app.YMinSensPlot.Value = 0;
app.YMaxSensPlot.Limits = [0,max(maxSpecies)];
app.YMaxSensPlot.Value = max(maxSpecies);


end %function