function GTres = GTNodeSel(GTstruct, opt)
    arguments
        GTstruct (1, :) struct
        opt.Nodes (1, :) cell
        opt.SelNodes (1, :) cell
        opt.Field (1, 1) string
        opt.OtherFields (1,:) cell
        opt.Indices (1, :) uint32
    end




%% GTNodeSel - extracts a node subset from adjacency matrices in a GTstruct
%
% GTres = GTNodeSel(GTstruct, 'Nodes', {value}, 'SelNodes', {value}, 'Field', value, 'OtherFields', {value}, 'Indices', value)
% 
% This function extracts a submatrix of the adjacency matrix in each GTstruct
% element, selecting only the nodes of interest based on their labels or
% provided indices. The resulting GTstruct contains only the selected nodes.
%.
%
%
% Inputs:
%   GTstruct (struct): A GTstruct object
%
%   Nodes (cell, optional): A cell array containing the names of the nodes.
%   The length should match the dimensions of the adjency matrix
%
%   SelNodes (cell, optional): A cell array with the names of the nodes to
%   select
%
%   Field (string, optional): The name of the field containing the FC matrix
%   to be sliced
%
%   OtherFields (cell, optional): A cell array with the names of other
%   fields to be retained in the output struct
%
%   Indices (uint32, optional): Vector of indices to select specific nodes
%   directly, overriding SelNodes if provided
%
% Output:
%   GTres (struct): A GTstruct with matrices and fields restricted to the
%   selected ones
%
% Note:
%   If both 'SelNodes' and 'Indices' are provided, 'Indices' takes
%   precedence
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
%
% Version: 28/05/2025


% initialize empty object
if (~isempty(OtherFields));
    
    GTres_temp=struct();
    
    % get other fields if specified
    if (exist('OtherFields')&~isempty('OtherFields'))
        % first copy all the other fields
        for fn = OtherFields
            for isubj = 1:length(GTstruct);
                GTres_temp(isubj).(fn{1}) = GTstruct(isubj).(fn{1});
            end
        end
    end
    
elseif (isempty(OtherFields))
    
    % inherit all fields if OtherFields is not specified
    GTres_temp = GTstruct;
    
end;

% find indices of Node
%[~, Node_ind, ~] = intersect(Nodes, SelNodes, 'stable');
if (isempty(Indices))
    Node_ind = find(ismember(Nodes, SelNodes));
else
    Node_ind = Indices;
end;

% loop over all elements in the struct and select
for k=1:length(GTstruct);
    curr_data = GTstruct(k).(Field);
    sel_data = curr_data(Node_ind, Node_ind);
    GTres_temp(k).(Field) = sel_data;
end;

GTres = GTres_temp;





