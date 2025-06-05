function GTdiff = GTdifference(GTstruct1, GTstruct2, opt)
    arguments
        GTstruct1 (1,:) struct
        GTstruct2 (1,:) struct {mustBeSameSize(GTstruct1, GTstruct2)}
        opt.Fields1 (1,:) string {isfield(GTstruct1, opt.InFields)} = requiredvalue
        opt.Fields2 (1,:) string {isfield(GTstruct2, opt.InFields2)} = ""
        opt.OtherFields1 (1,:) string {isfield(GTstruct1, opt.OtherFields)} = {}
        opt.OtherFields2 (1,:) string {isfield(GTstruct2, opt.OtherFields2)} = {}
    end
%% GTdifference - Computes element-wise differences between fields of two GTstructs
%
% GTdiff = GTdifference(GTstruct1, GTstruct2, 'Fields1', value, 'Fields2',
% value, 'OtherFields1', value, 'OtherFields2', value)
%
% This function computes the difference between corresponding values in two
% GTstruct arrays: GTstruct1.Fields1 - GTstruct2.Fields2. The result is a
% single GTstruct with the differences in the specified fields and any
% additional fields inherited from the original GTstructs
%
% Inputs:
%   GTstruct1 (struct): First GTstruct 
%
%   GTstruct2 (struct): Second GTstruct 
%
%   Fields1 (string, optional): Name of the fields of GTstruct1 containing
%   the values to subtract from
%
%   Fields2 (string, optional): Name of the fields of GTstruct2 containing
%   the values to subtract
%
%   OtherFields1 (string, optional): Name of the fields to be inherited
%   from GTstruct1
%
%   OtherFields2 (string, optional): Name of the fields to be inherited
%   from GTstruct2
%
% Output:
%   GTdiff (struct): GTstruct with differences in the specified fields and
%   inherited data
%
% Warning:
%   It is fundamental that the elements of the two GTstructs are in the same order.
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
%
% Version: 29/05/2025
%


Fields1 = opt.Fields1;
if strlength(opt.Fields2) == 0
    Fields2 = opt.Fields1;
else
    Fields2 = opt.Fields2;
end
if length(Fields1) ~= length(Fields2)
    error("The list of fields of the two structures must have the same length")
end
OtherFields1 = opt.OtherFields1;
OtherFields2 = opt.OtherFields2;

warning('Make sure to have the two GTstructs with the objects in the appropriate order!');

GTdiff = struct();

% copy other fields of GTstruct1
for fn = OtherFields1
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
    for iField = 1:length(Fields1);
        GTdiff(iE).(Fields1{iField}) = GTstruct1(iE).(Fields1{iField}) - GTstruct2(iE).(Fields2{iField});
    end;
    
end;






% note an alternative way is to get all values
% Res = [GTstruct.InFields], reshape with 3rd dimension and then average





