%% writeGTresEdge - Export edge-level GTstruct results in long format
% writeGTresEdge(GTstruct, 'Fields', value, 'OtherFields', value, ...
%                'NodeLabels', value, 'FileName', value)
%
% Exports edge-level metrics (e.g., edge betweenness) from GTstruct in
% long format for statistical analysis.
%
% Inputs:
%   GTstruct (struct array): Array containing GTstruct results
%
%   Fields (string array): Names of edge-level fields to export (should
%                          contain N x N matrices)
%
%   OtherFields (cell array of strings): Metadata for each subject
%
%   NodeLabels (string array): Node labels corresponding to the matrix
%
%   FileName (string): Full path to CSV output
%
% Output:
%   ResTable: Table with one row per edge per subject

function ResTable = writeGTresEdge(GTstruct, opt)
    arguments
        GTstruct (1,:) struct
        opt.Fields (1,:) string {mustBeValidVariableName}
        opt.OtherFields (1,:) string {mustBeValidVariableName} = ''
        opt.NodeLabels (1,:) string
        opt.FileName (1,1) string = "./GTstructEdgeMat"
    end

Fields = opt.Fields;
OtherFields = opt.OtherFields;
NodeLabels = opt.NodeLabels;
FileName = opt.FileName;

nSubjects = numel(GTstruct);
nNodes = numel(NodeLabels);
nEdges = nNodes*(nNodes-1)/2;  % Upper triangle only

% Preallocate containers
all_edges = struct();
all_edges.Source = cell(nSubjects*nEdges,1);
all_edges.Target = cell(nSubjects*nEdges,1);

for f = 1:numel(Fields)
    all_edges.(Fields(f)) = nan(nSubjects*nEdges,1);
end

% Metadata
for o = 1:numel(OtherFields)
    all_edges.(OtherFields(o)) = cell(nSubjects*nEdges,1);
end

row_idx = 1;

for s = 1:nSubjects
    % Upper triangle indices
    [src_idx, tgt_idx] = find(triu(ones(nNodes),1)); 

    nThisEdges = numel(src_idx);

    % Fill Source and Target (convert string -> cell)
    all_edges.Source(row_idx:row_idx+nThisEdges-1) = cellstr(NodeLabels(src_idx));
    all_edges.Target(row_idx:row_idx+nThisEdges-1) = cellstr(NodeLabels(tgt_idx));

    % Fill edge-level metrics
    for f = 1:numel(Fields)
        mat = GTstruct(s).(Fields(f));
        all_edges.(Fields(f))(row_idx:row_idx+nThisEdges-1) = mat(sub2ind([nNodes nNodes], src_idx, tgt_idx));
    end

    % Fill subject-level metadata
    for o = 1:numel(OtherFields)
        val = GTstruct(s).(OtherFields(o));
        all_edges.(OtherFields(o))(row_idx:row_idx+nThisEdges-1) = repmat({val}, nThisEdges, 1);
    end

    row_idx = row_idx + nThisEdges;
end

% Convert to table
ResTable = struct2table(all_edges);

% Export CSV
if ~isempty(FileName)
    writetable(ResTable, FileName);
    fprintf('✅ Edge-level results exported to: %s\n', FileName);
end

end
