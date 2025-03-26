function [cormat, pmat] = GTcorrelation(GTstruct1, GTstruct2, opt)
    arguments
        GTstruct1 (1,:) struct
        GTstruct2 (1,:) struct {mustBeSameSize(GTstruct1, GTstruct2)}
        opt.ResField (1,1) string {isfield(GTstruct1, opt.ResField)} = requiredvalue
        opt.ResField2 (1,1) string {isfield(GTstruct2, opt.ResField2)} = ""
    end
%% GTmat_cor(GTstruct1, GTstruct2,'ResField', value, 'ResField2', value )
%
% This functions perform a correlation between two GTstruct by selecting a field.
%
% Parameters:
%   GTstruct1 (struct): first data struct to correlate
%   GTstruct2 (struct): second data struct to correlate
%
% Other Parameters:
%   ResField (str, required): Selected field of the first data struct to correlate between the two GTstructs
%   ResField2 (str): Selected field of the second data struct to correlate
%   between the two GTstructs. Default: Same of ResField
% Author: Giorgio Arcara
%
% Data : 4/02/2018;
%
%
ResField = opt.ResField;
if strlength(opt.ResField2) == 0
    ResField2 = opt.ResField2;
else
    ResField2 = ResField;
end

data1 = [GTstruct1.(ResField)];
data2 = [GTstruct2.(ResField2)];


% resstore the 3d dimension with subjects
data1 = reshape(data1, size(GTstruct1(1).(ResField), 1), size(GTstruct1(1).(ResField), 2), length(GTstruct1));
data2 = reshape(data2, size(GTstruct2(1).(ResField2), 1), size(GTstruct2(1).(ResField2), 2), length(GTstruct2));

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

end

