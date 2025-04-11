function GTstruct_out = GTloadBst(FileNames, StructFields, opt)
    arguments
        FileNames (1,:) string
        StructFields (1,:) string
        opt.Field (1,1) string {mustBeValidVariableName} = "mat_or"
        opt.DataPath (1,1) string {mustBeFolder} = "./"
    end
%% GTloadBst(FileNames, 'StructFields', ['value'], 'Field', 'value', 'DataPath', 'value')
%
% This function takes as input a cell with FileNames. This files are
% expected to be Brainstorm Files as imported with process_export_conn_mat
% custom process associated with Gondola.
%
% Parameters:
%   FileNames ([str]): Array with the filenames
%   StructFields ([str]): Array of strings indicating the FileNameFields that will be imported
%
% Other Parameters:
%   Field (str): A string indicating the name of the field. Default: 'mat_or'
%   DataPath (str): The full path where the data are stored. Default: '.'

% Author: Giorgio Arcara
%
% version: 14/08/2018
%
%

% part to check if, in a given group
% p = inputParser;
% addParameter(p, 'StructFields', [], @iscell);
% addParameter(p, 'ResFields', [], @iscell);
% addParameter(p, 'DataPath', [], @ischar);
% 
% 
% parse(p, varargin{:});

% StructFields = p.Results.StructFields;
% ResFields =  p.Results.ResFields;
% DataPath =  p.Results.DataPath;

InField = opt.Field;
DataPath = opt.DataPath;

for iFile = 1:length(FileNames)
    
    % get current files
    curr_file = load([DataPath, FileNames{iFile}]);
    
    % allow back compatibility with older version of
    % process_export_conn_mat, which exported in objects named Conn.
    
    if length(curr_file)==1
        if strcmp(fieldnames(curr_file), 'Conn')
            curr_file = curr_file.Conn;
        end
    end
       
    for iField = 1:length(StructFields)
        
        GTstruct_out(iFile).(InField{iField}) = curr_file.(StructFields{iField});
        
    end
    
    
end