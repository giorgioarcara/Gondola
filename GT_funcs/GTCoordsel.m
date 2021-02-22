%% GTCoordel(Coord, 'NodeField', value, 'Nodesel', value, 'CoordField', value, 'OtherFiedlds', {value});
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
% - NodeField: the cell containing the names of the Node. The length should be
%            the same of Coordinates xyz.
% - Nodesel: a cell with the names of the Nodes to be selected.
% - CoordField: the name of the field containing the adjacency matrices.
% - OtherField: the name of the Other fields (same length as NodeCell) to be selected.
%
% EXAMPLE: Coord_sel = GTCoordsel(Coords, 'NodeField', 'labels', 'Nodesel', my_nodes, 'CoordField', 'xyz');
%
%
%
%
% Author: Giorgio Arcara
% Data: 19/02/2021

function [Coord_res SortInd]= GTCoordsel(Coord, varargin)

% part to check if, in a given group
p = inputParser;
addParameter(p, 'NodeField', [], @ischar);
addParameter(p, 'Nodesel', [], @iscell);
addParameter(p, 'CoordField', [], @ischar);
addParameter(p, 'OtherFields', [], @iscell);

parse(p, varargin{:});

NodeField = p.Results.NodeField;
Nodesel =  p.Results.Nodesel;
CoordField =  p.Results.CoordField;
OtherFields = p.Results.OtherFields;

% find indices of Node
All_Nodes = Coord.(NodeField);
All_Coords=Coord.(CoordField);



if (length(unique(All_Nodes))<length(All_Nodes) || length(unique(Nodesel)) < length(Nodesel))
    warning('foo:bar', ['GT: There are some duplicate names in your node names,\n',...
        'either in the original Nodes or in the selection.\n',...
        'Please check your input data']);
end

[~, ~, Node_ind] = intersect(Nodesel,All_Nodes, 'stable');
%Node_ind = find(ismember(All_Nodes, Nodesel));
SortInd = Node_ind;

Coord_res.(NodeField) = All_Nodes(Node_ind);
Coord_res.(CoordField) = All_Coords(Node_ind,:);

if ~isempty(OtherFields)
    for iField=1:length(OtherFields)
        All_Data = Coord.(OtherFields{iField});
        Coord_res.(OtherFields{iField}) = All_Data(Node_ind);
    end
end








