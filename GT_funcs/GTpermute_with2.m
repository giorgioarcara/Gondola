%% GTpermute_with2(GTstruct1, GTstruct2,'ResFields', value, 'Iterations', value)
%
% (WITHIN SUBJECT PERMUTATION)
% This function takes as input a cell with EXACTLY two GTres structs with single
% subjects data. It considers each GTstruct as a repeated measures from the same group (within).
% Each iteration (default = 1000) it shuffles the labels and computes a by
% group average for the separate groups. It then return a cell with two objects
% with the n=Iterations Average computed with permutated labels.
% The results may be used to compute a null distriubtion to be compared
% with observed data.
%
% VERSION 2
%
%
% INPUT:
%
% - GTstruct1: the first GTstruct
% - GTstruct2: the second GTstruct
% - ResFields: a cell with the fields of the GTstruct that should be used
%              to calculated permuted average.
% - Iterations: number indicating the number of permutation (default is
% 1000).
%
% currently it works only with one field.
%
%
% Author: Giorgio Arcara
%
% Version: 4/03/2018



function [Rand_res, GTperm1, GTperm2] = GTpermute_with2(GTstruct1, GTstruct2, varargin)

p = inputParser;
addParameter(p, 'ResField', [], @iscell);
addParameter(p, 'Iterations', [], @isnumeric)
parse(p, varargin{:});

ResField = p.Results.ResField;
Iterations =  p.Results.Iterations;


% preliminary checks

if nargin < 3
    error('3 inputs are mandatory: GTstruct1, GTstruct2 and the ResFields')
elseif nargin ==3
    Iterations = 1000;
else
    Iterations = varargin{2};
end


n_subj = length(GTstruct1);

% set n groups (this is just because this function is similar to GTpermute.
n_groups = 2;

% for loop over Iterations
for iIter = 1:Iterations
    
    % permute labels
    perm_signs = datasample([1, -1], n_subj);
    % this will decide which labels I will swap.
    
    GTrand_subj1 = struct();
    GTrand_subj2 = struct();
    
    for iSubj = 1:n_subj
        
        for iField = 1:length(ResFields);
            if perm_signs(iSubj) == 1 % case one: don't swap
                GTrand_subj1(iSubj).(ResFields{iField}) = GTstruct1(iSubj).(ResFields{iField});
                GTrand_subj2(iSubj).(ResFields{iField}) = GTstruct2(iSubj).(ResFields{iField});
            elseif perm_signs(iSubj) == -1 % case two: swap.
                GTrand_subj1(iSubj).(ResFields{iField}) = GTstruct2(iSubj).(ResFields{iField});
                GTrand_subj2(iSubj).(ResFields{iField}) = GTstruct1(iSubj).(ResFields{iField});
            end;
        end;
        
    end;
    
    GTrand1 = GTaverage(GTrand_subj1, ResFields);
    GTrand2 = GTaverage(GTrand_subj2, ResFields);

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
    Rand_res = Rand_values(~isnan(Rand_values));


end