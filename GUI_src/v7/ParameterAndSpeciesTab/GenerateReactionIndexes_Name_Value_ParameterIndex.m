function GenerateReactionIndexes_Name_Value_ParameterIndex(app)
%% Modify only changed species in the table
% Last Edit: Stuart McKnight on 24Mar2021
%% ---------------------


Model = app.Model;
%Model = sbioloadproject('Models/PC_MARCH18_Endofday_timescale.sbproj').m1;

N = length(Model.Reactions); %determine the number of reactions

% Set a counter. This will be used as the row of the spreadsheet. Since
% some reactions have muliple rate constants, the number of rows in the in
% the matrix will not match the number of reactions. This counter is k.
k = 1;
for i = 1:N
    j = length(Model.Reactions(i).KineticLaw.Parameters); %determine how many rate constants go with the ith reaction
    if j > 1 % This part of the function inside this if statement is run when there is more than 1 rate parameter for the reaction.
        % Another for loop will be used to modify each of the reaction
        % parameters within the ith reaction. This is why the counter k is
        % important to build the rows of the matrix.
        for ii = 1:j
            Reaction_Name(k,1) = string(Model.Reactions(i).Name); % extract the name of the ith reaction
            Reaction_Index(k,1) = string(i); % Each reaction has a corresponding reaction index, this is kept track of here.
            RateConstantName(k,1) = string(Model.Reactions(i).KineticLaw.Parameters(ii).Name); % Extract the name of the rate constant
            %RateEquation(k,1) = string(Model.Reactions(i).ReactionRate); % Extract the rate reaction equation
            %ChemicalEquation(k,1) = string(Model.Reaction(i).Reaction); % Extract the chemical euqation
            Value(k,1) = string(Model.Reactions(i).KineticLaw.Parameters(ii).Value); % Extract the value of the rate constant
            Units(k,1) = string(Model.Reactions(i).KineticLaw.Parameters(ii).Units); % Extract the units of the rate constant
            %Sources(k,1) = " ";
            k = k+1; % update the counter to add another row to the growing matrix
        end
    else
        Reaction_Name(k,1) = string(Model.Reactions(i).Name); % extract the name of the ith reaction
        Reaction_Index(k,1) = string(i); % Each reaction has a corresponding reaction index, this is kept track of here.
        RateConstantName(k,1) = string(Model.Reactions(i).KineticLaw.Parameters.Name); % Extract the name of the rate constant
        %RateEquation(k,1) = string(Model.Reactions(i).ReactionRate); % Extract the rate reaction equation
        %ChemicalEquation(k,1) = string(Model.Reaction(i).Reaction); % Extract the chemical euqation
        Value(k,1) = string(Model.Reactions(i).KineticLaw.Parameters.Value); % Extract the value of the rate constant
        Units(k,1) = string(Model.Reactions(i).KineticLaw.Parameters.Units); % Extract the units of the rate constant
        %Sources(k,1) = " ";
        k = k+1; % update the counter to add another row to the growing matrix
    end
    
end
Reaction_Index_Double = str2double(Reaction_Index)';

%% Generate a vector of the Parameter Indexes for the different reactions
count = 1;
for i = 1:max(Reaction_Index_Double)
    
    [index,val] = find(Reaction_Index_Double == i);
    
    subcount = 1;
    if length(index) > 1
        for j = 1:length(index)
            Param_Index(count) = subcount;
            Reaction_Index(count) = i;
            subcount = subcount + 1;
            RxnCount(count,1) = string(count);
            count = count+1;
        end
    end
    if length(index)==1
        Param_Index(count) = 1;
        Reaction_Index(count) = i;
        RxnCount(count,1) = string(count);
        count = count+1;
    end
end
Parameter_Index = string(Param_Index)';
T = table(Reaction_Name, Reaction_Index, RateConstantName,Parameter_Index, Value, Units, RxnCount); % Build the table that will be exported.

app.ModelReactionInformation = T; %save this useful table of properties as a propery of the app


end %function