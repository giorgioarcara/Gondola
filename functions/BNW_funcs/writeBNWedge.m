%% writeBNWedge(conn_mat, outdir)
%
% This function takes as input a matrix and return a .txt files to be used
% with BrainNetViewer software.
%
% INPUT:
% - conn_mat: a n x n matrix for connectivity
%
% Output: an ASCII .edge file with the connectiviy results.
%
% Author: Giorgio Arcara
%
% Version: 12/01/2018


function writeBNWedge(conn_mat, varargin)

if nargin < 1
  error('1 input is mandatory')
elseif nargin == 1
  outdir = '';
elseif nargin == 2
  outdir = varargin{1};
end

% check if the dir exists otherwise it creates it
if ~exist(outdir, 'dir') && ~isempty(outdir)
    mkdir(outdir);
end

% if ~exist(outdir)
%     outdir = '';
% end

% export_name=[outdir, 'BNW_edge.edge'];
export_name = fullfile(outdir, 'BNW_nodes.node');
fprintf('*** export file *** %s \n', export_name);

fid = fopen(export_name, 'w');

for i=1:size(conn_mat, 1)
    fprintf(fid, '%d\t', conn_mat(i,:)); % print Coord
    fprintf(fid, '\n', '');
end
fclose(fid);
