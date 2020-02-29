%% GTvec_ttest(GTres_diff)
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

function [tmat, pmat] = GTvec_ttest(GTres_diff, resfield);

GTstruct = GTres_diff;

data = [GTstruct.(resfield)];


datamat = reshape(data, length(GTstruct(1).(resfield)), length(GTstruct));

% suboptimal (made to work on all cells of a symmetric matrix) could be
% optmized

pvec = zeros(1, size(datamat, 1));

for iT = 1:size(datamat, 1)
   [~, pvec(iT), ~, stats]=ttest(datamat(iT,:));
   tvec(iT) = stats.tstat;
end;

tmat = tvec;
pmat = pvec;





