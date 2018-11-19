%% getCoords (Labels, RefCoord)
% Create a matlab object with coordinates (for printing purpose).
%
% - Labels, is a cell with the labels of the coordinates
%           (typically from GT object).
%
% - RefCoord is a reference file with coordinates (.node or .txt). The name of labels will
%    be used for a match.
%
% !!!! IMPORTANT !!!! The name in Ref Coord and in Labelsfile should be exactly
% matching (only the order can be different). If labels comes from a GT
% file, you need to use before the scouts2Coord_bst.m
%
%
%
%
% Author: Giorgio Arcara
%
% Version: 17/01/2018

function  Coords = getCoords(Labels, RefCoord);

% if the file is a .node, convert temporarily in .txt
if ~isempty(regexpi(RefCoord, '.node'));
    
    newfilename =  strrep(RefCoord, '.node', '.txt');
    copyfile(RefCoord, newfilename);
    
    RefCoord = newfilename;
    
end

Coord = readtable(RefCoord, 'Delimiter', ' ', 'ReadVariableNames', 0, 'HeaderLines', 1);

% get labels (assuming they are at the end)
Coord_lab = table2cell(Coord(:,end));

% retrieve index to sort
[~, ind, ~] = intersect(Labels, Coord_lab);

% add to table to sort
Coord(:, end+1) = array2table(ind) ;

% actually sort
Coord = sortrows(Coord, size(Coord,2));

% remove the new Column
Coord = Coord(:,1:(end-1));

% get separately number and labels in the Coord matrix for export
Coord_mat = table2array(Coord(:,1:3));
Coord_lab = table2cell(Coord(:,end));


Coords.xyz = Coord_mat;
Coords.labels = Coord_lab;

