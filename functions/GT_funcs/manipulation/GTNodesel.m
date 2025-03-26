%% GTNodeSel(GTstruct, 'Nodes', {value}, 'SelNodes', value, 'DataField', value, 'OtherFields', value, 'Indices', value);
%
% This function start from a GT struct. It selects the rows and columns of the adjacency matrix data
% given some names, supplied as a cell and associated to nodes (i.e., rows
% and columns).
%
%
% INPUT:
%
% - GTstruct: a struct for analysis Gondola
% - Nodes: the cell containing the names of the Node. The length should be
%            the same of the Rows and columns of the adjacency matrix,
%            supplied as DataField.
% - SelNodes: a cell with the names of the Nodes to be selected.
% - DataField: the name of the field containing the adjacency matrices.
% - othersfields: a cell with name of fields that should be inherited from
% - indices: a vector indicating which nodes to select (override other
% values).
% GTstruct.
%
%
% Author: Giorgio Arcara
% Data: 20/02/2021

function GTres = GTNodeSel(GTstruct, varargin)

% part to check if, in a given group
p = inputParser;
addParameter(p, 'Nodes', [], @iscell);
addParameter(p, 'SelNodes', [], @iscell);
addParameter(p, 'DataField', [], @ischar);
addParameter(p, 'OtherFields', [], @iscell);
addParameter(p, 'Indices', [], @isnumeric);


parse(p, varargin{:});

 Nodes = p.Results.Nodes;
 SelNodes =  p.Results.SelNodes;
 DataField =  p.Results.DataField;
 OtherFields =  p.Results.OtherFields;
 Indices =  p.Results.Indices;


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
    curr_data = GTstruct(k).(DataField);
    sel_data = curr_data(Node_ind, Node_ind);
    GTres_temp(k).(DataField) = sel_data;
end;

GTres = GTres_temp;





