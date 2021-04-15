function SaveMasterPlot(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 21Mar2021
%% ---------------------
% This function will make the same plate as the Custom selection,and save
% it as a jpg witht the provided filename.

MasterPlot = app.MasterPlot;
FileName = app.SavePlotFileNameEditField.Value;

figure()
% Generate the Plot
plot(MasterPlot.Time,MasterPlot.SelectedTrajectories, 'LineWidth',2)

% Add a legend to the Plot
legend(MasterPlot.SpeciesToPlotString, 'Location','NorthEast','Interpreter','none')

% Label Axis
str_xlab = sprintf('Time %s',app.TimeUnits);
xlabel(str_xlab);
ylabel('SARS-CoV-2  [moles/L]')

PathString = sprintf('Model Generated Plots/');
FileNameString = char(sprintf('%s%s.jpg',PathString,FileName));

saveas(gcf, FileNameString)

fprintf('Plot Generaated with name %s.jpg\n',FileName)
end