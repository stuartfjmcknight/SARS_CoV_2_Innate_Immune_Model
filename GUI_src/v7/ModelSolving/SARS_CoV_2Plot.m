function SARS_CoV_2Plot(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 21Mar2021
%% ---------------------
%% Function Info
% This function is used to generate a small plot which is used to display
% the intracellular SARS level as well as the extracellular SARS levels.
% This function uses the Result structure which is populated by running the
% simulation.

switch app.ConcOrCountDropDown.Value;
    case 'Conc'
        
        t = app.Results.Time;
        xextracell = app.Results.Conc(:,4); % Extracellular
        xcell = app.Results.Conc(:,21); % Intracellular
        
        plot(app.UIAxes,t,xextracell,t,xcell,'LineWidth',1.5)
        xlim(app.UIAxes, [app.XMinSlider.Value, app.XMaxSlider.Value])
        legend(app.UIAxes,'Extracellular','Intracellular')
        str_xlab = sprintf('Time %s',app.TimeUnits);
        xlabel(app.UIAxes,str_xlab);
        ylabel(app.UIAxes,'[SARS-CoV-2  [moles/L]')
        
    case 'Count'
        
        
        t = app.Results.Time;
        xextracell = app.Results.Count(:,4); % Extracellular
        xcell = app.Results.Conc(:,21); % Intracellular
        
        plot(app.UIAxes,t,xextracell,t,xcell,'LineWidth',1.5)
        xlim(app.UIAxes, [app.XMinSlider.Value, app.XMaxSlider.Value])
        legend(app.UIAxes,'Extracellular','Intracellular')
        str_xlab = sprintf('Time %s',app.TimeUnits);
        xlabel(app.UIAxes,str_xlab);
        ylabel(app.UIAxes,'[SARS-CoV-2  [count/cell]')
        
end

end
