%% writeGTresNode - Export node-level GTstruct data in long format
% writeGTresNode(GTstruct, 'Fields', value, 'OtherFields', value, ...
%                'NodeLabels', value, 'OtherNodeLabels', value, ...
%                'FileName', value)
%
% This function takes as input a GTstruct array (typically obtained from 
% a BCT analysis script) and exports node-level results in long format 
% for statistical analysis. It assumes one value per node per field.
%
% Inputs:
%   GTstruct (struct array): A struct array containing the results of GT
%   analysis. 
%
%   Fields (string array, optional): Names of the GTstruct fields to extract
%   node-level metrics from. 
%
%   OtherFields (string array, optional): Names of additional fields (e.g. subject
%   IDs) to include in the output. 
%
%   NodeLabels (string array, optional): Node labels in the same order as
%   the values in each result field. 
%
%   OtherNodeLabels (string array, optional): Additional labels for each
%   node, provided as a cell array of cell arrays, each of length equal to
%   the number of nodes
%
%   FileName (string, optional): Name (and optionally path) of the file to
%   be saved. Default_: './GTstructMat'
%
% Ouput:
%   ResTable: A MATLAB table in long format with one row oer nod and
%   columns for each requested field and label. 
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
% Version: 20/05/2025


function ResTable = writeGTresNode(GTstruct, opt)
arguments
    GTstruct (1,:) struct
    opt.Fields (1,:) string {mustBeValidVariableName}
    opt.OtherFields (1,:) string {mustBeValidVariableName}
    opt.NodeLabels (1,:) string
    opt.OtherNodeLabels (1,:) string = {} %empty by default
    opt.FileName (1,1) string = "./GTstructMat"
end


Fields = opt.Fields;
OtherFields =  opt.OtherFields;
NodeLabels =  opt.NodeLabels;
OtherNodeLabels =  opt.OtherNodeLabels;
FileName =  opt.FileName;

%%
% Extract info
nSubjects = numel(GTstruct);
nFields = numel(Fields);
nNodes = numel(NodeLabels);

% Pre allocate the results
res = nan(nSubjects * nNodes, nFields);
export_lab = cell(nSubjects * nNodes, numel(OtherFields));

row_idx = 1;

for s = 1:nSubjects
    thisGT = GTstruct(s);

    % Extract numeric fields
    for f = 1:nFields
        fieldname = Fields(f);
        if isfield(thisGT, fieldname)
            values = thisGT.(fieldname);

            if iscell(values)
                values = cell2mat(values);
            end

            if numel(values) ~= nNodes
                error("GTstruct(%d).%s has %d elements, expected %d.", ...
                    s, fieldname, numel(values), nNodes);
            end

            res(row_idx:row_idx+nNodes-1, f) = values(:);
        else
            error("Field %s not found in GTstruct.", fieldname)
        end
    end

    % Extract subject-level metadata
    for o = 1:numel(OtherFields)
        val = thisGT.(OtherFields(o));
        export_lab(row_idx:row_idx+nNodes-1, o) = repmat({val}, nNodes, 1);
    end

    row_idx = row_idx + nNodes;
end

export_nodes = repmat(NodeLabels(:), nSubjects, 1);

%% Handle optional node-level labels

other_vars = {};

if ~isempty(OtherNodeLabels)
    other_vars = cell(length(export_nodes), length(OtherNodeLabels));
    for iN = 1:length(OtherNodeLabels)
        if length(OtherNodeLabels{iN}) ~= length(NodeLabels)
            error('GT: the number of elements in each subcell of OtherNodeLabels must match that of NodeLabels.');
        end
        other_vars(:,iN) = repmat(OtherNodeLabels{iN}, nSubjects, 1);
    end
end

%% Create output table
ResTable = table();
ResTable.NodeLabels = export_nodes(:);

for iN = 1:length(OtherNodeLabels)
    ResTable.(['NodeLab', num2str(iN)]) = other_vars(:, iN);
end

for iF = 1:length(OtherFields)
    ResTable.(OtherFields{iF}) = export_lab(:, iF);
end

for iRF = 1:length(Fields)
    ResTable.(Fields{iRF}) = res(:, iRF);
end

%% Export csv file

if ~isempty(FileName)
    writetable(ResTable, FileName);
    fprintf('✅ Results successfully exported to: %s\n', FileName);
end
end





