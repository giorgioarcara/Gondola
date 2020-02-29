% GTimport_bst(FileNames, StructFields, ResFields, DataPath)
%
% This function takes as input a cell with FileNames. This files are
% expected to be Brainstorm Files as imported with process_export_conn_mat
% custom process associated with Gondola.
%
%
% INPUT
% - FileNames:A cell with the Filenames
% - StructFields: a cell of strings indicating the FileNameFields that
%                   will be imported
% - ResFields:  the name that will be used in the newly created struct.
%
%
%
% Author: Giorgio Arcara
%
% version: 14/08/2018
%
%

function GTres = GTimport_bst(FileNames, varargin);


% part to check if, in a given group
p = inputParser;
addParameter(p, 'StructFields', [], @iscell);
addParameter(p, 'ResFields', [], @iscell);
addParameter(p, 'DataPath', [], @ischar);


parse(p, varargin{:});

StructFields = p.Results.StructFields;
ResFields =  p.Results.ResFields;
DataPath =  p.Results.DataPath;



for iFile = 1:length(FileNames)
    
    % get current files
    curr_file = load([DataPath, FileNames{iFile}]);
    
    % allow back compatibility with older version of
    % process_export_conn_mat, which exported in objects named Conn.
    
    if length(curr_file)==1
        if strcmp(fieldnames(curr_file), 'Conn')
            curr_file = curr_file.Conn;
        end;
    end;
       
    for iField = 1:length(StructFields)
        
        GTres(iFile).(ResFields{iField}) = curr_file.(StructFields{iField});
        
    end;
    
    
end



