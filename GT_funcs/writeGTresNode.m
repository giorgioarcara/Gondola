%% writeGTresNode(GTstruct, 'ResFields', {value}, 'LabFields', {value}, 'NodeLabels', {value})
%
% This function take as input several a GTres struct (as obtained by a
% BCT_analysis.m script)
% and export it in a friendly format for statistical analysis. It assumes a single value for each node.
% Data are exported in long format.
%
% INPUT:
% - GTres: a GTres object (a struct with results of GT analysis).
% - ResFields: a cell with the names of the fields that should be exported
% - NodeLabels: a cell with the NodeLabels, in the same order of ResField
% (typically from Coord Object).
% data
% - LabField: a cell with other fields to be added (typically subject name labels).
% - OutFileName = a string with the directory of the file to be saved
% Author: Giorgio Arcara
%
% version: 12/1/2018


function writeGTresNode(GTres, varargin)

p = inputParser;
addParameter(p, 'ResFields', [], @iscell);
addParameter(p, 'LabFields', [], @iscell);
addParameter(p, 'NodeLabels', [], @iscell);
addParameter(p, 'OutFileName', 'GT_Noderesults.txt', @ischar);


parse(p, varargin{:});

ResFields = p.Results.ResFields;
LabFields =  p.Results.LabFields;
NodeLabels =  p.Results.NodeLabels;
OutFileName =  p.Results.OutFileName;


%% ResField (numeric results to be exported, one per node).

res_names = fields(GTres);

res_cell=squeeze(struct2cell(GTres));

% find indices corresponding to name
[~, ind, ~] = intersect(res_names, ResFields);

restemp = res_cell(ind, :);

res = cell2mat(restemp);
res = res';

%% LabField (numeric results to be exported, one per Subject).

% find indices corresponding to name
[~, ~, ind] = intersect(LabFields ,res_names, 'stable');

lab = res_cell(ind, :);

lab = lab';


export_lab = repmat(lab, length(NodeLabels), 1);
export_nodes = repmat(NodeLabels, length(lab), 1);


%% EXPORT FILE FOR NBS
export_file=OutFileName;

fid = fopen(export_file, 'w');

sep=',';

fprintf(fid, ['%s', sep], ResFields{:});
fprintf(fid, ['%s', sep], LabFields{:});
fprintf(fid, ['%s', sep], 'NodeLabels');

fprintf(fid, '\n', '');

for i=1:size(res,1);%
    fprintf(fid, ['%d', sep], res(i,:));
    LabFields_exp = cellfun(@num2str, export_lab(i,:), 'UniformOutput', 0); % convert to str numeric fields in LabFields
    fprintf(fid, ['%s', sep], LabFields_exp{:});
    fprintf(fid, ['%s', sep], export_nodes{i});
    fprintf(fid, '\n', '');
end;
fclose(fid);



        
