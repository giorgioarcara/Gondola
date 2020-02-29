% GTprogressbarcurr_Iter, iterations, vargin)
% this function show an update (on the prompt) on processes
%
% INPUT
% - curr_Iter: the current iterations (e.g., the i in a loop for i=1:100)
% - iteations: the total number (e.g., the 100 in for i=1:100
% - update_steps_perc: in percentage: when to show an update on the prompt
%
% Author: Giorgio Arcara
%
% version: 4/03/2018

function GTprogressbar(curr_Iter, iterations, varargin)

if nargin < 3
    update_steps_perc = [10:10:100];
elseif nargin==3
    update_steps_perc = varargin{1};
end

update_moments = round(update_steps_perc*iterations/100);

% check if the current iterations is in the expected update steps.
[~,  ~, update_ind] = intersect(curr_Iter, update_moments);

if ~isempty( update_ind )
    fprintf([num2str(update_steps_perc(update_ind)), '%%\n']);
end;

end

