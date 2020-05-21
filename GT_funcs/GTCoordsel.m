%% GTCoordel(Coord, 'NodeField', value, 'Nodesel', value, 'CoordField', value);
%
% This function start from a GT struct. It selects the rows and columns of the Coordinate matrix data
% given some names, supplied as a cell and associated to nodes (i.e., rows
% and columns).
%
%
% INPUT:
%
% - GTCoord: a GTCoord struct for analysis in Gondola (contain Coordinate
% labels, and xyz in mri)
% - Nodecell: the cell containing the names of the Node. The length should be
%            the same of Coordinates xyz.
% - Nodesel: a cell with the names of the Nodes to be selected.
% - CoordField: the name of the field containing the adjacency matrices.
%
%
% EXAMPLE: Coord_sel = GTCoordsel(Coords, 'NodeField', 'labels', 'Nodesel', my_nodes, 'CoordField', 'xyz');
%
%
%  
%
% Author: Giorgio Arcara
% Data: 13/01/2020

function Coord_res = GTCoordsel(Coord, varargin)

% part to check if, in a given group
p = inputParser;
addParameter(p, 'NodeField', [], @ischar);
addParameter(p, 'Nodesel', [], @iscell);
addParameter(p, 'CoordField', [], @ischar);

parse(p, varargin{:});

NodeField = p.Results.NodeField;
Nodesel =  p.Results.Nodesel;
CoordField =  p.Results.CoordField;

% find indices of Node
All_Nodes = Coord.(NodeField);
All_Coords=Coord.(CoordField);



if (length(unique(All_Nodes))<length(All_Nodes) | length(unique(Nodesel) < length(Nodesel)))
    error('foo:bar', ['GT: There are some duplicate names in your node names,\n',...
        'either in the original Nodes or in the selection.\n',...
        'Please check your input data']);
end

[~, Node_ind, ~] = intersect(All_Nodes, Nodesel, 'stable');


Coord_res.(NodeField) = All_Nodes(Node_ind);
Coord_res.(CoordField) = All_Coords(Node_ind,:);







