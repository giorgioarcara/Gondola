function [tvec, pvec] = GTvec_ttest2(GTstruct1, GTstruct2, Field);
    arguments
        GTstruct1 (1, :) struct
        GTstruct2 (1, :) struct
        Field (1, 1) string
    end


%% GTvec_ttest2(GTstruct1, GTstruct2, Field)
%
% This function performs a independent sample t-test over vectors (GT
% measures)
%
% Inputs:
%   GTstruct1 (struct): First GTstruct object 
%   GTstruct2 (struct): Second GTstruct object
%   Field (string): Name of the field of the GTstructs containing the
%   vectors for which you want to calculate t-test
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
%
% Data : 29/09/2025;
%
%



data1 = [GTstruct1.(Field)];
data2 = [GTstruct2.(Field)];

datamat1 = reshape(data1, length(GTstruct1(1).(Field)), length(GTstruct1));
datamat2 = reshape(data2, length(GTstruct2(1).(Field)), length(GTstruct2));

% suboptimal (made to work on all cells of a symmetric matrix) could be
% optmized

% convert to single col


% reconstruct back to check if the step with t will be correct

%prback = reshape(datamat, size(pr, 1), size(pr, 1), size(pr,3));
%all(prback(:)==pr(:))

pvec = zeros(1, size(datamat1, 1));

for iT = 1:size(datamat1, 1)
   [~, pvec(iT), ~, stats]=ttest2(datamat1(iT,:), datamat2(iT, :));
   tvec(iT) = stats.tstat;
end;




