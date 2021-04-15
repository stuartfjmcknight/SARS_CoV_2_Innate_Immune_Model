function ExportResultsAsCSV(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 9Jan2021
%% ---------------------
%% Function Info
% This function is used to export the Results structure from the model
% simulation into a csv. This allows the user to run the simulation and
% then exort the results as a .csv file.

%% Isolate Data
Time = app.Results.Time;
Trajecotries = app.Results.Count;
Species_Name = app.Results.Names';
%% Build Table
time_traj = [Time,Trajecotries];
Name = string(['Time',Species_Name]);
T = array2table([Name;time_traj]);

%% Prevent Over-writing existing data
FileName = [app.ResultsFileNameEditField.Value,'.csv'];

if isfile(['Model Generated Data/',FileName]) %search for the file name to see if it already exists
    warning('Filename already existis')
    disp('You will override data')
    confirm = input('do you want to override this data? [Y/N]: ','s'); %the file exists, have the user say if they want to override the existing file
    if confirm == 'Y'
        writetable(T,['Model Generated Data/',FileName]) % create the excel spreadsheet
        fprintf('File generated with name: %s\n',FileName)
    elseif confirm == 'N'
        disp("Close call - Existing spreadsheet was not overwritten")
    else
        disp('Must respond with Y or N')
    end
else
    writetable(T,['Model Generated Data/',FileName]) %make the spreadsheet
    fprintf('File generated with name: %s\n',FileName)
end





end %function