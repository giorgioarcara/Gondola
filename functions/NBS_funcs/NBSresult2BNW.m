%%  NBSresult2BNV(nbs)
% 
% This function takes as input the output of NBS analysis and create a folder with 
% all the files that are need to show the results with BraiNetViewer.
% The only missing detail will be the brain mesh, that should be supplied
% separately.
%
% Input: can be either a nbs struct or the name of .mat file
%
% - nbs: either the name of a .mat file (char) with nbs results or a struct with
% nbs results
% - oudtir: the path where to write the results
% - nodeCol: color of Nodes (see the help for writeBNWnode for details).
% - nodeSize: size of Nodes (see the help for writeBNWnode for details).
%
%
% Author: Giorgio Arcara
%
% Version: 12/01/2018


function NBSresult2BNW(nbs, outdir,  nodeCol, nodeSize)

if ~exist('outdir')
    outdir = '';
end;

if ~exist('nodeSize')
    nodeSize = 1;
end;

if ~exist('nodeCol')
    nodeCol = 1;
end;

if ischar(nbs)
    load(nbs); % load in case a .mat name is supplied
end

%% export edges

% note i transform the matrix from sparse to null.
writeBNWedge( full(nbs.NBS.con_mat{1}), outdir);

%% export nodes

Coords = nbs.NBS.node_coor;
Labels = nbs.NBS.node_label;

writeBNWnode(nbs.NBS.node_coor, Labels, nodeCol, nodeSize, outdir);

%% 





