%% get_file_names(Dir)
%
% this function returns all the file names in dir
% (usefeul to get the list of data to import).
%
% INPUT
%      - Dir: a string with the directory from where retrieve the file names
%    
%
% OUTPUT:
%     - file_names: a cell with the file names.
%
%
%

function file_names = get_file_names(Dir)

file_dir = dir(Dir);
file_names = {file_dir(3:end).name}; %exclude '.', and '..'

end
