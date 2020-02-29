%% GTmat_ttest(2GTres_diff)
%
% This functions perform a independent sample t-test.
%
% Author: Girogio Arcara
%
% Data : 4/02/2018;
%
%
function [tmat, pmat] = GTmat_ttest2(GTstruct1, GTstruct2, resfield);

data1 = [GTstruct1.(resfield)];
data2 = [GTstruct2.(resfield)];


% resstore the 3d dimension with subjects
data1 = reshape(data1, size(GTstruct1(1).(resfield), 1), size(GTstruct1(1).(resfield), 2), length(GTstruct1));
data2 = reshape(data2, size(GTstruct2(1).(resfield), 1), size(GTstruct2(1).(resfield), 2), length(GTstruct2));

% suboptimal (made to work on all cells of a symmetric matrix) could be
% optmized

% convert to single col

datamat1 = reshape(data1, size(data1, 1)*size(data1, 2), size(data1,3));
datamat2 = reshape(data2, size(data2, 1)*size(data2, 2), size(data2,3));

% reconstruct back to check if the step with t will be correct

%pr1back = reshape(datamat, size(data1, 1), size(data1, 1), size(data1,3));
%all(pr1back(:)==data1(:))

pvec = zeros(1, size(data1, 1)*size(data2, 1));

for iT = 1:size(datamat1, 1)
    [~, pvec(iT), ~, stats]=ttest2(datamat1(iT,:), datamat2(iT,:));
    tvec(iT) = stats.tstat;   
end;

% notice the two datasets are different for the third dimension,
% hence I can use the first two 
tmat = reshape(tvec, size(data1, 1), size(data1, 2));
pmat = reshape(pvec, size(data1, 1), size(data1, 2));



