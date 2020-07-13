%% GTdiag_mat(GTstruct, 'InField', value, 'Type', value, 'OutField', value);
%
% This function extract (from a GTstruct) the upper or lower
% triangular matrix (diagonal excluded), substituting with NaN, all other
% values.
%
% INPUT:
%
% - GTstruct: a struct, resullting from BCT script analysis
% - InField: the field for the selection
% - Type: 'upper' or 'lower'.

function GTstruct_diag = GTdiag_mat(GTstruct, varargin)

p = inputParser;
addParameter(p, 'InField', [], @ischar);
addParameter(p, 'Type', [], @ischar);
addParameter(p, 'OutField', [], @ischar);

parse(p, varargin{:});

InField = p.Results.InField;
Type =  p.Results.Type;
OutField = p.Results.OutField;



if isempty(Type)
    Type = 'upper';
end;

GTstruct_diag = GTstruct;

if strcmp(Type, 'upper')
    
    % loop over all objects in GTstruct and compute the measure.
    for iK = 1:length(GTstruct)
        
        curr_res_field = triu(GTstruct(iK).(InField));
        
        % generate mask only at first loop
        if iK==1
            x = logical(tril(ones(size(curr_res_field))));
        end;
        
        curr_res_field(x==1) = NaN ;
        
        GTstruct_diag(iK).(OutField) = curr_res_field;

    end;  
end

if  strcmp(Type, 'lower')
    
    % loop over all objects in GTstruct and compute the measure.
    for iK = 1:length(GTstruct)
        
        curr_res_field = tril(GTstruct(iK).(InField))
        
        % generate mask only at first loop
        if ik==1
            x = logical(triu(ones(size(curr_res_field))));
        end;
        
        curr_res_field(x==1) = NaN ;
        
        GTstruct_diag(iK).(OutField) = curr_res_field;

    end;  
end







