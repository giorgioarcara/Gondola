%% sort_by_fragment(strings_cell, fragment)
% this function allow to sort char elements in a cell, according to a
% fragment of the cell value.
% The fragment is specified as regular expression.
% It can be used (for example) to sort file according to subject name, if
% the subject name is just part (i.e. it's embedded) in the overall name
% contained in a an element of the cell.

% Author: Giorgio Arcara

function [sorted_elements] = sort_by_fragment(strings_cell, fragment)
string_ini=regexpi(strings_cell, fragment);
fragment_length=length(fragment);

unsorted_cell_elements={};

%loop over cell elements
    for i=1:length(strings_cell);
        unsorted_cell_elements{i}=strings_cell{i}(string_ini{i} : (string_ini{i}+fragment_length) );
    end;

[sorted_cell_elements Indices]= sort(unsorted_cell_elements);
sorted_elements=strings_cell(Indices);


