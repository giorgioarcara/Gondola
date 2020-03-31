%% GTpermute_with2(GTstruct1, GTstruct2, ResField, value, 'Iterations', value, 'ResMat', value)
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
% - ResField: a cell with the fields of the GTstruct that should be used
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



function [obs_diff_mat, p_mat_fdr, p_mat_unc, Rand_res] = GTpermute_with2(GTstruct1, GTstruct2, varargin)
p = inputParser;
addParameter(p, 'ResField', [], @iscell);
addParameter(p, 'Iterations', [], @isnumeric)
addParameter(p, 'ResMat', [], @ischar)
parse(p, varargin{:});

ResField = p.Results.ResField;
Iterations =  p.Results.Iterations;
ResMat =  p.Results.ResMat;

% preliminary checks

if nargin < 3
    error('3 inputs are mandatory: GTstruct1, GTstruct2 and the ResField')    
end;

if nargin < 4
    Iterations = 1000;
end;

if nargin < 5
    ResMat = 'upper';
end;


n_subj = length(GTstruct1);

% set n groups (this is just because this function is similar to GTpermute.
n_groups = 2;

% first isolate only half matrix according to resmat
GTstruct1 = GTdiag_mat(GTstruct1, ResField, ResMat);
GTstruct2 = GTdiag_mat(GTstruct2, ResField, ResMat);

% create observed average
obs_ave1 = GTaverage(GTstruct1, {ResField});
obs_ave2 = GTaverage(GTstruct2, {ResField});

% create observed difference of average
obs_diff = GTdifference(obs_ave1, obs_ave2, {ResField});



% for loop over Iterations
for iIter = 1:Iterations
    
    % permute labels
    perm_signs = datasample([1, -1], n_subj);
    % this will decide which labels I will swap.
    
    GTrand_subj1 = struct();
    GTrand_subj2 = struct();
    
    for iSubj = 1:n_subj
        
            if perm_signs(iSubj) == 1 % case one: don't swap
                GTrand_subj1(iSubj).(ResField) = GTstruct1(iSubj).(ResField);
                GTrand_subj2(iSubj).(ResField) = GTstruct2(iSubj).(ResField);
            elseif perm_signs(iSubj) == -1 % case two: swap.
                GTrand_subj1(iSubj).(ResField) = GTstruct2(iSubj).(ResField);
                GTrand_subj2(iSubj).(ResField) = GTstruct1(iSubj).(ResField);
            end;        
    end;
    
    GTrand1 = GTaverage(GTrand_subj1, {ResField});
    GTrand2 = GTaverage(GTrand_subj2, {ResField});

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
    
end;

    Rand_diff = GTdifference(GTperm1, GTperm2, {'mat_or'});
    Rand_values = [Rand_diff.mat_or];
    Rand_values = Rand_values(:);
    Rand_res = Rand_values(~isnan(Rand_values)); % important. exclude NaN
    
    % p_res = arrayfun(@(x)(invprctile(Rand_res, x)), obs_diff.(ResField)); 
    
    values_mat = obs_diff.(ResField);
    values = values_mat(:); % to unlist in a vector
    
    % to take into account that I want extreme values Itransform everything in negative absolute values 
    % and then in negative.
    % In this way to use a single call to calculate probability of more extrame values
    % to invprctile
    neg_abs_values = -abs(values);
    
    p_res = invprctile(Rand_res, neg_abs_values)./100; % divide by 100 to transform in p-values
    
    % create matrix with uncorrected p values.
    p_mat_unc = reshape(p_res, size(values_mat));
    
   [~, ~, ~, adj_p] = fdr_bh(p_mat_unc(~isnan(p_mat_unc)), 0.05);
    
    p_mat_fdr = nan(size(p_mat_unc));
    p_mat_fdr(~isnan(p_mat_unc)) = adj_p;
    
    
    
    obs_diff_mat = values_mat;
    %  to check the reshaping was ok
    % values_mat2 = reshape(values, size(values_mat));

    


end