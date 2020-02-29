%% GTdiag_mat(GTstruct, resfield, type);
%
% This function extract (from a GTstruct) the upper or lower
% triangular matrix (diagonal excluded), substituting with NaN, all other
% values.
%
% INPUT:
%
% - GTres: a struct, resullting from BCT script analysis
% - field: the field for the selection
% - type: 'upper' or 'lower'.

function GTres_diag = GTdiag_mat(GTstruct, resfield, type)

if nargin < 3
    type == 'upper'
end;

GTres_diag = GTstruct;

if strcmp(type, 'upper')
    
    % loop over all objects in GTstruct and compute the measure.
    for iK = 1:length(GTstruct)
        
        curr_res_field = triu(GTstruct(iK).(resfield));
        
        % generate mask only at first loop
        if iK==1
            x = logical(tril(ones(size(curr_res_field))));
        end;
        
        curr_res_field(x==1) = NaN ;
        
        GTres_diag(iK).(resfield) = curr_res_field;

    end;  
end

if  strcmp(type, 'lower')
    
    % loop over all objects in GTstruct and compute the measure.
    for iK = 1:length(GTstruct)
        
        curr_res_field = tril(GTstruct(iK).(resfield))
        
        % generate mask only at first loop
        if ik==1
            x = logical(triu(ones(size(curr_res_field))));
        end;
        
        curr_res_field(x==1) = NaN ;
        
        GTres_diag(iK).(resfield) = curr_res_field;

    end;  
end







