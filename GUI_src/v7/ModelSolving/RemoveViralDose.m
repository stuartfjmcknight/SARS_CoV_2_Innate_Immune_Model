function RemoveViralDose(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 9Jan2021
%% ---------------------
%% This function will remove all of the dosing regimes which are stored under the model. 
% By removing the dosing regimes, you are able to use the SSA solver.


N = length(getdose(app.Model));
dosings = getdose(app.Model);

for i = 1:N
    
DoseName = dosings(i).Name;
removedose(app.Model,DoseName);

end %look to delete
end %function