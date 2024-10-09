% GTplotthresh(GTres, threshfield)
%
% This function takes as input a GTrescell object (cell containing GTres object) and compute the average of the
% matrices separately for cell (you can select subsample).
%
% INPUT
% - GTres: the GTres struct with the results
% - resfield: the name of the field that will be takein into account
%
% NOTE: the function some all the values and then divide by the numebrs
%       so missing values can lead to wrong resuls 
%
%
% Author: Giorgio Arcara
%
% version: 12/01/2018
%
%


function GTthresh_res = GTthresholds(GTres, resfield, threshfield, thresholds);

% transform thresholds to string (for usage of other function)

GTthresh_res = struct();
GTthresh_res.(threshfield) = thresholds;
GTthresh_res.(resfield) = [];

for iThresh = 1:length(thresholds);
        
    GTres_sel = GTsel(GTres, threshfield, num2str(thresholds(iThresh)), 1);
    
    if (length(GTres_sel)==0)
        error('the object with ', threshfields, ' = ', num2str(thresholds(iThresh)), 'is empty\n')
    end;
    
    GTres_sel_ave = GTaverage(GTres_sel, {resfield});
    
    GTthresh_res.(resfield) = [GTthresh_res.(resfield); GTres_sel_ave.(resfield)]; % update incrementally
                
end;
     
end



