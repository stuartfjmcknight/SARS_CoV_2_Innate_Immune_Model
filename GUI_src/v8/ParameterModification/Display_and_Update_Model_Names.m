function Display_and_Update_Model_Names(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 12Feb2021
%% ---------------------

%% Figure out which file names exist within a folder
files = dir('Models/');

N_models = length(files);
count = 1;
for i = 1:N_models
    try
        if files(i).name(end-6:end) == '.sbproj'
            Model_File_Names(count) = string(files(i).name);
            count = count+1;
        end
    catch
        fprintf("File named '%s' skipped.\n",files(i).name)
    end
end

%% Turn this into a string
app.ModelNameDropDown.Items = Model_File_Names;
app.Model = sbioloadproject(Model_File_Names(1)).m1;
end %function