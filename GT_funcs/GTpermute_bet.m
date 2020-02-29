%% GTpermute_bet(GTstructcell, resfields, varargin)
%
% (BETWEEN SUBJECT PERMUTATION)
% This function takes as input a cell with at least two GTres struct with single
% subjects data. It considers each GTstruct as a separate group (between).
% Each iteration (default = 1000) it shuffles the labels and computes a by
% group average. It then return an object with the n=iterations Average computed with permutated labels.
% The results may be used to compute a null distriubtion to be compared
% with observed data.
%
% INPUT:
%
% - GTstructcell: a cell containing GTstructs
% - resfields: a cell with the fields of the GTstruct that should be used
%              to calculated permuted average.
% - iterations: number indicating the number of permutation (default is
% 1000).
%
%
% Author: Giorgio Arcara
%
% Version: 4/03/2018



function GTpermcell = GTpermute_bet(GTstructcell, resfields, varargin)

% preliminary checks

if nargin < 2
    error('2 inputs are mandatory: the GTstructcell and the resfields')
elseif nargin ==2
    iterations = 1000;
end

% set number of groups (for clearer code)
n_groups = length(GTstructcell);

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

% for loop over iterations
for iIter = 1:iterations
    
    % permute labels
    perm_labels = labels( randperm( length(labels) ) );
    
    % loop over groups
    for iRandGroup = 1:n_groups
        
        % compute average
        curr_indices = find(perm_labels == iRandGroup); % note I can do this cause labels are 1,2, ...n
        GTrand = GTaverage(GTallstruct(curr_indices), resfields);
        % store results
        % initialize the object at first iteration
        if iIter == 1
            GTpermcell{iRandGroup} = GTrand;
        else
            %update existing objects in later iterations
            GTpermcell{iRandGroup}(end+1) = GTrand;
        end;
        
    end;
    
    GTprogressbar(iIter, iterations);
    
end;

end