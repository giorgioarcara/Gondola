%% GTNBSDesign(n1, n2, 'export_res', 0, 'DesignFileName', 'NBS_Design.txt', 'ContrastFileName', 'NBS_contrast.txt')
% This function create both Design Matrices AND Contrast file useful for GLM analysis
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
% Version: 12/01/2018. update: 20/05/2020


function [Design, contr] = GTNBSDesign(n1, n2, varargin)

p = inputParser;
addParameter(p, 'export_res', 0, @ischar);
addParameter(p, 'DesignFileName', 'NBS_Design.txt', @ischar);
addParameter(p, 'ContrastFileName', 'NBS_contrasts.txt', @ischar);

parse(p, varargin{:});
export_res = p.Results.export_res;
DesignFileName = p.Results.DesignFileName;
ContrastFileName = p.Results.ContrastFileName;

% FOR ANOVA DESIGN
% https://www.nitrc.org/forum/message.php?msg_id=21918

if n2 == 0;
    
    %% GENERATE DESIGN MATRIX (paired)
    n_subj = n1;
    mat = eye(n_subj);
    
    Design = [mat ; mat];
    Design(:, end+1) = [ repmat(1, n_subj, 1); repmat(-1, n_subj, 1)];
    
    
    if export_res
        fid = fopen(DesignFileName, 'w');
        for i=1:size(Design,1);%
            fprintf(fid, '%d ', Design(i,:)); % print Coord
            fprintf(fid, '\n', '');
        end;
        fclose(fid);
    end
    
    % paired t-test
    % unpaired t-test
    contr = [repmat(0, 1, n1), 1];
    
    if export_res
        fid = fopen(ContrastFileName, 'w');
        for i=1:size(contr, 1);%
            fprintf(fid, '%d ', contr(i,:)); % print Coord
            fprintf(fid, '\n', '');
        end;
        fclose(fid);
    end
    
else
    size1 = n1 + n2
    
    % initialize empty matrix
    Design = zeros(size1, 2);
    
    % matrix
    Design(1:n1, 1) = 1;
    Design(n1+1 : n1+n2, 2)=  1;
    
    
    if export_res
        fid = fopen(DesignFileName, 'w');
        for i=1:size(Design, 1);%
            fprintf(fid, '%d ', Design(i,:)); % print Coord
            fprintf(fid, '\n', '');
        end;
        fclose(fid);
    end;
    
    % unpaired t-test
    contr = [-1; 1];
    
    if export_res
        fid = fopen(ContrastFileName);
        for i=1:size(contr, 1);%
            fprintf(fid, '%d ', contr(i,:)); % print Coord
            fprintf(fid, '\n', '');
        end;
        fclose(fid);
    end
  
end;