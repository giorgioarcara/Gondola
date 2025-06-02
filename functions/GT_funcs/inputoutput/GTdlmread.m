%% GTdlmread - Extract and label values from Brainstorm GTstruct files
% GTdlmread(FileNames, 'Field', value, 'InDir', path)
%
% This function takes as input a list of filenames (Brainstorm `.mat` files 
% exported using `process_export_conn_mat` and Gondola's custom processes) 
% and extracts a specified field from each of them.
%
%
%
% Inputs:
%   FileNames (string array):
%       List of Brainstorm filenames 
%
%   Field (string, optional):
%       The name of the column under which the extracted values will be
%       stored
%       Default: 'mat_or'
%
%   InDir (string, optional):
%       Full path to the directory containing the data files.
%       Default: '.'
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin 
% Version: 19/05/2025


function GTstruct_out = GTdlmread(FileNames, opt)
    arguments
        FileNames (1,:) string
        opt.Field (1,1) string = "mat_or"
        opt.InDir (1,1) string {mustBeFolder} = "."
    end


Field = opt.Field;
InDir = opt.InDir;

% Inizialize output struct
GTstruct_out(length(FileNames)) = struct;

%% Read files
for iFile = 1:length(FileNames)
    
    % get current files
    filepath = fullfile(InDir, FileNames{iFile});
    % import it as a table
    curr_file_table = readtable(filepath,'ImportErrorRule','error');
    % convert the table to a matrix
    curr_file = table2array(curr_file_table);
    
    % allow back compatibility with older version of
    % process_export_conn_mat, which exported in objects named Conn.        
    GTstruct_out(iFile).(Field) = curr_file;
    GTstruct_out(iFile).FileName =   FileNames{iFile};
end
    
    
end



