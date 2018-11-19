%% GTmat_ttest(GTres_diff)
%
% This functions perform a paired t-test.
% Currently you can also use the function supplying a struct with difference scores
% as those from GTdifference function.
%
% 
% 
%
% Author: Girogio Arcara
%
% Data : 4/02/2018;
%
%

function [tmat, pmat] = GTmat_ttest(GTres_diff, resfield);

GTstruct = GTres_diff;

data = [GTstruct.(resfield)];


data = reshape(data, size(GTstruct(1).(resfield), 1), size(GTstruct(1).(resfield), 2), length(GTstruct));

% suboptimal (made to work on all cells of a symmetric matrix) could be
% optmized

% convert to single column

datamat = reshape(data, size(data, 1)*size(data, 2), size(data,3));

% initialize empty vectors
pvec = zeros(1, size(data, 1)*size(data, 2));
tvec = zeros(1, size(data, 1)*size(data, 2));


% perform T: !!! NOTE !!! Suboptimal, actually it performs t for all comparisons
% (alsto the duplicated oens).
for iT = 1:size(datamat, 1)
   [~, pvec(iT), ~, stats]=ttest(datamat(iT,:));
   tvec(iT) = stats.tstat;
end;

% reconstruct the matrices back
tmat = reshape(tvec, size(data, 1), size(data, 2));
pmat = reshape(pvec, size(data, 1), size(data, 2));



