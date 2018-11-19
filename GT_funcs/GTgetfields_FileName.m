% GTgetfields_FileName(FileNames, FileNamefields, FileNameIgnore, structfields)
%
% This function takes as input a cell with FileNames and retrieve some
% useful information from the name (splitting according to specified criteria)
% matrices in a field.
%
% INPUT
% - Filenames:A cell with the Filenames
% - FileNamefields: a string indicating the FileNameFields in
%                   the follwing format 'field1_field2_XX'. 
%                   the parts in XX will be ignored when getting the filename.
% - FileNameIgnore: a string (typically the extension) to be ignored in the
%                   parsins
%
%
% EXAMPLE: if the filename is SUBJECT01_DEVIANT_ALPHA
% FileNamefields could be subject_condition_Freq, that will lead to the
% struct with fields:
% 
% GTres.subject
% GTres.condition
% GTres.Freq
%
% GTres = GTgetfields_FileName(all_files, 'FileNamefields', 'measure_nscouts_XX_type_XX_XX_time_Subject_cond', 'FileNameIgnore', '.mat')
%                  
%
% Author: Giorgio Arcara
%
% version: 14/08/2018
%
%

function GTres = GTgetfields_FileName(FileNames, varargin);


% part to check if, in a given group
p = inputParser;
addParameter(p, 'FileNamefields', [], @isstr);
addParameter(p, 'FileNameIgnore', [], @isstr);
addParameter(p, 'structfields', [], @iscell);

parse(p, varargin{:});

FileNameFields = p.Results.FileNamefields;
structfields = p.Results.structfields;
FileNameIgnore =  p.Results.FileNameIgnore;


split_symbol = '_';
split_pattern = strsplit(FileNameFields, split_symbol);
% get position of part of the files to exclude
excl_parts=regexpi(split_pattern, 'XX'); %
% get indices to include
incl_indices=find(cellfun(@isempty, excl_parts));

for iFile = 1:length(FileNames)
    
    % get current files
    curr_file = FileNames{iFile};
    
    % get rid of string to ignore, if required
    if (~isempty(FileNameIgnore))
        curr_file = regexprep(curr_file, FileNameIgnore, '');
    end;
    
    curr_filename_split = strsplit(curr_file, split_symbol);
    
    if (length(curr_filename_split)~=length(split_pattern))
        warning(['The split pattern specified is different from the split of the file', num2str(iFile)]);
    end;
    
    % loop over fields (only the one to include).
    for iField = incl_indices
        
        GTres(iFile).( split_pattern{iField} ) = curr_filename_split{iField};
        
    end;
    
end



