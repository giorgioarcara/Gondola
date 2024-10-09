%% Compress(TF)
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
%% ===== COMPRESS SYMMETRIC MATRIX =====
function TF = Compress(TF)
    % Get number of elements
    N = sqrt(size(TF,1));
    % Check if matrix is already compressed
    if (N ~= round(N))
        return;
    end
    % Generate all the indices
    [iA,iB] = meshgrid(1:N,1:N);
    % Find the values below the diagonal
    indAll = find(iB <= iA);
    % Keep only those values
    TF = TF(indAll,:,:);
end

