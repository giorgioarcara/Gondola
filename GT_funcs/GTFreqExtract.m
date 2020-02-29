%% GTFreqExtract(GTstruct, conn_mat_field, Freq_dim);
%
% This function select can be used to extract a single frequency from a
% multidimensional matrix with more than one frequency.
% !!!!! TEMPORARY FUNCTION !!!!! 
%
% INPUT: 
%
% - GTres: a struct, resulting from BCT script analysis
% - conn_mat: the name of the field with the data
% - Freq_dim: the dimension specifying the matrix (from Brainstorm export)

function GTres = GTFreqExtract(GTstruct, conn_mat_field, Freq_dim)
 
% initialize results
GTres = GTstruct;

% loop over all objects in GTstruct and compute the measure.
for iK = 1:length(GTstruct)
    temp = GTstruct(iK).(conn_mat_field);
    GTres(iK).(conn_mat_field) = squeeze(temp(:,:,Freq_dim));
    
    
end;




  

