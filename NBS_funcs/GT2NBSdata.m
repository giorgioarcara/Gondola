%% GT2NBSdata(GTstruct, 'ResField', 'value')
% This function starts from a GTstruct and create a matrix that can be
% supplied to NBSglm, for Glm
%
% INPUT:
% - GTstruct, the GTstruct
% - 'Resfield', the field with the matrix
%
%
% DEATILS: the function take each matrix, extract the upper diag matrix (no
% diag) and then vectorize it in order to have a subject x node_values
% matrix.
%
% Author: Giorgio Arcara
%
% Version: 20/05/2020

function [y] = GT2NBSdata(GTstruct, varargin)

p = inputParser;
addParameter(p, 'ResField', [], @ischar);
parse(p, varargin{:});
ResField = p.Results.ResField;

if isempty(ResField)
    error('GT: you must specify a ResField')
end;

% take first element for matrix initialization
template = GTstruct(1).(ResField);
n_subjects = length(GTstruct);
n_conn_values = ((size(template,1)^2) - size(template,1))/2;

y = zeros(n_subjects, n_conn_values);

GTdiag_res = GTdiag_mat(GTstruct, 'ResField', ResField);
for iG=1:length(GTdiag_res)
    curr_mat = GTdiag_res(iG).(ResField);
    y(iG,:) = curr_mat(~isnan(curr_mat))';
end;

end