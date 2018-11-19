%% sort_by_key(strings_cell, key_cell)
% this function allow to sort char elements in a cell, according to other
% elements in a call (the order of the cell element is respected).
% The fragment is specified as regular expression.
% It can be used (for example) to sort file according to a series of
% conditions. e.g. sort char elements according to the appearance of
% {'gamma', 'theta', 'alpha'} in the 
%

% Author: Giorgio Arcara

function [sorted_elements] = sort_by_key(strings_cell, key_cell)

% initialize empty object.
keys=zeros(1, length(strings_cell));

for iKey = 1:length(key_cell);
    found_key = regexp(strings_cell, key_cell{iKey}); % find the key
    strings_cell_ind=find(~cellfun(@isempty, found_key)); % get indices associated with key
    
    % add as intermediate result the iKey of key_cell
    keys(strings_cell_ind) = iKey;
    
    % retrieve ordinal index of keys results to sort correctly the initial
    % object.
    [~, Ind_key] = sort(keys);
    
end;

sorted_elements = strings_cell(Ind_key);



