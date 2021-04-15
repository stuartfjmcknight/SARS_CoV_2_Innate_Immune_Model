function RunModelSimulation(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 21Mar2021
%% ---------------------
%% Function Information
% This function is used to run the model. It first inputs the solver
% configuration set which is defined by either the advanced settings or the
% default settings. This function then sets the dosing regime which is
% defined in the viral exposure function. Once the parameters for the
% solver and the initial viral dose has been set. The results of this
% function are stored in a structure call Results.


%% Define the Model

%% create dosing object
Exposure = sbiodose('Exposure','Schedule');
Exposure.TargetName = 'Covid';
Exposure.TimeUnit = 'hour';
Exposure.Time = app.ExposureProperties.Time;
Exposure.Amount = app.ExposureProperties.Amount;
Exposure.Active = 1;

app.ModelSolvingUpdate.Value = " ";
app.ModelSolvingUpdate.FontColor = [1,0.77,0.06];
app.ModelSolvingUpdate.Value = "Solving Model...";
pause(0.0001)

%% Run the Simulation

try
    tic
    [t,x,names] = sbiosimulate(app.Model,app.SolverProperties,Exposure);
    %pause(0.2)
    toc
    app.ModelSolvingUpdate.Value = " ";
    app.ModelSolvingUpdate.FontColor = [0.39,0.83,0.07];
    app.ModelSolvingUpdate.Value = "Finished Solving!";
    app.Results.Time = t;
    app.Results.Conc = x;
    app.Results.Names = names;
    
    %% Conver to Count
    % This will convert the concentration calcualtion and return the count of
    % species in the cell
    app.Results.Count = app.Results.Conc * app.CellVolume * app.AvogadrosNumber;
    app.SimErrorHappen = 0;
    
catch
    errordlg('Parameter set is resulting in Solver Error. Please adjust parameter set and try again. Some of your parameters might be too large or too small. Also, consider changing the solver being used.','Solver Error');
    warning('Parameter set is resulting in Solver Error. Please adjust parameter set and try again. Some of your parameters might be too large or too small. Also, consider changing the solver being used.')
    app.SimErrorHappen = 1;
end
end % function