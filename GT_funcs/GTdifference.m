%% GTdifference(GTstruct1, GTstruct2, 'ResField',value,'OtherFields', value)
%
% This function takes as input a GTstruct object (object with results from an analysis
% with a script like BCT_analysis.m) and compute the average of the
% matrices in a field.
%
% INPUT
% - GTstruct1: the first GTstruct struct with the results
% - GTstruct2: the second GTstruct struct with the results
% - ResField: the name of the fields that will be subtracted between(GTstruct1 -
% GTstruct2)between {} brackets
% - OtherFields: the other fields to be kept between {} brackets
%
% IMPORTANTE: The function will perform GTstruct1.resfield - GTstruct2.resfield
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
addParameter(p, 'ResField', [], @iscell);
addParameter(p, 'OtherFields', [], @iscell);

parse(p, varargin{:});

ResField = p.Results.ResField;
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
for k=1:length(GTstruct1);
    for iField = 1:length(ResField);
        GTdiff(k).(ResField{iField}) = GTstruct1(k).(ResField{iField}) - GTstruct2(k).(ResField{iField});
    end;
    
end;

warning('Be sure that the two GTstruct have the subjects in the same order!')




% note an alternative way is to get all values
% Res = [GTstruct.ResField], reshape with 3rd dimension and then average





