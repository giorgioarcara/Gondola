function GTbstfile2mat(FileName, opt)
    arguments
        FileName (1,1) string
        opt.InDir (1,1) string {mustBeFolder} = "./"
        opt.OutDir (1,1) string = "./new_mat_files" 
        opt.Freq (1,1) double {mustBeNumeric} = 1
    end
%% GTbstfile2mat(FileName, 'InDir', path, 'OutDir', path, 'Freq', value)
%
% This function takes as input a .mat file containing a
% GTstruct (i.e., struct as exported from process_export_conn_mat in brainstorm)
% it returns files with the same name but only with matrices (getting rid
% of all others info. 
% 
% Note: 
%   We load the file (and not the struct)
%   cause the output filename will be the original filename (this info is not 
%   contained in the GTstructs).
%
% Parameters:
%   Filename (str): One single GTmat
%   InDir (str): the input path. Default: './'
%   OutDir (str): the output path. Default: './new_mat_files'
%   Freq (double): the frequency bin to select. Default: 1
%
% Author: Giorgio Arcara
%
% version: 10/01/2018

InDir = opt.InDir;
OutDir =  opt.OutDir;
Freq =  opt.Freq;


if ~exist(OutDir, 'dir')
    mkdir(OutDir);
end


curr_file = load(fullfile(InDir, FileName));

% select the square matrix of the selected frequency. Notice that it is
% not necessary to squeeze. Note also that the indexing work also if
% the matrix have only two dimensions.
curr_mat = curr_file.Conn.conn_mat(:,:,1,Freq);

save(fullfile(OutDir, FileName),  'curr_mat')



