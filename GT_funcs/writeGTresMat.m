%% writeGTresMat (GTstruct, 'ResMat', {value}, 'p_mats', {value}, 'LabFields', {value}, 'NodeLabels', {value}, 'OtherNodeLabels', {values}, 'OutFileName', 'value')
%
% This function take as input several a GTres struct (as obtained by a
% BCT_analysis.m script)
% and export it in a friendly format for statistical analysis. It assumes a single value for each node.
% Data are exported in long format.
%
% INPUT:
% - GTres: a GTres object (a struct with results of GT analysis).
% - ResFields: a cell with the names of the fields that should be exported
% - NodeLabels: a cell with the NodeLabels, in the same order of ResField (typically from Coord Object).
% - OtherNodeLabels: a cell containing other cells with other Labels ot be
%                   associated with Nodes. E.g., if you have 3 additional
%                   variables for the k nodes. the OtherNode Labels should
%                   have this structure and size {{k}, {k}, {k})
% - LabField: a cell with other fields to be added (typically subject name labels).
% - OutFileName = a string with the directory of the file to be saved
% Author: Giorgio Arcara
%
% version: 30/05/2021


function ResTable = writeGTresMat(GTres, varargin)


p = inputParser;
addParameter(p, 'ResMat', [], @iscell);
addParameter(p, 'p_mats', [], @iscell); %% optional
addParameter(p, 'LabFields', [], @iscell);
addParameter(p, 'NodeLabels', [], @iscell);
addParameter(p, 'OtherNodeLabels', [], @iscell);
addParameter(p, 'OutFileName', [], @ischar);

parse(p, varargin{:});

ResMat = p.Results.ResMat;
p_mats = p.Results.p_mats;
LabFields =  p.Results.LabFields;
NodeLabels =  p.Results.NodeLabels;
OtherNodeLabels =  p.Results.OtherNodeLabels;
OutFileName =  p.Results.OutFileName;

%%

%% ResField (numeric results to be exported, one per node).

res_names = fields(GTres);

res_cell=squeeze(struct2cell(GTres));

% find indices corresponding to name
[~, ~, ind] = intersect(ResFields, res_names, 'stable');

restemp = res_cell(ind, :);

res = cell2mat(restemp);
res = res';

%% LabField (numeric results to be exported, one per Subject).

% find indices corresponding to name
[~, ~, ind] = intersect( LabFields, res_names,'stable');

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

for iF = 1:length(LabFields)
    ResTable.(LabFields{iF}) = export_lab(:,iF);
end;
for iRF = 1:length(ResFields)
    ResTable.(ResFields{iRF}) = res(:, iRF);
end;




if ~isempty(OutFileName)
    %% EXPORT FILE 
    fid = fopen(OutFileName, 'w');
    
    sep=',';
    
    fprintf(fid, ['%s', sep], ResFields{:});
    fprintf(fid, ['%s', sep], LabFields{:});
    fprintf(fid, ['%s', sep], 'NodeLabels');
    
    for iN = 1:length(OtherNodeLabels)
            fprintf(fid, ['%s', sep], ['NodeLabels', num2str(iN)]);
    end
    
    fprintf(fid, '\n', '');
    
    for i=1:size(res,1);%
        fprintf(fid, ['%d', sep], res(i,:));
        LabFields_exp = cellfun(@num2str, export_lab(i,:), 'UniformOutput', 0); % convert to str numeric fields in LabFields
        fprintf(fid, ['%s', sep], LabFields_exp{:});
        fprintf(fid, ['%s', sep], export_nodes{i});
        for iN = 1:length(OtherNodeLabels)
               fprintf(fid, ['%s', sep], other_vars{i, iN});
        end;   
        fprintf(fid, '\n', '');
    end;
    fclose(fid);
end

end




