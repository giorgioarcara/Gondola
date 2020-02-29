%% GTvec_ttest(GTres_diff)
%
% This functions perform a indepdent sample t-test.
% Currently you can also use the function supplying a struct with difference scores
% as those from GTdifference function.
%
% 
%
% Author: Girogio Arcara
%
% Data : 4/02/2018;
%
%
function [tmat, pmat] = GTvec_ttest2(GTstruct1, GTstruct2, resfield);


data1 = [GTstruct1.(resfield)];
data2 = [GTstruct2.(resfield)];

datamat1 = reshape(data1, length(GTstruct1(1).(resfield)), length(GTstruct1));
datamat2 = reshape(data2, length(GTstruct2(1).(resfield)), length(GTstruct2));

% suboptimal (made to work on all cells of a symmetric matrix) could be
% optmized

% convert to single col


% reconstruct back to check if the step with t will be correct

%prback = reshape(datamat, size(pr, 1), size(pr, 1), size(pr,3));
%all(prback(:)==pr(:))

pvec = zeros(1, size(datamat, 1));

for iT = 1:size(datamat, 1)
   [~, pvec(iT), ~, stats]=ttest2(datamat(iT,:));
   tvec(iT) = stats.tstat;
end;


tmat = tvec;
pmat = pvec;


