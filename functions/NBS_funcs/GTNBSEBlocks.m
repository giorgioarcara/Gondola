%% writeNBSDesign(n1, n2)
% This function create an NBS ExchangeBlock and (optional) create a file
% with it.
% This is a file specifying how to perform permutation in the case of
% within measure Designs. Currently only a very simple version is provided.
% which ASSUMES that the files are sorted in the following way.
% a1, a2, a3, a4, ..., an, b1, b2, b2, b3, b4, bn.
% where a1 indicates condition 'a' of subject '1' and so on.
% and b1 indicates condition 'b' of subjects 1'.
%
% INPUT:
% - n1, number of subjects.
%
% OUTPUT
% - EB an object with the exchange blocks
%
% Author: Giorgio Arcara
%
% Version: 12/01/2018


function [EB] =  GTNBSEBlocks(n1, varargin);

p = inputParser;
addParameter(p, 'OutFileName', [], @ischar);

parse(p, varargin{:});
OutFileName = p.Results.OutFileName;

n_subj = n1;

EB = [1:n1, 1:n1]';


%% EXPORT FILE FOR NBS
if ~isempty(OutFileName)

fid = fopen(OutFileName, 'w');
for i=1:size(EB,1);%
    fprintf(fid, '%d ', EB(i,:)); % print only Coordinates
    fprintf(fid, '\n', '');
end;
fclose(fid);

end;

fprintf('Warning: The Exchange blocks are necessary only in repeated measures Design\n')


