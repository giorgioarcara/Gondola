%% GTloadBst - load specific fields from brainstorm connectivity matrices
% GTloadBst(FileNames, 'StructFields', value, 'Field', value, InDir, path)
%
% This function loads a list of Brainstorm -mat files (exported using
% process_export_conn_mat) and extracts the specified fields. The resulting
% data are stored in a new struct array with a specified label. 
%
% This is useful for collecting subsets of fields from multiple data files
% into a consistent data structure
%
% Inputs:
%   FileNames (string array): List of file names
%   StructFields (string array): List of the field to be extracted
%   Field (string array, optional): Name to assign to the resulting struct
%   column. Deafult: 'mat_or'
%   InDir (string array, optional): Full path to the folder containing the
%   .mat files. Default: './'
%
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
% Version: 20/05/2025

function GTstruct_out = GTloadBst(FileNames, StructFields, opt)
    arguments
        FileNames (1,:) string
        StructFields (1,:) string
        opt.Field (1,1) string {mustBeValidVariableName} = "mat_or"
        opt.InDir (1,1) string {mustBeFolder} = "./"
    end


InField = opt.Field;
InDir = opt.InDir;

for iFile = 1:length(FileNames)
    
    % get current files
    curr_file = load([InDir, FileNames{iFile}]);
    
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