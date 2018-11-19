%% GTpermute_with2(GTstruct1, GTstruct2, resfields, varargin)
%
% (WITHIN SUBJECT PERMUTATION)
% This function takes as input a cell with EXACTLY two GTres structs with single
% subjects data. It considers each GTstruct as a repeated measures from the same group (within).
% Each iteration (default = 1000) it shuffles the labels and computes a by
% group average for the separate groups. It then return a cell with two objects
% with the n=iterations Average computed with permutated labels.
% The results may be used to compute a null distriubtion to be compared
% with observed data.
%
% VERSION 2 (by David).
%
%
% INPUT:
%
% - GTstruct1: the first GTstruct
% - GTstruct2: the second GTstruct
% - resfields: a cell with the fields of the GTstruct that should be used
%              to calculated permuted average.
% - iterations: number indicating the number of permutation (default is
% 1000).
%
% currently it works only with one field.
%
%
% Author: Giorgio Arcara
%
% Version: 4/03/2018



function [GTperm1, GTperm2] = GTpermute_with2(GTstruct1, GTstruct2, resfields, varargin)
% preliminary checks

if nargin < 3
    error('3 inputs are mandatory: GTstruct1, GTstruct2 and the resfields')
elseif nargin ==3
    iterations = 1000;
else
    iterations = varargin{1};
end


n_subj = length(GTstruct1);

% set n groups (this is just because this function is similar to GTpermute.
n_groups = 2;

% for loop over iterations
for iIter = 1:iterations
    
    % permute labels
    perm_signs = datasample([1, -1], n_subj);
    % this will decide which labels I will swap.
    
    GTrand_subj1 = struct();
    GTrand_subj2 = struct();
    
    for iSubj = 1:n_subj
        
        for iField = 1:length(resfields);
            if perm_signs(iSubj) == 1 % case one: don't swap
                GTrand_subj1(iSubj).(resfields{iField}) = GTstruct1(iSubj).(resfields{iField});
                GTrand_subj2(iSubj).(resfields{iField}) = GTstruct2(iSubj).(resfields{iField});
            elseif perm_signs(iSubj) == -1 % case two: swap.
                GTrand_subj1(iSubj).(resfields{iField}) = GTstruct2(iSubj).(resfields{iField});
                GTrand_subj2(iSubj).(resfields{iField}) = GTstruct1(iSubj).(resfields{iField});
            end;
        end;
        
    end;
    
    GTrand1 = GTaverage(GTrand_subj1, resfields);
    GTrand2 = GTaverage(GTrand_subj2, resfields);

    % store results
    % initialize the object at first iteration
    if iIter == 1
        GTperm1= GTrand1;
        GTperm2= GTrand2;

    else
        %update existing objects in later iterations
        GTperm1(end+1) = GTrand1;
        GTperm2(end+1) = GTrand2;

    end;
    
    % draw progress
    GTprogressbar(iIter, iterations);
    
end;


end