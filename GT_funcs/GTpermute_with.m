%% GTpermute_with(GTstruct1, GTstruct2, 'ResFields', value, 'Iterations', value)
%
% (WITHIN SUBJECT PERMUTATION)
% This function takes as input a cell with EXACTLY two GTstructs with single
% subjects data. It considers each GTstruct as a repeated measures from the same group (betwithinween).
% Each iteration (default = 1000) it shuffles the labels and computes a by
% group average. It then return an object with the n=Iterations Average computed with permutated labels.
% The results may be used to compute a null distriubtion to be compared
% with observed data.
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



function GTperm = GTpermute_with(GTstruct1, GTstruct2, varargin);

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


% NOTE: current version is probablty suboptimal in terms of computation.
% alternative strategy would be: to create a difference results just onnce
%
% GTresdiff = GTdifference(GTstruct1, GTstruct2, ResFields);
%
% then convert in a matrix with one subject per row and one vector per all conn
% values and then mutliplicate with a random vector (just repated scalar
% multi) with randomly sampled 1 and -1
% permute (within)
% note that apparently looping (albeit may seems suboptimal) is the
% fastest solution in matlab (See link below)
% https://it.mathworks.com/matlabcentral/answers/7039-how-to-multiply-a-vector-with-each-column-of-a-matrix-most-efficiently
%
%  n_subj = length(GTstruct1);
%  perm_labels = datasample([1, -1], n_subj);
% GTmat = zeros(length(GTresdiff), size(GTstruct1(1).(resfield), 1)*size(GTstruct1(1).(resfield), 2));
%
% I'm keeping this version to avoid complicated code (it shoudl works with
% multiple fields).

GTresdiff = GTdifference(GTstruct1, GTstruct2, ResFields);

n_subj = length(GTstruct1);

% set n groups (this is just because this function is similar to GTpermute.
n_groups = 2;

% initialize result object
GTperm = struct();

% for loop over Iterations
for iIter = 1:Iterations
    
    % permute labels
    perm_signs = datasample([1, -1], n_subj);
    
    GTrand_subj = struct();
    
    for iSubj = 1:n_subj
        
        % multiply the random sign for every subject
        % (loop over every field)
        for iField = 1:length(ResFields);
            GTrand_subj(iSubj).(ResFields{iField}) = GTresdiff(iSubj).(ResFields{iField}) * perm_signs(iSubj);
        end;
        
    end;
    
    GTrand = GTaverage(GTrand_subj, ResFields);
    % store results
    % initialize the object at first iteration
    if iIter == 1
        GTperm= GTrand;
    else
        %update existing objects in later Iterations
        GTperm(end+1) = GTrand;
    end;
    
    % draw progress
    GTprogressbar(iIter, Iterations);
    
end;


end