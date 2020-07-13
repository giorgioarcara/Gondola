%% GTcontvarave(GTstruct, 'InField', value, 'ContVarField', value, 'ContVarValues', value)
%
% This function takes as input a GTstruct struct and create a new object
% in wich the data of InField are "averaged" according to the values
% of a continuous variable. (this can be used to average values according
% to a threshold).
%
%
% INPUT
% - GTstruct: the GTstruct struct with the results
% - InField: the name of the field that will be takein into account
% - ContVarField:the name of the field of the continous variable selected
% for the averaging
% - ContVarValues: value of the continous variable selected for the
% averaging

% NOTE: the function some all the values and then divide by the numbers
%       so missing values can lead to wrong resuls
%
%
% Author: Giorgio Arcara
%
% version: 12/01/2018
%

function GTcontvar_res = GTcontvarave(GTstruct, varargin);

p = inputParser;
addParameter(p, 'InField', [], @ischar);
addParameter(p, 'ContVarField', [], @iscell);
addParameter(p, 'ContVarValues', [], @isnumeric);


parse(p, varargin{:});

InField = p.Results.InField;
ContVarField =  p.Results.ContVarField;
ContVarValues =  p.Results.ContVarValues;

% transform cont_var to string (for usage of other function)

GTcontvar_res = struct();
GTcontvar_res.(ContVarField) = ContVarValues;
GTcontvar_res.(InField) = [];

for iVar = 1:length(ContVarValues);
    
    GTstruct_sel = GTsel(GTstruct, ContVarField, ContVarValues);
    
    if (length(GTstruct_sel)==0)
        if isnumeric(ContVarValues(iVar))
            curr_var = num2str(ContVarValues(iVar));
        end;
        error(['the object with ', ContVarField, ' = ', curr_var, ' is empty']);
    end;
    
    
    GTstruct_sel_ave = GTaverage(GTstruct_sel, 'InFields', {InField});
    
    GTcontvar_res.(InField) = [GTcontvar_res.(InField); GTstruct_sel_ave.(InField)]; % update incrementally
    
    
end;

end



