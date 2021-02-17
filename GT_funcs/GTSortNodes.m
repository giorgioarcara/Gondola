%% GTSortNodes(CMstruct, 'Nodes', {value}, 'TargetNodes', value, 'DataField', value, 'OtherFields', value);
%
% This function start from a GT struct. It selects the rows and columns of the adjacency matrix data
% given some names, supplied as a cell and associated to nodes (i.e., rows
% and columns).
%
%
% INPUT:
%
% - CMstruct: a struct for analysis Gondola
% - Nodes: the cell containing the names of the Node. The length should be
%            the same of the Rows and columns of the adjacency matrix,
%            supplied as DataField.
% - TargetNodes: a cell with the names of the Nodes in the new Order.
% - DataField: the name of the field containing the adjacency matrices.
% - othersfields: a cell with name of fields that should be inherited from
% CMstruct.
%
%
% Author: Giorgio Arcara
% Data: 19/11/2019

function CMres = GTTargetNodes(CMstruct, varargin)

% part to check if, in a given group
p = inputParser;
addParameter(p, 'Nodes', [], @iscell);
addParameter(p, 'TargetNodes', [], @iscell);
addParameter(p, 'DataField', [], @ischar);
addParameter(p, 'OtherFields', [], @iscell);


parse(p, varargin{:});

 Nodes = p.Results.Nodes;
 TargetNodes =  p.Results.TargetNodes;
 DataField =  p.Results.DataField;
 OtherFields =  p.Results.OtherFields;



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

% find indices of Node
[~, ~, New_Node_ind] = intersect(TargetNodes, Nodes, 'stable');

% loop over all elements in the struct and select
for k=1:length(CMstruct);
    curr_data = CMstruct(k).(DataField);
    sel_data = curr_data(New_Node_ind, New_Node_ind);
    CMres_temp(k).(DataField) = sel_data;
end;

CMres = CMres_temp;





