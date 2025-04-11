function GTstruct_out = GTdlmread(FileNames, opt)
    arguments
        FileNames (1,:) string
        opt.Field (1,1) string = "mat_or"
        opt.DataPath (1,1) string {mustBeFolder} = "."
    end
%% GTdlmread(FileNames, 'Field', 'value', 'DataPath', 'value')
%
% This function takes as input a cell with FileNames. This files are
% expected to be Brainstorm Files as imported with process_export_conn_mat
% custom process associated with Gondola.
%
% Parameters:
%   FileNames ([str]): Array with the filenames
%
% Other Parameters:
%   Field (str): A string indicating the name of the field. Default: 'mat_or'
%   DataPath (str): The full path where the data are stored. Default: '.'

% Author: Giorgio Arcara
%
% version: 14/08/2018
%


%% Parsing arguments
% p = inputParser;
% addParameter(p, 'InField', 'mat_or', @ischar);
% addParameter(p, 'DataPath', '', @ischar);
% 
% parse(p, varargin{:});
% 
% DataPath =  p.Results.DataPath; % this part of code is left for future modifications
% InField = p.Results.InField;

InField = opt.InField;
DataPath = opt.DataPath;

% Inizialize output struct
GTstruct_out(length(FileNames)) = struct;

%% Read files
for iFile = 1:length(FileNames)
    
    % get current files
    filepath = fullfile(DataPath, FileNames{iFile});
    % import it as a table
    curr_file_table = readtable(filepath,'ImportErrorRule','error');
    % convert the table to a matrix
    curr_file = table2array(curr_file_table);
    
    % allow back compatibility with older version of
    % process_export_conn_mat, which exported in objects named Conn.        
    GTstruct_out(iFile).(InField) = curr_file;
    GTstruct_out(iFile).FileName =   FileNames{iFile};
end
    
    
end



