%% NBSfiles2struct(InputFiles, Design, Contrast)
% this function start from NBS files (.txt) and generate the nbst object to
% perform all the analysis.
%
% Author


%% IMPORTANT data, in nbs struct are stored in a compressed format in which only upper diag nonzeros values are taken
% so if you start from a 50 x 50 x 60 3d matrices
% you end up to a 60 x 1225 matrix , where 1225 are the nonredundang point
% in the symmetric 50 x 50 original matrix. 
Data = nonzeros(triu(Data_mat(:,:,1), 1));

%


