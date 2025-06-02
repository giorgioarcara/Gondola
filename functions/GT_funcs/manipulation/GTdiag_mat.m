%% GTdiag_mat - extracts diagonal-free upper or lower triangle of a matrix field from a GTstruct.
%
% GTstruct_diag = GTdiag_mat(GTstruct, 'Field', value, 'Type', value, 'NewValue', value)
%
% This function extracts either the upper or lower triangle (excluding the diagonal)
% from a matrix stored in the specified field of each element in a GTstruct.
% The remaining entries are replaced with NaN, and the result is stored in a new field.
%
% Inputs:
%   GTstruct (struct): A GTstruct resulting from BCT analysis or similar.
%
%   Field (string, optional): The name of the field in GTstruct containing the matrix to be processed.
%   
%   Type (string): Either 'upper' or 'lower' to specify which triangle to retain. Default: 'upper'.
%   
%   NewValue (string): The name of the new field where the masked matrix will be saved.
%
% Output:
%   GTstruct_diag (struct): The modified GTstruct including the new field with diagonal-free matrices.
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
%
% Version: 20/05/2025

function GTstruct_diag = GTdiag_mat(GTstruct, opt)
    arguments
        GTstruct (1, :) struct
        opt.Field (1, 1) string
        opt.Type (1, 1) string = "upper"
        opt.NewValue (1, 1) string 
    end
    


Field = opt.Field;
Type =  opt.Type;
NewValue = opt.NewValue;



if isempty(Type)
    Type = 'upper';
end;

GTstruct_diag = GTstruct;

if strcmp(Type, 'upper')
    
    % loop over all objects in GTstruct and compute the measure.
    for iK = 1:length(GTstruct)
        
        curr_res_field = triu(GTstruct(iK).(Field));
        
        % generate mask only at first loop
        if iK==1
            x = logical(tril(ones(size(curr_res_field))));
        end;
        
        curr_res_field(x==1) = NaN ;
        
        GTstruct_diag(iK).(NewValue) = curr_res_field;

    end;  
end

if  strcmp(Type, 'lower')
    
    % loop over all objects in GTstruct and compute the measure.
    for iK = 1:length(GTstruct)
        
        curr_res_field = tril(GTstruct(iK).(Field))
        
        % generate mask only at first loop
        if ik==1
            x = logical(triu(ones(size(curr_res_field))));
        end;
        
        curr_res_field(x==1) = NaN ;
        
        GTstruct_diag(iK).(NewValue) = curr_res_field;

    end;  
end







