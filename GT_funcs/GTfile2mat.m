%% GTfile2mat(GTmat_filename, 'InDir', path, 'OutDir', path, 'Freq', value)
% this function takes as input a .mat file containing a
% GTstruct (i.e., struct as exported from process_export_conn_mat in brainstorm)
% it returns files with the same name but only with matrices (getting rid
% of all others info. 
% NOTE: we load the file (and not the struct)
% cause the output filename will be the original filename (this info is not 
% contained in the GTstructs).
%
% INPUT:
% - GTmat_filename: one single GTmat
% - InDir: the input path (Default value= ' ')
% - OutDir: the output path (Default value= 'new_mat_files')
% - Freq: the frequency bin to select (Default value = 1)
% Author: Giorgio Arcara
% version: 10/01/2018

function GTfile2mat(GTmat_filename, varargin)
p = inputParser;
addParameter(p, 'InDir', [], @ischar);
addParameter(p, 'OutDir', [], @ischar);
addParameter(p, 'Freq', [], @isnumeric);


parse(p, varargin{:});

InDir = p.Results.InDir;
OutDir =  p.Results.OutDir;
Freq =  p.Results.Freq;



if ~exist('InDir');
    InDir='';
end;
%
if ~exist('OutDir');
    OutDir = 'new_mat_files';
    mkdir(OutDir);
end;

% select frequency (meaningful if multiple frequency are stored in the
% GT_filename
if ~exist('Freq');
    Freq = 1;
end;

curr_file = load([InDir, GTmat_filename]);

% select the square matrix of the selected frequency. Notice that it is
% not necessary to squeeze. Note also that the indexing work also if
% the matrix have only two dimensions.
curr_mat = curr_file.Conn.conn_mat(:,:,1,Freq);

save([OutDir, GTmat_filename],  'curr_mat')



