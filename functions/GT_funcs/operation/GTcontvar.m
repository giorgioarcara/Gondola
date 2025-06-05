function GTcontvar_res = GTcontvarave(GTstruct, opt);
    arguments
        GTstruct (1, :) struct
        opt.Field (1,1) sting
        opt.ContVarField (1, :) cell
        opt.ContVarValues (1, :) uint32
    end
    






%% GTcontvarave - Averages field values according to a continuous variable
%
% GTcontvarave(GTstruct, 'Field', value, 'ContVarField', value, 'ContVarValues', value)

% This function takes as input a GTstruct and averages the values in a specified field
% (e.g., a matrix) according to levels of a continuous variable (e.g., threshold).
%
%
% Inputs:
%   GTstruct (struct): GTstruct object
%
%   Field (string, optional): Name of the field containing the data to average
%
%   ContVarField (cell, optional): Name of the field with the continous
%   grouping variable
%
%   ContVarValues (uint32, optional): Values of the continuous variable
%   selected for the averaging
%
% Output: 
%   GTcontvar_res (struct): Struct contraining the average data for the
%   corresponding ContVarValue
%
% Warning:
%   Missing value are not handled explicitly and will affect the result
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
%
% Version: 29/05/2025
%
% 
%


% transform cont_var to string (for usage of other function)

GTcontvar_res = struct();
GTcontvar_res.(ContVarField) = ContVarValues;
GTcontvar_res.(Field) = [];

for iVar = 1:length(ContVarValues);
    
    GTstruct_sel = GTsel(GTstruct, ContVarField, ContVarValues);
    
    if (length(GTstruct_sel)==0)
        if isnumeric(ContVarValues(iVar))
            curr_var = num2str(ContVarValues(iVar));
        end;
        error(['the object with ', ContVarField, ' = ', curr_var, ' is empty']);
    end;
    
    
    GTstruct_sel_ave = GTaverage(GTstruct_sel, 'InFields', {Field});
    
    GTcontvar_res.(Field) = [GTcontvar_res.(Field); GTstruct_sel_ave.(Field)]; % update incrementally
    
    
end;

end



