%% Initialize Gondola:
%GRAPH THEORY ANALYSIS SCRIPTS

% - start
% - restart
% - remove


function gondola(varargin);

if nargin==0
    option='start';
else
    option = varargin{1};
end;

%
% if exist('GTmeasure', 'file') & nargin==0
%     option='gondola_already_here';
% end;


% start gondola if not existing

script_name = mfilename('fullpath');
curr_script_folder = fileparts(script_name);

if (strcmp(option, 'start') |  strcmp(option, 'restart'))

    % open analysis and add path
    addpath(curr_script_folder);
    path_funcs = genpath(fullfile(curr_script_folder, 'functions'));
    addpath(path_funcs);
    
    %hFig = gcf;
    %hAx  = gca;
    %set(hFig,'menubar','none')
    % to hide the title
    %set(hFig,'NumberTitle','off');
    %Im = imread('GondolaLogo.png');
    %imshow(Im)
    %pause(3)
    %close
    
    fprintf('\n\n\n\n');
    fprintf('-\n');
    fprintf('--\n\n\n');
    
    ascii_art=['                                              &                              \n', ...
        '                                             *&&&&                             \n', ...
        '                                      *    /&&&&&                              \n', ...
        '                                     &&&&&&&&&&&&&                            \n', ...
        '                                        *&&&&&&&&&&                            \n', ...
        '                                          &&&&&&&&&                            \n', ...
        '                                           .&&&&&&             *               \n', ...
        '&&                                          &&&&&&&#          .&               \n', ...
        '&&&                                         &&&&&& .&&( &      .&              \n', ...
        '&&&(                                        #&&&&&    *&&#     &&,             \n', ...
        ' *&                                        &&&&&     ,&#&&(&&&&              \n', ...
        '&.&&                                         &&&&&   &&&&&&&&&&&               \n', ...
        '(&&&&&&                    ..*/(##&       ,/#&&&&&&&&&&&&&&&&&&&,            \n', ...
        '  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&    .&&&          \n', ...
        '  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&(         .&&&       \n', ...
        '  ,&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&.               &&&&    \n', ...
        '     .(&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#(.                         #&&&& \n'];
    
    
    fprintf(ascii_art);
    fprintf('\n\n');
    fprintf('--- Gondola toolbox now in search path ---\n');
    % fprintf('--- Requires: BCT toolbox\n');
    fprintf('--- For questions write to giorgio.arcara@gmail.com\n');
    %fprintf('--- Contributors: Gian Marco Duma, Marco Marino, Annalisa Pascarella, Giovanni Pellegrino\n');
    fprintf('--- version: 0.3. February 2021');
    fprintf('\n\n');
    
end;
if strcmp(option, 'gondola_already_here');
    
    fprintf('\n\n');
    fprintf('--- Gondola appears to be already in the search path ---\n');
    fprintf('\n\n');
    
end

if strcmp(option, 'remove');

    % remove path path
    rmpath(curr_script_folder);
    path_funcs = genpath(fullfile(curr_script_folder, 'functions'));
    rmpath(path_funcs);
    
    
    fprintf('\n\n');
    fprintf('--- Gondola removed from search path ---\n');
    fprintf('\n\n');
    
end;

end