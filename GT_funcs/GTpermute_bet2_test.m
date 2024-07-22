%% GTpermute_bet2_test(GTstruct1, GTstruct2, 'InField', value, 'Iterations', value, 'ResMat', value)
%
% This function perform a between permutation test from two GT structs
% using a procedure similar to those in Brookes at al 2016 (Neuroimage). http://dx.doi.org/10.1016/j.neuroimage.2016.02.045
% but adapted for between comparisons.
%
% This function takes as input a cell bet EXACTLY two GTres structs with single
% subjects data. It considers each GTstructs as two separate groups.
%  it does the following steps:
% - permutation labels of group "Iterations" times (default Iteration).
% - calculate average values for connectivity
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
% - InField: a cell bet the fields of the GTstruct that should be used
%              to calculated permuted average.
% - Iterations: number indicating the number of permutation (default is
% 1000).
% - ResMat: string indicating ... 
% currently it works only bet one field.
%
% OUTPUT:
%  - pmat : matrix bet pvalues. by default it applyes FDR correction
%  - obs_diff_mat: matrix bet observed differences.
%  - Rand_res: vector bet all random values generated during permutation
%
% Author: Giorgio Arcara
%
% Version: 4/03/2018



function [obs_diff_mat, p_mat_fdr, p_mat_unc, Rand_res] = GTpermute_bet2_test(GTstruct1, GTstruct2, varargin)
p = inputParser;
addParameter(p, 'InField', [], @ischar);
addParameter(p, 'Iterations', 1000, @isnumeric)
addParameter(p, 'ResMat', [], @ischar)
parse(p, varargin{:});

InField = p.Results.InField;
Iterations =  p.Results.Iterations;
ResMat =  p.Results.ResMat;

if isempty(ResMat)
    ResMat = 'upper';
end;



% first isolate only half matrix according to resmat
GTstruct1 = GTdiag_mat(GTstruct1, 'InField', InField, 'OutField', InField);
GTstruct2 = GTdiag_mat(GTstruct2, 'InField', InField, 'OutField', InField);

% create observed average
obs_ave1 = GTaverage(GTstruct1, 'InField', {InField});
obs_ave2 = GTaverage(GTstruct2, 'InField', {InField});

% create observed difference of average
obs_diff = GTdifference(obs_ave1, obs_ave2, 'InField', {InField});

% create a concatenated struct
len_1 = length(GTstruct1);
len_2 = length(GTstruct2);

for iL = 1:len_1
    GTstruct12(iL).(InField)=GTstruct1.(InField);
end;

for iL2 = 1:len_2
    GTstruct12(iL2+len_1).(InField)=GTstruct2.(InField);
end;

Rand_max = [];

% for loop over Iterations
for iIter = 1:Iterations
    
    % define permutation labels
    perm_lab = [repmat(1, length(GTstruct1), 1); repmat(2, length(GTstruct2), 1)];
    % this will decide which labels I will swap.

    curr_perm = perm_lab(randperm(length(perm_lab)));
    
    
    GTperm1 = GTaverage(GTstruct12(find(curr_perm==1)), 'InField', {InField});
    GTperm2 = GTaverage(GTstruct12(find(curr_perm==2)), 'InField', {InField});

    
    % draw progress
    GTprogressbar(iIter, Iterations);
    
    Rand_diff = GTdifference(GTperm1, GTperm2, 'InField', {InField}, 'Verbose', 0);
    Rand_values = [Rand_diff.(InField)];
    Rand_values = Rand_values(:);
    Rand_res = Rand_values(~isnan(Rand_values)); % important. exclude NaN
    
    Rand_max(iIter) = max(abs(Rand_res));
    
    
    end;

    % p_res = arrayfun(@(x)(invprctile(Rand_res, x)), obs_diff.(InField)); 
    
    values_mat = obs_diff.(InField);
    values = values_mat(:); % to unlist in a vector
    
    p_res = zeros(size(values));

    for iV = 1:length(values)
     p_res(iV) = sum(Rand_max>=abs(values(iV))) / Iterations;
    end;
    

    % create matrix bet uncorrected p values.
    p_mat_unc = reshape(p_res, size(values_mat));
    
   [~, ~, ~, adj_p] = fdr_bh(p_mat_unc(~isnan(p_mat_unc)), 0.05);
    
    p_mat_fdr = nan(size(p_mat_unc));
    p_mat_fdr(~isnan(p_mat_unc)) = adj_p;
    
    
    
    obs_diff_mat = values_mat;
    %  to check the reshaping was ok
    % values_mat2 = reshape(values, size(values_mat));

    


end