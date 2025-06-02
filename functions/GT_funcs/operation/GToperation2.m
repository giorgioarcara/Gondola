function GTstruct = GToperation2(GTstruct1, GTstruct2, opt)
    arguments
        GTstruct1 (1, 1) struct
        GTstruct2 (1, :) struct
        opt.Fields (1, :) cell
        opt.OtherFields (1, :) cell
        opt.NewField (1, 1) cell
        opt.Operation (1, 1) string
    end
    



%% GToperation2 - Performs a custom operation between two GTstructs
% 
% GTstruct = GToperation2(GTstruct1, GTstruct2, 'Fields',value,'OtherFields', value, 'NewField', value, 'Operation', 'value')
%
% This function takes as input two GTstructs and performs a specified operation
% between the matching fields of the two structs. The operation 
% must be a valid MATLAB expression, expressed as a string (e.g., "GTres = GT1 - GT2").
%
% Inputs:
%   GTstruct1 (struct): The first GTstruct
%   
%   GTstruct2 (struct): The second GTstruct
%
%   Fields (cell, optional): Cell array of fields to use to perform the
%   operation from both the GTstructs
%
%   OtherFields (cell, optional): Cell array of the field names to inherit
%   from the original GTstructs
%
%   NewField (cell, optional): Name of the output field where the results
%   will be stored
%
%   Operation (string, optional): A string with a MATLAB expression to be
%   applied (e.g., 'GTres = GT1 - GT2')
%
% Output:
%   GTstruct (struct): A struct array containing 
%   the result of the evaluated operation in the specified NewField
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
%
% Version: 29/05/2025



function GTstruct = GToperation2(GTstruct1, GTstruct2, varargin)

p = inputParser;
addParameter(p, 'InFields', [], @iscell);
addParameter(p, 'OtherFields', [], @iscell);
addParameter(p, 'OutFields', [], @iscell);
addParameter(p, 'operation', 'GTres=GT1-GT2', @ischar);
parse(p, varargin{:});


Fields = p.Results.InFields;
OtherFields =  p.Results.OtherFields;
NewField = p.Results.OutFields;
Operation = p.Results.operation;

GTstruct = struct();

if (exist('OtherFields')&~isempty('OtherFields'))
    % first copy all the other fields
    for fn = OtherFields
        for isubj = 1:length(GTstruct1);
            GTstruct(isubj).(fn{1}) = GTstruct1(isubj).(fn{1});
        end
    end
end

if isempty(NewField)
    NewField = Fields;
    fprintf(['\n\n- GT Warning: the original InFields were replaced by results of the operation.\n'] );
end;


% now load the data
for k=1:length(GTstruct1);
    for iField = 1:length(Fields);
        GT1 = GTstruct1(k).(Fields{iField}) ;
        GT2 = GTstruct2(k).(Fields{iField});
        eval([Operation,';'])
        GTstruct(k).(NewField{iField}) = GTres;
    end;
    
end;
fprintf(['- Operation performed: ', Operation, '\n'] );
warning('Make sure that the two GTstructs have the objects in the correct order!')




% note an alternative way is to get all values
% Res = [GTstruct.InFields], reshape with 3rd dimension and then average





