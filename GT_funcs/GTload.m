%% GTstruct = GTload('FileNames',value, 'FileNameFields', value, 'FileNameIgnore', value, 'StructNameFields', value)
%
% This function takes as input a list of FileName and import them.
% additional input can be specified to create fields from FileName or from
% info in the struct.
%
% INPUT
% - Filenames: List of the files to import
% - FileNameFields: the name of the fields to load
% - FileNameIgnore: 
% - StructNameFields:
% NOTE: the function some all the values and then divide by the numebrs
%       so missing values can lead to wrong resuls
%
%
% Author: Giorgio Arcara
%
% version: 04/03/2018
%
%

function GTstruct = GTload(FileNames, varargin);


p = inputParser;
addRequired(p, 'FileNames', @iscell);
addParameter(p, 'FileNameFields', [], @iscell);
addParameter(p, 'FileNameIgnore', [], @ischar);
addParameter(p, 'StructNameFields', [], @iscell);


parse(p, FileNames, varargin{:});

FileNames = p.Results.FileNames;
FileNamesFields = p.Results.FileNameFields;
FileNameIgnore = p.Results.FileNameIgnore;
StructNameFields = p.Results.StructNameFields;


for iFile = 1:length(FileNames)
        
    %% HOW TO LOAD DATA
    
end



