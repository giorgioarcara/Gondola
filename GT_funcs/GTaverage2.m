% GTaverage(GTres, resfield, sepfield)
%
% This function takes as input a GTres object (object with results from an analysis
% with a script like BCT_analysis.m) and compute the average of the
% matrices in a field.
%
% INPUT
% - GTres: the GTres struct with the results
% - resfield: the name of the field that will be averaged
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


function Ave = GTaverage(GTres, resfields, sepfield);

% create separator field
 all_data_mat = [GTres.(resfields{iField})];



for iField = 1:length(resfields)
    
    all_data_mat = [GTres.(resfields{iField})];
    
    % use the first object as reference to get the sizes. and
    all_data_mat_r = reshape(all_data_mat, size(GTres(1).(resfields{iField}), 1), size(GTres(1).(resfields{iField}), 2), length(GTres));
    
    Ave.(resfields{iField}) = mean(all_data_mat_r, length(size(all_data_mat_r)));
  
end;



