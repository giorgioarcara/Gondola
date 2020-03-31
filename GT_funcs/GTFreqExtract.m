%% GTFreqExtract(GTstruct,'ConnMatField', value,'FreqDim', value);
%
% This function select can be used to extract a single frequency from a
% multidimensional matrix with more than one frequency.
% !!!!! TEMPORARY FUNCTION !!!!! 
%
% INPUT: 
%
% - GTstruct: a struct, resulting from BCT script analysis
% - ConnMatField: the name of the field with the data
% - FreqDim: the dimension specifying the matrix (from Brainstorm export)

function GTstruct = GTFreqExtract(GTstruct, varargin)
% part to check if, in a given group
p = inputParser;
addParameter(p, 'ConnMatField', [], @ischar);
addParameter(p, 'FreqDim', [], @isnumeric);

parse(p, varargin{:});

ConnMatField = p.Results.ConnMatField;
FreqDim =  p.Results.FreqDim;
 
% initialize results
%GTres = GTstruct;

% loop over all objects in GTstruct and compute the measure.
for iK = 1:length(GTstruct)
    temp = GTstruct(iK).(ConnMatField);
    GTstruct(iK).(ConnMatField) = squeeze(temp(:,:,FreqDim));
    
    
end;




  

