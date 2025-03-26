function GTdiff = GTdifference(GTstruct1, GTstruct2, opt)
    arguments
        GTstruct1 (1,:) struct
        GTstruct2 (1,:) struct {mustBeSameSize(GTstruct1, GTstruct2)}
        opt.InFields (1,:) string {isfield(GTstruct1, opt.InFields)} = requiredvalue
        opt.InFields2 (1,:) string {isfield(GTstruct2, opt.InFields2)} = ""
        opt.OtherFields (1,:) string {isfield(GTstruct1, opt.OtherFields)} = {}
        opt.OtherFields2 (1,:) string {isfield(GTstruct2, opt.OtherFields2)} = {}
    end
%% GTdifference(GTstruct1, GTstruct2, 'InFields', {value},'OtherFields', {value})
%
% This function takes as input a GTstruct object (object with results from an analysis
% with a script like BCT_analysis.m) and compute the difference of the
% matrices in a field: GTstruct1.InFields - GTstruct2.InFields2
%
% Important:
%   The function will perform GTstruct1.InFields - GTstruct2.InFields to be meaningful it is fundamental that the user supply GTstruct in which
% the subjects are in the same order.
%
% Parameters:
%   GTstruct1 (struct): the first GTstruct struct with the results
%   GTstruct2 (struct): the second GTstruct struct with the results
% 
% Other Parameters:
%   InFields ([str], required): the name of the fields of GTstruct1 that will be subtracted
%   InFields2 ([str]): the name of the fields of GTstruct1 that will be
%   subtracted. Default: Same of InFields.
%   OtherFields ([str]): the other fields of GTstruct1 to be kept. Default {}
%   OtherFields2 ([str]): the other fields of GTstruct2 to be kept. Default {}

% Author: Giorgio Arcara
%
% version: 17/07/2024
%
%

InFields = opt.InFields;
if strlength(opt.InFields2) == 0
    InFields2 = opt.InFields;
else
    InFields2 = opt.InFields2;
end
if length(InFields) ~= length(InFields2)
    error("The list of fields of the two structures must have the same length")
end
OtherFields = opt.OtherFields;
OtherFields2 = opt.OtherFields2;

warning('Make sure to have the two GTstructs with the objects in the appropriate order!');

GTdiff = struct();

% copy other fields of GTstruct1
for fn = OtherFields
    for isubj = 1:length(GTstruct1)
        GTdiff(isubj).(fn{1}) = GTstruct1(isubj).(fn{1});
    end
end
% copy other fields of GTstruct2
for fn = OtherFields2
    for isubj = 1:length(GTstruct2)
        GTdiff(isubj).(fn{1}) = GTstruct2(isubj).(fn{1});
    end
end


% now load the data
for iE=1:length(GTstruct1);
    for iField = 1:length(InFields);
        GTdiff(iE).(InFields{iField}) = GTstruct1(iE).(InFields{iField}) - GTstruct2(iE).(InFields2{iField});
    end;
    
end;






% note an alternative way is to get all values
% Res = [GTstruct.InFields], reshape with 3rd dimension and then average





