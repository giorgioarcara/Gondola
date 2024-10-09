%% group_by_string_bst(FileNames, Strings, varargin); % grouping_strings, check, mess
%
% this function group a cell containing file names in a cell cotanining
% several cells in which file names (i.e., data in Brainstorm) are separated
% according to a string.
%
% ARGUMENTS:
% - FileNames: a cell with FileNames
% - String: a cell with strings for the grouping
%
%   OPTIONAL:
%       - grouping_stirngs: an additional cell for grouping filenames (see
%       explanation below).
%       - check: a single value or two values to check if the lenght of
%       cell is exactly a given value or inside a range of two values.
%       - mees: 'error' or 'warning' after check?
%
%
% Normally FileNames are grouped according to FileNames themseleves, but a
% different grouping_string can be specified.
% It can be used to group by Subject (using a string identifying Subject names)
% or the Run (using a string identifying run name).
% A potential use of grouping strings is to use the Comment of a brainstorm
% file to group Names
% e.g.
%
% my_Strings={'Correct', 'Incorrect'};
%
% group_by_string_bst({sFiles.FileNames}, my_Strings, {sFiles.Comment});


function sGroupByStr = group_by_str_bst(FileNames, Strings, varargin);

default_grouping_strings = FileNames;
default_mess = 'error';


% part to check if, in a given group
p = inputParser;
addParameter(p, 'grouping_strings', default_grouping_strings, @iscell);
addParameter(p, 'check', [], @isnumeric);
addParameter(p, 'mess', default_mess, @ischar);

parse(p, varargin{:});
grouping_strings = p.Results.grouping_strings;
check = p.Results.check;
mess = p.Results.mess;


sGroupByStr = {};
for istr=1:length(Strings);
    
    curr_str=Strings{istr};
    [~, curr_sFiles_indices]=sel_files_bst(grouping_strings, curr_str);
    sGroupByStr{istr}={FileNames{curr_sFiles_indices}};%
    
    
    % check with one value
    if(exist('check') & length(check)==1)
        
        % check with only one value (either equal or not).
        if length(curr_sFiles_indices) ~= check
            switch mess
                case 'warning'
                    warning(['The files of loop ', num2str(istr), ' are not ', num2str(check)]);
                case 'error'
                    error(['The files of loop ', num2str(istr), ' are not ', num2str(check)]);
            end;
        end;
    end;
    
    
    % check with two values (range accepted).
    if(exist('check') & length(check)==2)
        % less values
        if length(curr_sFiles_indices) < check(1)
            switch mess
                case 'warning'
                    warning(['The files of loop ', num2str(istr), ' are less than ', num2str(check(1))]);
                case 'error'
                    error(['The files of loop ', num2str(istr), ' are less than ', num2str(check(1))]);
            end;
        end;
        
        % more values
        if length(curr_sFiles_indices) > check(2)
            switch mess
                case 'warning'
                    warning(['The files of loop ', num2str(istr), ' are more than ', num2str(check(2))]);
                case 'error'
                    error(['The files of loop ', num2str(istr), ' are more than ', num2str(check(2))]);
            end;
            
        end;
    end;
end;
end