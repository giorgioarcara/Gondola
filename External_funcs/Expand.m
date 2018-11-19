%% Expand(TF)
% @=============================================================================
% This function is part of the Brainstorm software:
% http://neuroimage.usc.edu/brainstorm
% 
% Copyright (c)2000-2018 University of Southern California & McGill University
% This software is distributed under the terms of the GNU General Public License
% as published by the Free Software Foundation. Further details on the GPLv3
% license can be found at http://www.gnu.org/copyleft/gpl.html.
% 
% FOR RESEARCH PURPOSES ONLY. THE SOFTWARE IS PROVIDED "AS IS," AND THE
% UNIVERSITY OF SOUTHERN CALIFORNIA AND ITS COLLABORATORS DO NOT MAKE ANY
% WARRANTY, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
% MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, NOR DO THEY ASSUME ANY
% LIABILITY OR RESPONSIBILITY FOR THE USE OF THIS SOFTWARE.
%
% For more information type "brainstorm license" at command prompt.
% =============================================================================@
%
% Authors: Francois Tadel, 2013-2014
%% ===== EXPAND SYMMETRIC MATRIX =====
function fullTF = Expand(TF, N, isConjugate)
    if (nargin < 3) || isempty(isConjugate)
        isConjugate = 0;
    end
    % Check if matrix is already compressed
    if (size(TF,1) == N^2)
        fullTF = TF;
        return;
    end
    % Generate all the indices
    [iAall,iBall] = meshgrid(1:N,1:N);
    % Find the values below/above the diagonal
    [iA,iB] = find(iBall <= iAall);
    % Build two sets of indices
    indAll1 = sub2ind([N,N], iA(:), iB(:));
    indAll2 = sub2ind([N,N], iB(:), iA(:));
    % Rebuild full matrix
    fullTF = zeros(N*N, size(TF,2), size(TF,3));
    fullTF(indAll1,:,:) = TF;
    if isConjugate
        fullTF(indAll2,:,:) = conj(TF);
    else
        fullTF(indAll2,:,:) = TF;
    end
end

