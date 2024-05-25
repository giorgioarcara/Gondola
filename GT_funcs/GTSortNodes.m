%% GTSortNodes(CMstruct, 'OrNodes', {value}, 'TargetNodes', value, 'DataField', value, 'OtherFields', value, 'Indices', value);
%
% This function start from a GT struct. It sort the rows and cols of
% DataField according to some other supplied values.
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
% - othersfields: a cell with name of fields that should be inherited from CMstruct.
% - Indices: override Nodes, and Target Nodes, and reorder both rows and
%         with the new supplied order.
%
%
% Author: Giorgio Arcara
% Data: 19/11/2019

function CMres = GTSortNodes(CMstruct, varargin)

% part to check if, in a given group
p = inputParser;
addParameter(p, 'OrNodes', [], @iscell);
addParameter(p, 'TargetNodes', [], @iscell);
addParameter(p, 'DataField', [], @ischar);
addParameter(p, 'OtherFields', [], @iscell);
addParameter(p, 'Indices', [], @isnumeric);


parse(p, varargin{:});

OrNodes = p.Results.OrNodes;
TargetNodes =  p.Results.TargetNodes;
DataField =  p.Results.DataField;
OtherFields =  p.Results.OtherFields;
Indices = p.Results.Indices;


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
    curr_data = CMstruct(k).(DataField);
    sel_data = curr_data(New_Node_ind, New_Node_ind);
    CMres_temp(k).(DataField) = sel_data;
end;


CMres = CMres_temp;





