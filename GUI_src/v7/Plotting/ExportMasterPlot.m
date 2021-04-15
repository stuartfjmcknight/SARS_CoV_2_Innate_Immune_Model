function ExportMasterPlot(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 21Mar2021
%% ---------------------
% This function will make the same plate as the Custom selection, however
% will export it into its own window.
MasterPlot = app.MasterPlot;

figure()
% Generate the Plot
plot(MasterPlot.Time,MasterPlot.SelectedTrajectories, 'LineWidth',2)

% Add a legend to the Plot
legend(MasterPlot.SpeciesToPlotString, 'Location','NorthEast','Interpreter','none')

% Label Axis
str_xlab = sprintf('Time %s',app.TimeUnits);
xlabel(str_xlab);
ylabel('SARS-CoV-2  [moles/L]')

end
