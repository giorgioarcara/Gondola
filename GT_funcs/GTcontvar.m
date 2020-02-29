% GTcontvar(GTres, resfield, contvarfield, contvarvalues)
%
% This function takes as input a GTres struct and create a new object
% in wich the data of resfield are "averaged" according to the values
% of a continuous variable. (this can be used to average values according
% to a threshold).
%
%
% INPUT
% - GTres: the GTres struct with the results
% - resfield: the name of the field that will be takein into account
%
% NOTE: the function some all the values and then divide by the numebrs
%       so missing values can lead to wrong resuls 
%
%
% Author: Giorgio Arcara
%
% version: 12/01/2018
%

function GTcontvar_res = GTcontvar(GTres, resfield, contvarfield, contvarvalues);

% transform cont_var to string (for usage of other function)

GTcontvar_res = struct();
GTcontvar_res.(contvarfield) = contvarvalues;
GTcontvar_res.(resfield) = [];

for iVar = 1:length(contvarvalues);
        
    GTres_sel = GTsel(GTres, contvarfield, contvarvalues);   
        
    if (length(GTres_sel)==0)
        if isnumeric(contvarvalues(iVar))
            curr_var = num2str(contvarvalues(iVar));
        end;   
        error(['the object with ', contvarfield, ' = ', curr_var, ' is empty']);
    end;
    
    
    GTres_sel_ave = GTaverage(GTres_sel, {resfield});
    
    GTcontvar_res.(resfield) = [GTcontvar_res.(resfield); GTres_sel_ave.(resfield)]; % update incrementally

        
end;
     
end



