%% labels = scouts2Coord_bst(Scouts)
% this function takes as input bst scouts labels (as normally stored in
% Brainstorm structurs) and convert the labels in labels in a different format.
% currently only one format is supported, that is the one of the
% coordinates in BrainNetViewer (Desikan-Killany).
% or Destrieux.
%
% INPUT: - a cell with all Scout labels (as from bst output)
% OUTPUT: - an object with the new Scouts Labels

function [NewScouts] = scouts2Coord_bst(Scouts)

temp = cell(1, length(Scouts));

for iScout=1:length(Scouts)
    scout_split = strsplit(Scouts{iScout}, ' ');
    scout_new_name = [lower(scout_split{2}), '.', scout_split{1}];
    temp{iScout} = scout_new_name;
end;

NewScouts=temp;

