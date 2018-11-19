%% sel_files_bst(sFilesNames, include_string, exclude_string)
% This functions select, from a cell containing file names, a subset based on
% an inclusion string (part that should be included in the name), or an
% exclusion string.
% Currently  NOT supported only the exclusion string, but you can just put
% "." in the inclusion string to select all files.
%
% The function is meant to be used with Brainstorm Software 
% http://neuroimage.usc.edu/brainstorm/Introduction (Tadel et al., 2011)
%
% Author: Giorgio Arcara
%
% Version: 24/02/2017

function [selFiles, selFiles_indices] = sel_files_bst(sFilesNames, include_string, exclude_string)

incl_sFiles=regexpi(sFilesNames, include_string); %

if (nargin <3) % case only select by inclusion
    selFiles_indices=find(~cellfun(@isempty, incl_sFiles));
    
else % case in which there is both inclusion and exclusion
    
    excl_sFiles=regexp(sFilesNames, exclude_string);
    selFiles_indices=find(~cellfun(@isempty, incl_sFiles) & cellfun(@isempty, excl_sFiles)); 
% select final file
end

selFiles=sFilesNames(selFiles_indices);

end