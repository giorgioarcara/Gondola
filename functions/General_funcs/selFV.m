%% sel_FV(Struct, Field, incflFV)
%
% This is a utility functions to select a subset of a struct, based on a
% field value.
%
% INPUT: 
% 
% -  Struct: a matlab struct
% - Field : char with the name of the field of the matlab struct
% - incFV: which values should be included
%
% Example:
%
% newS = selFV(myStruct, 'name', {'Giorgio', 'Giovanni'});
%
%
% Author: Giorgio Arcara
%
% Version: 12/01/2018
%



function selStruct = selFV(Struct, Field, inclFV)

all_values = eval(['{Struct.', Field, '}']);

selIndices = find( strcmpi(all_values, inclFV) );

selStruct=Struct(selIndices);

