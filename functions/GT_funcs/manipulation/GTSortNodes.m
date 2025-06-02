function CMres = GTSortNodes(GTstruct, opt )
    arguments
        GTstruct (1, :) struct
        opt.OrNodes (1, :) cell
        opt.TargetNodes (1, :) cell
        opt.Field (1, 1) char
        opt.OtherFields (1, :) cell
        opt.Indices (1, :) uint32
    end
    







%% GTSortNodes - reorders nodes in adjanency matrices based on a new node order or index
%
% CMres = GTSortNodes(GTstruct, 'OrNodes', {value}, 'TargetNodes', {value}, 
%                     'Field', 'fieldname', 'OtherFields', {value}, 'Indices', [value])
%
% This function reorders the rows and columns of an adjacency matrix field
% (e.g., a connectivity matrix) in a GTstruct, according to a new node
% order or provided index. It is used to standardize the order of nodes
% across multiple subjects or conditions.
%
% Inputs:
%   GTstruct (struct): A GTstruct object
%
%   OrNodes (cell, optional): Cell array with the original node labels
%   (must match the order in the matrix)
%
%   TargetNodes (cell, optional): Cell array specifying the desired node
%   order
%
%   Field (string, optional): String name of the field containing the
%   matrix to reorder
%
%   OtherFields (string, optional): Cell array with names of other fields
%   to be inherited in the output GTstruct
%
%   Indices (uint32, optional): Vector of indices to directly reorder the
%   matrix. Overrides 'OtherFields'
%
% Ouput:
%   CMres (struct): Struct array with matrices reordered according to
%   TargetNodes or Indices
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
%
% Version: 28/05/2025


% initialize empty object
if (~isempty(OtherFields));
    
    CMres_temp=struct();
    
    % get other fields if specified
    if (exist('OtherFields')&~isempty('OtherFields'))
        % first copy all the other fields
        for fn = OtherFields
            for isubj = 1:length(CMstruct);
                CMres_temp(isubj).(fn{1}) = CMstruct(isubj).(fn{1});
                
            end
        end
    end
    
elseif (isempty(OtherFields))
    
    % inherit all fields if OtherFields is not specified
    CMres_temp = CMstruct;
    
end;

% case one
if ~(isempty(TargetNodes)&isempty(OrNodes))
    
    % find indices of Node
    [~, ~, New_Node_ind] = intersect(TargetNodes, OrNodes, 'stable');
    
else
    New_Node_ind = Indices;
    
end;

% loop over all elements in the struct and select
for k=1:length(CMstruct);
    curr_data = CMstruct(k).(Field);
    sel_data = curr_data(New_Node_ind, New_Node_ind);
    CMres_temp(k).(Field) = sel_data;
end;


CMres = CMres_temp;





