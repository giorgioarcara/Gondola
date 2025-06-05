%% writeGTresMat - Export node-level GTstruct results in long format
% writeGTresMat(GTstruct, 'Fields', value, 'NodeLabels', value, ...
%               'OtherNodeLabels', value, 'FileName', value)
%
% This function takes as input a GTstruct array (typically obtained from 
% `BCT_analysis.m`) and exports node-level results in long format for 
% statistical analysis. Each value corresponds to a node-specific metric.
%
% Inputs:
%   GTstruct (struct array): A struct array containing the output of GT
%   analysis
%   
%   Fields (string array, optional): Names of the node-level fields to be
%   extracted from the GTstruct.
%
%   NodeLabels (string array, optional): Labels associated with each node,
%   in the same order as the values in the result fields. 
%   
%   OtherNodeLabels (string array, optional): Additional labels for each node, used to provide metadata such as 
%   anatomical region or hemisphere. These should be structured as a 
%   cell array of cell arrays (e.g., {{labels1}, {labels2}, ...}), 
%   each of length equal to the number of nodes.
%
%   FileName (string, optional): Full path or name for the output file.
%   Default: './GTstrutMat'
%
% Output:
%   ResTable: A MATLAB table in long format, where each row corresponds to
%   one node for one subject, with associated matrics and labels. 
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
% Version: 20/05/2025


function ResTable = writeGTresMat(GTstruct, opt)
    arguments
        GTstruct (1,:) struct
        opt.Fields (1,:) string {mustBeValidVariableName}
        opt.NodeLabels (1,:) string
        opt.OtherNodeLabels (1,:) string
        opt.FileName (1,1) string = "./GTstructMat"
        opt.ResMat %% unused
        opt.p_mats %% unused
    end


Fields =  opt.Fields;
NodeLabels =  opt.NodeLabels;
OtherNodeLabels =  opt.OtherNodeLabels;
FileName =  opt.FileName;
ResMat = opt.ResMat;
p_mats = opt.p_mats;

%%

%% ResField (numeric results to be exported, one per node).

res_names = fields(GTstruct);

res_cell=squeeze(struct2cell(GTstruct));

% find indices corresponding to name
[~, ~, ind] = intersect(ResFields, res_names, 'stable');

restemp = res_cell(ind, :);

res = cell2mat(restemp);
res = res';

%% LabField (numeric results to be exported, one per Subject).

% find indices corresponding to name
[~, ~, ind] = intersect( Fields, res_names,'stable');

lab = res_cell(ind, :);

lab = lab';

%% GF START
% bug solved, export_lab was arranged in conditions x nodes, whereas
% export_nodes in nodes x conditions
%export_lab = repmat(lab, length(NodeLabels), 1); % OLD CALL
export_lab = []; % NEW CALL
conditions = size(lab); conditions = conditions(1);
for index = 1 : conditions
    export_lab = [export_lab; repmat(lab(index,:), length(NodeLabels), 1)];
end
%% GF END

export_nodes = repmat(NodeLabels, length(lab), 1);

other_vars = cell(length(lab)*length(NodeLabels), length(OtherNodeLabels));
for iN=1:length(OtherNodeLabels)
    if length(OtherNodeLabels{iN})~=length(NodeLabels)
        error('GT: the number of element in each subcell of OtherNodeLabels must match that of NodeLabels\n');
    end
    other_vars(:,iN) = repmat(OtherNodeLabels{iN}, length(lab), 1);
end;

% create table
ResTable = table( );
ResTable.NodeLabels = export_nodes(:);
for iN = 1:length(OtherNodeLabels)
    ResTable.(['NodeLab', num2str(iN)]) = other_vars(:,iN);
end

for iF = 1:length(Fields)
    ResTable.(Fields{iF}) = export_lab(:,iF);
end;
for iRF = 1:length(ResFields)
    ResTable.(ResFields{iRF}) = res(:, iRF);
end;




if ~isempty(FileName)
    %% EXPORT FILE 
    fid = fopen(FileName, 'w');
    
    sep=',';
    
    fprintf(fid, ['%s', sep], ResFields{:});
    fprintf(fid, ['%s', sep], Fields{:});
    fprintf(fid, ['%s', sep], 'NodeLabels');
    
    for iN = 1:length(OtherNodeLabels)
            fprintf(fid, ['%s', sep], ['NodeLabels', num2str(iN)]);
    end
    
    fprintf(fid, '\n', '');
    
    for i=1:size(res,1);%
        fprintf(fid, ['%d', sep], res(i,:));
        Fields_exp = cellfun(@num2str, export_lab(i,:), 'UniformOutput', 0); % convert to str numeric fields in Fields
        fprintf(fid, ['%s', sep], Fields_exp{:});
        fprintf(fid, ['%s', sep], export_nodes{i});
        for iN = 1:length(OtherNodeLabels)
               fprintf(fid, ['%s', sep], other_vars{i, iN});
        end;   
        fprintf(fid, '\n', '');
    end;
    fclose(fid);
end

end




