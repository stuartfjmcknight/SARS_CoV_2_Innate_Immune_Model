function SensSolveSimulations(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 26Mar2021
%% ---------------------

%% Load Model
Model = app.Model;

%% Gather Reaction Index and Parameter Index
ReactionIndex = app.SensRxnIndexToChange;
ParameterIndex = app.SensParmIndexToChange;

%% Collect New Parameter Values
NewRateConstantMatrix = double(app.SensParamTable.Data(:,2:end));

%% Load Solver Options
% The solver options are the same as was input on the Solving the Model Tab
SolverOptions = app.SolverProperties;

%% Load Exposure options
% The exposure options are based on what is defined in the Solving the
% Model Tab
Exposure = sbiodose('Exposure','Schedule');
Exposure.TargetName = 'Covid';
Exposure.TimeUnit = 'hour';
Exposure.Time = app.ExposureProperties.Time;
Exposure.Amount = app.ExposureProperties.Amount;
Exposure.Active = 1;

%% Itterate over each of the experiments (Rows of the table)
NumExps = size(NewRateConstantMatrix,1);
NumParams = size(NewRateConstantMatrix,2);
f = waitbar(0,"Starting Simulation");


for i = 1:NumExps
    for j = 1:NumParams
        Model.Reactions(ReactionIndex(j)).KineticLaw.Parameters(ParameterIndex(j)).Value = ...
            NewRateConstantMatrix(i,j);
    end
    
    % Solver Configuration and Exposure were set outside of the loop
    app.SensSolvingUpdateEditField.Value = " ";
    app.SensSolvingUpdateEditField.Value = sprintf("Solving Experiment %s",num2str(i));
    app.SensSolvingUpdateEditField.FontColor = [1,0.77,0.06];
    
    try
        waitbar(i/NumExps,f,sprintf("Solving Experiment %s",num2str(i)));

        tic
        [t,x,names] = sbiosimulate(Model,SolverOptions,Exposure);
        pause(0.02)
        toc
        
        app.SensResults.Time{i} = t;
        app.SensResults.Conc{i} = x;
        app.SensResults.Names{i} = names;
        
        %% Conver to Count
        % This will convert the concentration calcualtion and return the count of
        % species in the cell
        app.SensResults.Count{i} = x * app.CellVolume * app.AvogadrosNumber;
        error_happen = 0;
    catch
        errordlg('Parameter set is resulting in Solver Error. Please adjust parameter set and try again. Some of your parameters might be too large or too small. Also, consider changing the solver being used.','Solver Error','replace');
        app.SensPlottingTab.SelectedTab = app.SensitivitySolverTab;
        warning('Parameter set is resulting in Solver Error. Please adjust parameter set and try again. Some of your parameters might be too large or too small. Also, consider changing the solver being used.')
        app.SensPlottingTab.SelectedTab = app.SensitivitySolverTab; %Change tab back to parameter modifications
        error_happen(i) = 1;
        fprintf('Experiment %i did not solve\n',i)
    end
    
end
if sum(error_happen) == 0
    % Change Tab to select species to plot
    app.SensPlottingTab.SelectedTab = app.SensSpeciesToPlotTab;
    % Update Solving status box
    app.SensSolvingUpdateEditField.Value = " ";
    app.SensSolvingUpdateEditField.Value = " All Experiments Solved! ";
    app.SensSolvingUpdateEditField.FontColor = [0.39,0.83,0.07];
end

if sum(error_happen) ~= 1
    % Update Solving status box
    app.SensSolvingUpdateEditField.Value = " ";
    app.SensSolvingUpdateEditField.Value = " Solver Error - Did not solve all Experiments ";
    app.SensSolvingUpdateEditField.FontColor = [1,0,0];

end

waitbar(1,f,"Done")
pause(0.75)
delete(f)
figure(app.SARSCoV2ModelUIFigure)
end %function