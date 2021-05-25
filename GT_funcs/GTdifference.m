%% GTdifference(GTstruct1, GTstruct2, 'InFields', {value},'OtherFields', {value})
%
% This function takes as input a GTstruct object (object with results from an analysis
% with a script like BCT_analysis.m) and compute the average of the
% matrices in a field.
%
% INPUT
% - GTstruct1: the first GTstruct struct with the results
% - GTstruct2: the second GTstruct struct with the results
% - InFields: the name of the fields that will be subtracted between(GTstruct1 -
% GTstruct2)between {} brackets
% - OtherFields: the other fields to be kept between {} brackets
%
% IMPORTANTE: The function will perform GTstruct1.InFields - GTstruct2.InFields
%
% to be meaningful it is fundamental that the user supply GTstruct in which
% the subjects are in the same order.
%
%
% Author: Giorgio Arcara
%
% version: 1/02/2018
%
%


function GTdiff = GTdifference(GTstruct1, GTstruct2, varargin)

p = inputParser;
addParameter(p, 'InFields', [], @iscell);
addParameter(p, 'OtherFields', [], @iscell);

parse(p, varargin{:});

InFields = p.Results.InFields;
OtherFields =  p.Results.OtherFields;

GTdiff = struct();

if (exist('OtherFields')&~isempty('OtherFields'))
    % first copy all the other fields
    for fn = OtherFields
        for isubj = 1:length(GTstruct1);
            GTdiff(isubj).(fn{1}) = GTstruct1(isubj).(fn{1});
        end
    end
end


% now load the data
for iE=1:length(GTstruct1);
    for iField = 1:length(InFields);
        GTdiff(iE).(InFields{iField}) = GTstruct1(iE).(InFields{iField}) - GTstruct2(iE).(InFields{iField});
    end;
    
end;

warning('Make sure to have the two GTstructs with the objects in the appropriate order!')




% note an alternative way is to get all values
% Res = [GTstruct.InFields], reshape with 3rd dimension and then average





