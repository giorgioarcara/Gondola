%% GTCoordel(GTCoord, 'NodeField', value, 'CoordField', value, 'Nodesel', value);
%
% This function start from a GT struct. It selects the rows and columns of the GTCoordinate matrix data
% given some names, supplied as a cell and associated to nodes (i.e., rows
% and columns).
%
%
% INPUT:
%
% - GTGTCoord: a GTGTCoord struct for analysis in Gondola (contain GTCoordinate
% labels, and xyz in mri)
%
%
% - NodeField: the name of the field (in GTCoord) with the labels of the
%               GTCoordinates. DEFAULT = 'labels'
% - CoordField: the name of the field containing the adjacency matrices.
% 'DEFAULT = 'xyz';
% - Nodesel: a cell with the names of the Nodes to be selected.
%
%
% EXAMPLE: GTCoord_sel = GTGTCoordsel(GTCoords, 'NodeField', 'labels', 'Nodesel', my_nodes, 'CoordField', 'xyz');
%
%
%  
%
% Author: Giorgio Arcara
% Data: 13/01/2020

function GTCoord_res = GTCoordsel(GTCoord, varargin)

% part to check if, in a given group
p = inputParser;
addParameter(p, 'NodeField', [], @ischar);
addParameter(p, 'Nodesel', [], @iscell);
addParameter(p, 'CoordField', [], @ischar);


parse(p, varargin{:});

NodeField = p.Results.NodeField;
Nodesel =  p.Results.Nodesel;
CoordField =  p.Results.CoordField;

% default values

if isempty(CoordField)
    CoordField = 'xyz';
end;

if isempty(NodeField)
    NodeField = 'labels';
end;

%%

% find indices of Node
All_Nodes = GTCoord.(NodeField);
All_GTCoords=GTCoord.(CoordField);

[~, Node_ind, ~] = intersect(All_Nodes, Nodesel, 'stable');


GTCoord_res.(NodeField) = All_Nodes(Node_ind);
GTCoord_res.(CoordField) = All_GTCoords(Node_ind,:);







