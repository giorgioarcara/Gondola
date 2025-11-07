function GTstruct = GTgetfields_FileName(FileNames, opt)
    arguments
        FileNames (1,:) cell
        opt.Fields (1, 1) string
        opt.Ignore (1, 1) string = ""
    end


%% GTgetfields_FileName - Parses file names into structured fields
%
% GTstruct = GTgetfields_FileName(FileNames, 'Fields', value, 'Ignore', value)
%
% This function takes a cell array of file names and extracts structured
% information from them by splitting each file name based on underscores
% (_) as assigning the parts to field names specified by the user
%
% Inputs:
%   Filenames (cell):A cell with the Filenames
% 
%   Fields (string, optional): A string with field names separated by
%   underscores (e.g. 'subject_condition_freq). Parts named 'XX' are
%   skipped. 
%
%   Ignore (string, optional): A string (e.g. '.mat') to remove from
%   filenames before parsing. 
%
%
%
% Output:
%   GTstruct (struct): A struct array where each element contains fields
%   parsed from the corresponding file name. 
% 
%
% Example: 
%   If FileNames = {'Sub01_Dev_Alpha.mat'} and 
%   Fields = 'subject_condition_freq', Ignore = '.mat', 
%   
%   the result will be a struct:
%       GTstruct.subject = 'Sub01'
%       GTstruct.condition = 'Dev'
%       GTstruct.freq = 'Alpha'
% 
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
% 
% Version: 28/05/2026
%

Fields = opt.Fields;
Ignore = opt.Ignore;

split_symbol = '_';
split_pattern = strsplit(Fields, split_symbol);
% get position of part of the files to exclude
excl_parts=regexpi(split_pattern, 'XX'); %
% get indices to include
incl_indices=find(cellfun(@isempty, excl_parts));

for iFile = 1:length(FileNames)
    
    % get current files
    curr_file = FileNames{iFile};
    
    % get rid of string to ignore, if required
    if (~isempty(Ignore))
        curr_file = regexprep(curr_file, Ignore, '');
    end;
    
    curr_filename_split = strsplit(curr_file, split_symbol);
    
    if (length(curr_filename_split)~=length(split_pattern))
        warning(['The split pattern specified is different from the split of the file', num2str(iFile)]);
    end;
    
    % loop over fields (only the one to include).
    for iField = incl_indices
        
        GTstruct(iFile).( split_pattern{iField} ) = curr_filename_split{iField};
        
    end;
    
end



