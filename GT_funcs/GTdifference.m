% GTaverage(GTres1, GTres2 resfields, otherfields)
%
% This function takes as input a GTres object (object with results from an analysis
% with a script like BCT_analysis.m) and compute the average of the
% matrices in a field.
%
% INPUT
% - GTres1: the first GTres struct with the results
% - GTres2: the second GTres struct with the results
% - resfields: the name of the fields that will be subtracted (GTres1 -
% GTres2)
% - otherfields: the other fields to be kept
%
% IMPORTANTE: The function will perform GTres1.resfield - GTres2.resfield
%
% to be meaningful it is fundamental that the user supply GTres in which
% the subjects are in the same order.
%
%
% Author: Giorgio Arcara
%
% version: 1/02/2018
%
%


function GTdiff = GTdifference(GTres1, GTres2, resfields, otherfields);

GTdiff = struct();

if (exist('otherfields')&~isempty('otherfields'))
    % first copy all the other fields
    for fn = otherfields
        for isubj = 1:length(GTres1);
            GTdiff(isubj).(fn{1}) = GTres1(isubj).(fn{1});
        end
    end
end


% now load the data
for k=1:length(GTres1);
    for iField = 1:length(resfields);
        GTdiff(k).(resfields{iField}) = GTres1(k).(resfields{iField}) - GTres2(k).(resfields{iField});
    end;
    
end;

warning('Be sure that the two GTstruct have the subjects in the same order!')




% note an alternative way is to get all values
% Res = [GTres.resfield], reshape with 3rd dimension and then average





