function SpeciesTableIndexAndValueToUpdate(app, Index, NewData)
%% Build vecotr of indecies to change and value to change them to
% Last Edit: Stuart McKnight on 21Mar2021
%% ---------------------
% This function will build a vector of the indecies which are changed in
% the table. Additionally, this function will keep track of the values that
% the species with the given index will be changed to. 

% This vector of indecies and values will then be fed into a script which
% will make the species modifications for the specified index, and change
% that to the value defined. This parameter updating will take place when
% the button is pressed, not as the user changes the values in the GUI.


% This vector of indecies is empty [], when the GUI is started, and then
% when the value is changed in the table it is populated. It keeps building
% on itself as the user defines more species indecies to change.
app.SpeciesIndexToChange = [app.SpeciesIndexToChange,Index];
% Once the vector has been used in the species modification script, the
% vector will be set back to an empty [] vector.


% The same logic as above is used for the new data
app.SpeciesNewValueToChage = [app.SpeciesNewValueToChage,NewData];

end %function