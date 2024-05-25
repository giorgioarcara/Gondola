%% diag_mat(mat, 'Type', value);
%
% This function extract the upper or lower
% triangular matrix (diagonal excluded), substituting with NaN, all other
% values.
%
% INPUT:
%
% - mat: a matrix
% - Type: 'upper' or 'lower'.

function res_diag = diag_mat(mat, varargin)

p = inputParser;
addParameter(p, 'Type', [], @ischar);

parse(p, varargin{:});


Type =  p.Results.Type;

if strcmp(Type, 'upper')
    
    % loop over all objects in GTstruct and compute the measure.
    res_diag = triu(mat);
    
    x = logical(tril(ones(size(mat))));
    
    res_diag(x==1) = NaN ;
    
end;

if  strcmp(Type, 'lower')
    
    % loop over all objects in GTstruct and compute the measure.
    res_diag = tril(mat);
    
    x = logical(triu(ones(size(mat))));
    
    res_diag(x==1) = NaN ;
    
    
end;