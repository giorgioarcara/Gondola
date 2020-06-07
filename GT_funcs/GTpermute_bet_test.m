%% GTpermute_bet(GTstructcell, 'ResFields', value, 'Iterations', value)
%
% (BETWEEN SUBJECT PERMUTATION)
% This function takes as input a cell with at least two GTres struct with single
% subjects data. It considers each GTstruct as a separate group (between).
% Each Iteration (default = 1000) it shuffles the labels and computes a by
% group average. It then return an object with the n=Iterations Average computed with permutated labels.
% The results may be used to compute a null distriubtion to be compared
% with observed data.
%
% INPUT:
%
% - GTstructcell: a cell containing GTstructs
% - ResFields: a cell with the fields of the GTstruct that should be used
%              to calculated permuted average.
% - Iterations: number indicating the number of permutation (default is
% 1000).
%
%
% Author: Giorgio Arcara
%
% Version: 4/03/2018



function [obs_diff_mat, p_mat_fdr, p_mat_unc, Rand_res] = GTpermute_bet_test(GTstruct1, GTstruct2, varargin)
p = inputParser;
addParameter(p, 'ResField', [], @ischar);
addParameter(p, 'Iterations', 1000, @isnumeric)
addParameter(p, 'ResMat', [], @ischar)
parse(p, varargin{:});

ResField = p.Results.ResField;
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

% create labels
% first extract group length
groups_len=cellfun(@length, GTstructcell);
% initialize empty vector for labels (suboptimal, but not a big ussue as it is a small matrix).
% create labels that will be 1,2,3,...n with n the total number of groups.
labels = [];
for iGroup = 1:length(GTstructcell);
    labels = [labels; repmat(iGroup, groups_len(iGroup), 1)];
end;

% transform to a single struct (for easier computations)
GTallstruct = GTcell2struct(GTstructcell);

% initialize final object
GTpermcell = cell(1, n_groups);

% for loop over Iterations
for iIter = 1:Iterations
    
    % permute labels
    perm_labels = labels( randperm( length(labels) ) );
    
    % loop over groups
    for iRandGroup = 1:n_groups
        
        % compute average
        curr_indices = find(perm_labels == iRandGroup); % note I can do this cause labels are 1,2, ...n
        GTrand = GTaverage(GTallstruct(curr_indices), ResFields);
        % store results
        % initialize the object at first Iteration
        if iIter == 1
            GTpermcell{iRandGroup} = GTrand;
        else
            %update existing objects in later Iterations
            GTpermcell{iRandGroup}(end+1) = GTrand;
        end;
        
    end;
    
    GTprogressbar(iIter, Iterations);
    
end;

end