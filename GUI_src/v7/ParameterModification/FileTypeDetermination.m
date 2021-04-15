function File_Type = FileTypeDetermination(SpreadsheetName)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 21Mar2021
%% ---------------------
%% Help Section
% This function is used to determine the file type that is imported into
% the GUI. The File_Type is then used to determine which data loading
% function should be used to import the spreadsheet into Matlab.

%% For debugging
%SpreadsheetName = m.ParameterSpreadsheetNameEditField.Value;


%% File type determination
SpreadsheetName_char = char(SpreadsheetName);
if strcmp(string(SpreadsheetName_char(end-4:end)),".xlsx")
    File_Type = ".xlsx";
    fprintf('The import file is %s',File_Type)
elseif strcmp(string(SpreadsheetName_char(end-3:end)),".xls")
    File_Type = ".xls";
    fprintf('The import file is %s',File_Type)
elseif strcmp(string(SpreadsheetName_char(end-3:end)),".csv")
    File_Type = ".csv";
    fprintf('The import file is %s',File_Type)
else 
    disp('File type is not recognized')
end


end %end to function
