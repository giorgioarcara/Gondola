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
% return error for non existing directory
if (length(file_dir)==0)
    error('GT: the specified directory is non existing.');
end;

file_names = {file_dir(3:end).name}; %exclude '.', and '..'

if (length(file_names)==0)
    error('GT: the specified directory is empty.');
end;

end
