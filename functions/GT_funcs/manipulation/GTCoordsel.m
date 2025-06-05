%% GTCoordsel - Select nodes and corresponding coordinates from a GTcoord struct
%
% [Coord_res, SortInd] = GTCoordsel(Coord, 'NodeField', value, 'Nodesel', value, 'CoordField', value, 'OtherFields', {value})
%
% This function selects rows and columns of coordinate data in a GTcoord struct
% based on specified node names. It can also retain additional fields with
% information linked to the selected nodes.
% 
% Inputs:
%   Coord (struct): A GTcoord struct (e.g., with node labels and xyz coordinates).
%
%   NodeField (string, optional): The field containing node names. Default: 'labels'
%   
%   Nodesel (cell, optional): A cell array of node names to be selected.
%   
%   CoordField (string, optional): The field containing coordinate values. Default: 'xyz'
%   
%   OtherFields (cell, optional): A cell array of other fields (same length as nodes) to retain.
%
% Outputs:
%   Coord_res (struct): A struct containing only the selected nodes and fields.
%   
%   SortInd (array): Index vector indicating the original positions of the selected nodes.
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
% 
% Version: 20/05/2025


function [Coord_res, SortInd]= GTCoordsel(Coord, opt)
    arguments
        Coord (1, :) struct
        opt.NodeField (1, :) string = "labels"
        opt.Nodesel (:, :) cell 
        opt.CoordField (1, :) string = "xyz"
        opt.OtherFields (1, :) cell
    end



NodeField = opt.NodeField;
Nodesel =  opt.Nodesel;
CoordField =  opt.CoordField;
OtherFields = opt.OtherFields;

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








