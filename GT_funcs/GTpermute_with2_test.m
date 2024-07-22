%% GTpermute_with2_test(GTstruct1, GTstruct2, 'InField', value, 'Iterations', value, 'ResMat', value)
%
% This function perform a permutation test from two GT struct
% using a procedure as in Brookes at al 2016 (Neuroimage). http://dx.doi.org/10.1016/j.neuroimage.2016.02.045
%
% This function takes as input a cell with EXACTLY two GTres structs with single
% subjects data. It considers each GTstruct as a repeated measures from the same group (within).
%  it does the following steps:
% - permutation 1000 to obtain 1000 new difference object
% - calculate distribution of permutation X
% - convert observed difference in empirical p-values by comparing with
% distribution X
% group average for the separate groups it then create a difference between
% the two objects and then extract only the
%
% VERSION 2
%
%
% INPUT:
%
% - GTstruct1: the first GTstruct
% - GTstruct2: the second GTstruct
% - InField: a cell with the fields of the GTstruct that should be used
%              to calculated permuted average.
% - Iterations: number indicating the number of permutation (default is
% 1000).
% - ResMat: string indicating ...
% currently it works only with one field.
%
% OUTPUT:
%  - pmat : matrix with pvalues. by default it applyes FDR correction
%  - obs_diff_mat: matrix with observed differences.
%  - Rand_res: vector with all random values generated during permutation
%
% Author: Giorgio Arcara
%
% Version: 4/03/2018



function [obs_diff_mat, p_mat_fdr, p_mat_unc, Rand_res] = GTpermute_with2_test(GTstruct1, GTstruct2, varargin)
p = inputParser;
addParameter(p, 'InField', [], @ischar);
addParameter(p, 'Iterations', 1000, @isnumeric)
addParameter(p, 'ResMat', [], @ischar)
parse(p, varargin{:});

InField = p.Results.InField;
Iterations =  p.Results.Iterations;
ResMat =  p.Results.ResMat;

% preliminary checks
if length(GTstruct1)~=length(GTstruct2)
    error('GT: The length of GTstruct1 should be the same of the length of GTstruct2 (this function is for within subject design).')
end;


if isempty(ResMat)
    ResMat = 'upper';
end;


n_subj = length(GTstruct1);

% set n groups (this is just because this function is similar to GTpermute.
n_groups = 2;

% first isolate only half matrix according to resmat
GTstruct1 = GTdiag_mat(GTstruct1, 'InField', InField, 'OutField', InField);
GTstruct2 = GTdiag_mat(GTstruct2, 'InField', InField, 'OutField', InField);

% create observed average
obs_ave1 = GTaverage(GTstruct1, 'InField', {InField});
obs_ave2 = GTaverage(GTstruct2, 'InField', {InField});

% create observed difference of average
obs_diff = GTdifference(obs_ave1, obs_ave2, 'InField', {InField});



% for loop over Iterations
for iIter = 1:Iterations

    % permute labels
    perm_signs = datasample([1, -1], n_subj);
    % this will decide which labels I will swap.

    GTrand_subj1 = struct();
    GTrand_subj2 = struct();

    for iSubj = 1:n_subj

        if perm_signs(iSubj) == 1 % case one: don't swap
            GTrand_subj1(iSubj).(InField) = GTstruct1(iSubj).(InField);
            GTrand_subj2(iSubj).(InField) = GTstruct2(iSubj).(InField);
        elseif perm_signs(iSubj) == -1 % case two: swap.
            GTrand_subj1(iSubj).(InField) = GTstruct2(iSubj).(InField);
            GTrand_subj2(iSubj).(InField) = GTstruct1(iSubj).(InField);
        end;
    end;

    GTrand1 = GTaverage(GTrand_subj1, 'InField', {InField});
    GTrand2 = GTaverage(GTrand_subj2, 'InField', {InField});

    % store results
    % initialize the object at first iteration
    if iIter == 1
        GTperm1= GTrand1;
        GTperm2= GTrand2;

    else
        %update existing objects in later Iterations
        GTperm1(end+1) = GTrand1;
        GTperm2(end+1) = GTrand2;

    end;

    % debug
    %imagesc(GTrand1.mat_or)
    %figure
    %imagesc(GTrand2.mat_or)

    % draw progress
    GTprogressbar(iIter, Iterations);

    Rand_diff = GTdifference(GTperm1, GTperm2, 'InField', {InField}, 'Verbose', 0);
    Rand_values = [Rand_diff.(InField)];
    Rand_values = Rand_values(:);
    Rand_res = Rand_values(~isnan(Rand_values)); % important. exclude NaN

    Rand_max(iIter) = max(abs(Rand_res));

end;

values_mat = obs_diff.(InField);
values = values_mat(:); % to unlist in a vector

values_mat = obs_diff.(InField);
values = values_mat(:); % to unlist in a vector

p_res = zeros(size(values));

for iV = 1:length(values)
    p_res(iV) = sum(Rand_max>=abs(values(iV))) / Iterations;
end;

% create matrix with uncorrected p values.
p_mat_unc = reshape(p_res, size(values_mat));

[~, ~, ~, adj_p] = fdr_bh(p_mat_unc(~isnan(p_mat_unc)), 0.05);

p_mat_fdr = nan(size(p_mat_unc));
p_mat_fdr(~isnan(p_mat_unc)) = adj_p;


obs_diff_mat = values_mat;
%  to check the reshaping was ok
% values_mat2 = reshape(values, size(values_mat));




end