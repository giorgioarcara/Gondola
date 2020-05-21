%% p_mat_adjust(pmat_unc, 'Method', 'pdep', 'AlphaCrit', 0.05)

% return a matrix after correcting for multiple comparison. NaN are excluded.
%
%   - pmat_unc: the matrix with uncorrected p-value. can be a diagonal
%   matrix
%   - 'Method': the method for correcting p-value. Default, 'pdep' is for
%              'fdr' correction. See help(fdr_bh) for further information.
%   - 'AlphaCrit': the alpha value

function p_mat_adj = p_mat_adjust(p_mat_unc, varargin)


p = inputParser;
addParameter(p, 'Method', 'pdep', @ischar);
addParameter(p, 'AlphaCrit', 0.05, @isnumeric);

parse(p, varargin{:});

Method =  p.Results.Method;
AlphaCrit =  p.Results.AlphaCrit;


% create matrix with uncorrected p values.
[~, ~, ~, adj_p] = fdr_bh(p_mat_unc(~isnan(p_mat_unc)), AlphaCrit, Method);

p_mat_adj = nan(size(p_mat_unc));
p_mat_adj(~isnan(p_mat_unc)) = adj_p;


