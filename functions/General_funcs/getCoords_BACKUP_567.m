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
% Author: Ettore Napoli, Alessandro Tonin, Giorgio Arcara
%
% Version: 07/03/2025

function  Coords = getCoords(Labels, RefCoord);

% if the file is a .node, convert temporarily in .txt
if ~isempty(regexpi(RefCoord, '.node'));
    
    newfilename =  strrep(RefCoord, '.node', '.txt');
    copyfile(RefCoord, newfilename);
    
    RefCoord = newfilename;
    
end

Coord = readtable(RefCoord, 'Delimiter', ' ', 'ReadVariableNames', 0, 'HeaderLines', 1);

% get labels from Coord table
Coord_lab = table2cell(Coord(:,end));

% match input Labels to reference Coord labels
[found_labels, sort_idx] = ismember(Labels, Coord_lab);

<<<<<<< HEAD
% optional: warn if some labels were not matched
if any(~found_labels)
    warning('Some labels not found in reference coordinate file: %s', strjoin(Labels(~found_labels), ', '));
end

% remove unmatched labels
Labels = Labels(found_labels);
sort_idx = sort_idx(found_labels);

% reorder Coord table to match input Labels
Coord = Coord(sort_idx, :);

% re-extract labels and xyz
Coord_mat = table2array(Coord(:,1:3));
Coord_lab = table2cell(Coord(:,end));

Coords.xyz = Coord_mat;
Coords.labels = Coord_lab;


% remove the new Column
Coord = Coord(:,1:(end-1));

% get separately number and labels in the Coord matrix for export
Coord_mat = table2array(Coord(:,1:3));
=======
% create object with only present Coord nodes
pCoords = Coord_lab(ind);
[~, ind, ~] = intersect(Coord_lab, Labels, 'stable');

Coord = Coord(ind, :);

% get labels from Coord table
>>>>>>> Modifiche-funzioni-sulla-base-di-script-di-prova-(MMCI)
Coord_lab = table2cell(Coord(:,end));

% match input labels to reference coord labels
[found_labels, sort_idx] = ismember(Labels, Coord_lab);

% Warn if some labels were not matched
if any(~found_labels)
    warning('Some labels not found in reference coordinate file: %s', strjoin(Labels(~found_labels), ', '));
end

% remove unmatched labels
Labels = Labels(found_labels);
sort_idx = sort_idx(found_labels);

% reorder Coord table to match input labels
Coord = Coord(sort_idx, :);

% re-extract labels ad xyz
Coord_mat = table2array(Coord(:, 1:3));
Coord_lab = table2array(Coord(:, end));

Coords.xyz = Coord_mat;
Coords.labels = Coord_lab;


