function ParameterTableIndexAndValueToUpdate(app, Index, NewData)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 24Mar2021
%% ---------------------
%% Build vecotr of indecies to change and value to change them to
% This function will build a vector of the indecies which are changed in
% the table. Additionally, this function will keep track of the values that
% the paramter with the given index will be changed to. 

% This vector of indecies and values will then be fed into a script which
% will make the parameter modifications for the specified index, and change
% that to the value defined. This parameter updating will take place when
% the button is pressed, not as the user changes the values in the GUI.


% This vector of indecies is empty [], when the GUI is started, and then
% when the value is changed in the table it is populated. It keeps building
% on itself as the user defines more parameter indecies to change.
app.ParameterIndexToChange = [app.ParameterIndexToChange,Index];
% Once the vector has been used in the parameter modification script, the
% vector will be set back to an empty [] vector.


% The same logic as above is used for the new data
app.ParameterNewValueToChage = [app.ParameterNewValueToChage,NewData];

end %function