%% writeNBSDesign(n1, n2)
% This function write .txt files with NBS Design Matrices AND Contrast file.
% Currently, it only write the Matrices and Contrasts for t-tests.
%
% INPUT:
% - n1, number of subjects of first group. If only one is specified. It is
% assumed a paired design
% - n2, number of subjects in the second group. FOR PAIRED Design. set n2 =
% 0.
%
% Author: Giorgio Arcara
%
% Version: 12/01/2018

function [Design, contr] = writeNBSDesign(n1, n2, outdir)

if ~exist('outdir')
    outdir=''
end;

% FOR ANOVA DESIGN
% https://www.nitrc.org/forum/message.php?msg_id=21918

if n2 == 0;
    
    %% GENERATE DESIGN MATRIX (paired)
    n_subj = n1;
    mat = eye(n_subj);
    
    Design = [mat ; mat];
    Design(:, end+1) = [ repmat(1, n_subj, 1); repmat(-1, n_subj, 1)];
    
    
    export_name=[outdir, 'NBS_Design.txt'];
    
    fid = fopen(export_name, 'w');
    for i=1:size(Design,1);%
        fprintf(fid, '%d ', Design(i,:)); % print Coord
        fprintf(fid, '\n', '');
    end;
    fclose(fid);
    
    % paired t-test
    % unpaired t-test
    contr = [repmat(0, 1, n1), 1];
    
    
    export_name=[outdir, 'NBS_Contrast.txt'];
    
    fid = fopen(export_name, 'w');
    
    for i=1:size(contr, 1);%
        fprintf(fid, '%d ', contr(i,:)); % print Coord
        fprintf(fid, '\n', '');
    end;
    fclose(fid);
    
    
else
    size1 = n1 + n2
    
    % initialize empty matrix
    mat = zeros(size1, 2);
    
    % matrix
    mat(1:n1, 1) = 1;
    mat(n1+1 : n1+n2, 2)=  1;
    
    
    export_name=[outdir, 'NBS_Design.txt'];
    
    fid = fopen(export_name, 'w');
    for i=1:size(mat, 1);%
        fprintf(fid, '%d ', mat(i,:)); % print Coord
        fprintf(fid, '\n', '');
    end;
    fclose(fid);
    
    % unpaired t-test
    contr = [-1; 1];
    
    
    export_name=[outdir, 'NBS_Contrast.txt'];
    
    fid = fopen(export_name);
    
    
    for i=1:size(contr, 1);%
        fprintf(fid, '%d ', contr(i,:)); % print Coord
        fprintf(fid, '\n', '');
    end;
    fclose(fid);
    
    
    
    
    
end;