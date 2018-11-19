%% writeNBSlabels(labelNames)
% This is a simple wrapper for writing lables in a file 
% named NodeLabels.txt for NBS
% 

function writeNBSlabels(labelNames, outdir)
%% EXPORT EDGE (i.e., tha matrix of results).
if ~exist(outdir)
    outdir='';
end;

export_name=[outdir, 'NBS_nodeLabels.txt'];

fid = fopen(export_name, 'w');
for i=1:length(labelNames);%
    fprintf(fid, '%s', labelNames{i}); % print Coord
    fprintf(fid, '\n', '');
end;
fclose(fid);