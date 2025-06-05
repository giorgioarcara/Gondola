%% GTbstfile2mat - Extract connectivity matrices from Brainstorm GTstruct files
% GTbstfile2mat(FileName, 'InDir', path, 'OutDir', path, 'Freq', value)
%
% This function loads a `.mat` file exported from Brainstorm (using 
% `process_export_conn_mat`) containing a GTstruct, and creates a new `.mat`
% file that includes only the connectivity matrices, discarding all 
% additional metadata.
%
% The output file will keep the same name as the input, and is saved to 
% the specified output directory.
%
% Inputs:
%   FileName (string):
%       Name of a single connectivity matrix .mat file (e.g., 'sub01_conn.mat')
%
%   InDir (string, optional):
%       Path to input folder. Default: './'
%
%   OutDir (string, optional):
%       Path to output folder. Default: './new_mat_files'
%
%   Freq (double, optional):
%       Frequency bin to extract. Default: 1
% 
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
% Version: 19/05/2025



function GTbstfile2mat(FileName, opt)
    arguments
        FileName (1,1) string
        opt.InDir (1,1) string {mustBeFolder} = "./"
        opt.OutDir (1,1) string = "./new_mat_files" 
        opt.Freq (1,1) double {mustBeNumeric} = 1
    end


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



