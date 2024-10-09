%% GTmat_cor(GTstruct1, GTstruct2,'ResField', value )
%
% This functions perform a correlation between two GTstruct by selecting a field.
% - GTstruct1 and GTstruct2: data struct to correlate
% - ResField: Selected field of the data struct to correlate between the
% two GTstructs
% Author: Giorgio Arcara
%
% Data : 4/02/2018;
%
%
function [cormat, pmat] = GTmat_cor(GTstruct1, GTstruct2, varargin);

p = inputParser;
addParameter(p, 'ResField', [], @ischar);
parse(p, varargin{:});

ResField = p.Results.ResField;

data1 = [GTstruct1.(ResField)];
data2 = [GTstruct2.(ResField)];


% resstore the 3d dimension with subjects
data1 = reshape(data1, size(GTstruct1(1).(ResField), 1), size(GTstruct1(1).(ResField), 2), length(GTstruct1));
data2 = reshape(data2, size(GTstruct2(1).(ResField), 1), size(GTstruct2(1).(ResField), 2), length(GTstruct2));

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
    [R, P]=corrcoef(datamat1(iT,:)', datamat2(iT,:)');
    corvec(iT) = R(2,1); % from https://stackoverflow.com/questions/14342938/correlation-between-two-vectors
    pvec(iT) = P(2,1);
end;

% notice the two datasets are different for the third dimension,
% hence I can use the first two
cormat = reshape(corvec, size(data1, 1), size(data1, 2));
pmat = reshape(pvec, size(data1, 1), size(data1, 2));



