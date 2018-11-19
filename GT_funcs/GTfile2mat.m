%% GTfile2mat(GTmat_filename, indir, outdir, Freq)
% this function takes as input a .mat file containing a
% GT struct (i.e., struct as exported from process_export_conn_mat in brainstorm)
% it returns files with the same name but only with matrices (getting rid
% of all others info. 
% NOTE: we load the file (and not the struct)
% cause the output filename will be the original filename (this info is not 
% contained in the GT struc).
%
% INPUT:
% - GTmat_filename: one single GTmat
% - indir: the input path
% - outdir: the output path
%
% Author: Giorgio Arcara
% version: 10/01/2018

function GTfile2mat(GTmat_filename, indir, outdir, Freq)

if ~exist('indir');
    indir='';
end;
%
if ~exist('outdir');
    outdir = 'new_mat_files';
    mkdir(outdir);
end;



% select frequency (meaningful if multiple frequency are stored in the
% GT_filename
if ~exist('Freq');
    Freq = 1;
end;

curr_file = load([indir, GTmat_filename]);

% select the square matrix of the selected frequency. Notice that it is
% not necessary to squeeze. Note also that the indexing work also if
% the matrix have only two dimensions.
curr_mat = curr_file.Conn.conn_mat(:,:,1,Freq);

save([outdir, GTmat_filename],  'curr_mat')



