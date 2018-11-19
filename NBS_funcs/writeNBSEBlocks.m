%% writeNBSDesign(n1, n2)
% This function write a .txt file with NBS ExchangeBlock.
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


function [EB] =  writeNBSEBlocks(n1, outdir);

if ~exist('outdir')
    outdir='';
end;

n_subj = n1;

EB = [1:n1, 1:n1]';


%% EXPORT FILE FOR NBS
export_file=[outdir 'NBS_ExchangeBlocks.txt'];

fid = fopen(export_file, 'w');
for i=1:size(EB,1);%
    fprintf(fid, '%d ', EB(i,:)); % print only Coordinates
    fprintf(fid, '\n', '');
end;
fclose(fid);


EB=EB;

fprintf('Warning: The Exchange blocks are necessary only in repeated measures Design\n')


