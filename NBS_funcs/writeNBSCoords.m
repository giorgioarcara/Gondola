%% writeNBSCoords(Labels, RefCoord, outdir)
% This functions takes as argument one object some labels and reference
% Coordintates and export the coordinates in format suitable to be used for
% analyses with NBS software (i.e., xyz, one node per row).
%
%
% - Labels, The labels of the Nodes Coordinate to be exported
%
% - RefCoord is a reference file with coordinates. The name of Labels will
%    be used for a match
%
% Important! The name in Ref Coord and in Labelsfile should be exactly
% matching (only the order can be different)
%
% The output will be one file.
% - NewCoord.txt contains the new coordinates (from RefCoord) but with the

% Author: Giorgio Arcara
%
% Version: 06/01/2018

function  [Coord_mat, Coord_lab] = writeNBSCoords(Labels, RefCoord, outdir);

if ~exist('outdir')
    outdir=''
end;

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
[~, ind, ~] = intersect(Coord_lab, Labels);

% add to table to sort
Coord = Coord(ind,:);

Coord(:, end+1) = array2table(ind) ;

% actually sort
Coord = sortrows(Coord, size(Coord,2));

% remove the new Column
Coord = Coord(:,1:(end-1));

% get separately number and labels in the Coord matrix for export
Coord_mat = table2array(Coord(:,1:3));
Coord_lab = table2cell(Coord(:,end));


%% EXPORT FILE FOR NBS
export_file=[outdir, 'NBS_coord.txt'];

fid = fopen(export_file, 'w');
for i=1:size(Coord_mat,1);%
    fprintf(fid, '%d ', Coord_mat(i,:)); % print only Coordinates
    fprintf(fid, '\n', '');
end;
fclose(fid);

