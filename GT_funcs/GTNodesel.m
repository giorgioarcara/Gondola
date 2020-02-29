%% GTNodesel(GTstruct, 'Nodecell', value, 'Nodesel', value, 'DataField', value, 'otherfields', value);
%
% This function start from a GT struct. It selects the rows and columns of the adjacency matrix data
% given some names, supplied as a cell and associated to nodes (i.e., rows
% and columns).
%
%
% INPUT:
%
% - GTstruct: a struct for analysis Gondola
% - Nodecell: the cell containing the names of the Node. The length should be
%            the same of the Rows and columns of the adjacency matrix,
%            supplied as DataField.
% - Nodesel: a cell with the names of the Nodes to be selected.
% - DataField: the name of the field containing the adjacency matrices.
% - othersfields: a cell with name of fields that should be inherited from
% GTstruct.
%
%
% Author: Giorgio Arcara
% Data: 19/11/2019

function GTres = GTNodesel(GTstruct, varargin)

% part to check if, in a given group
p = inputParser;
addParameter(p, 'Nodecell', [], @iscell);
addParameter(p, 'Nodesel', [], @iscell);
addParameter(p, 'DataField', [], @ischar);
addParameter(p, 'otherfields', [], @iscell);


parse(p, varargin{:});

Nodecell = p.Results.Nodecell;
Nodesel =  p.Results.Nodesel;
DataField =  p.Results.DataField;
otherfields =  p.Results.otherfields;


% initialize empty object
if (~isempty(otherfields));
    
    GTres_temp=struct();
    
    % get other fields if specified
    if (exist('otherfields')&~isempty('otherfields'))
        % first copy all the other fields
        for fn = otherfields
            for isubj = 1:length(GTstruct);
                GTres(isubj).(fn{1}) = GTstruct(isubj).(fn{1});
            end
        end
    end
    
elseif (isempty(otherfields))
    
    % inherit all fields if otherfields is not specified
    GTres_temp = GTstruct;
    
end;

% find indices of Node
[~, Node_ind, ~] = intersect(Nodecell, Nodesel, 'stable');

% loop over all elements in the struct and select
for k=1:length(GTstruct);
    curr_data = GTstruct(k).(DataField);
    sel_data = curr_data(Node_ind, Node_ind);
    GTres_temp(k).(DataField) = sel_data;
end;

GTres = GTres_temp;





