function [cormat, pmat] = GTcorrelation(GTstruct1, GTstruct2, opt)
    arguments
        GTstruct1 (1,:) struct
        GTstruct2 (1,:) struct {mustBeSameSize(GTstruct1, GTstruct2)}
        opt.Field1 (1,1) string {isfield(GTstruct1, opt.ResField)} = requiredvalue
        opt.Field2 (1,1) string {isfield(GTstruct2, opt.ResField2)} = ""
    end
%% GTcorrelation - Correlates field values from two GTstructs
%
% [cormat, pmat] = GTcorrelation(GTstruct1, GTstruct2, 'Field1', value, 'Field2', value)
% 
% This functions perform a Pearson correlation between corresponding values
% in a specified field of two GTstruct objects
%
% Inputs:
%   GTstruct1 (struct): First struct array (e.g. data from group A)
%
%   GTstruct2 (struct): Second struct array (e.g. data from group B)
%
%   Field1 (string, optional): Name of the field in GTstruct1 to ecxtract
%   data to correlate
%
%   Field2 (string, optional): Name of the field in GTstruct2 to extract
%   data to correlate
%
% Outputs:
%   cormat: Correlation matrix
%
%   pmat: pvalue matrix
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
%
% Version: 29/05/2025


Field1 = opt.Field1;
if strlength(opt.Field2) == 0
    Field2 = opt.Field2;
else
    Field2 = Field1;
end

data1 = [GTstruct1.(Field1)];
data2 = [GTstruct2.(Field2)];


% resstore the 3d dimension with subjects
data1 = reshape(data1, size(GTstruct1(1).(Field1), 1), size(GTstruct1(1).(Field1), 2), length(GTstruct1));
data2 = reshape(data2, size(GTstruct2(1).(Field2), 1), size(GTstruct2(1).(Field2), 2), length(GTstruct2));

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

