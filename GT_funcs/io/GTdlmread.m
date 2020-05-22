%% GTdlmread(FileNames, 'OutResField', 'value', 'DataPath', 'value')
%
% This function takes as input a cell with FileNames. This files are
% expected to be Brainstorm Files as imported with process_export_conn_mat
% custom process associated with Gondola.
%
%
% INPUT
% - FileNames:A cell with the Filenames
% - 'OutResField': a string indicating the name of the field. default is
% 'mat_or'.
% - DataPath: the full path where the data are stored or a
% variable containing the data path
%
%
%
% Author: Giorgio Arcara
%
% version: 14/08/2018
%
%

function GTres = GTdlmread(FileNames, varargin);


% part to check if, in a given group
p = inputParser;
addParameter(p, 'OutResField', 'mat_or', @ischar);
addParameter(p, 'DataPath', '', @ischar);

parse(p, varargin{:});

DataPath =  p.Results.DataPath; % this part of code is left for future modifications
OutResField = p.Results.OutResField;


for iFile = 1:length(FileNames)
    
    % get current files
    curr_file = dlmread([DataPath, FileNames{iFile}]);
    
    % allow back compatibility with older version of
    % process_export_conn_mat, which exported in objects named Conn.        
     GTres(iFile).(OutResField) = curr_file;
     GTres(iFile).FileName =   FileNames{iFile};
    end;
    
    
end



