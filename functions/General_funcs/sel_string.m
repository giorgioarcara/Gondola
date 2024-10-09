%% sel_string(string_cell, include_string, exclude_string)
% This functions select, from a cell containing names, a subset based on
% an inclusion string (part that should be included in the name), or an
% exclusion string.
% Currently  NOT supported only the exclusion string, but you can just put
% "." in the inclusion string to select all files.
%
%
% Author: Giorgio Arcara
%
% Version: 24/02/2017

function [selStrings, selStrings_indices] = sel_string(string_cell, include_string, exclude_string)

incl_sFiles=regexpi(string_cell, include_string); %

if (nargin <3) % case only select by inclusion
    selStrings_indices=find(~cellfun(@isempty, incl_sFiles));
    
else % case in which there is both inclusion and exclusion
    
    excl_sFiles=regexp(string_cell, exclude_string);
    selStrings_indices=find(~cellfun(@isempty, incl_sFiles) & cellfun(@isempty, excl_sFiles)); 
% select final file
end

selStrings=string_cell(selStrings_indices);

end