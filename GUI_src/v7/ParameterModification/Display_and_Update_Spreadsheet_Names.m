function Display_and_Update_Spreadsheet_Names(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 12Feb2021
%% ---------------------
%% Figure out which file names exist within a folder
files = dir('SpeciesParameterConventions/');

N_files = length(files);
count = 1;
for i = 1:N_files
    try
        if string(files(i).name(end-3:end)) == ".csv" || string(files(i).name(end-4:end)) == ".xlsx" || string(files(i).name(end-3:end)) == ".xls"
            File_Names(count) = string(files(i).name);
            count = count+1;
        end
    catch
        fprintf("File named '%s' skipped.\n",files(i).name)
    end
end

%% Turn this into a string
app.ParameterSpreadsheetNameDropDown.Items = File_Names;
app.SpeciesSpreadsheetNameDropDown.Items = File_Names;

end %function