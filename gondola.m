%% Initialize Gondola:
%GRAPH THEORY ANALYSIS SCRIPTS



function gondola(varargin);

if nargin==0
    option='start';
else
  option = varargin{1};
end;


%
if exist('gondola', 'file') & nargin==0
    option='gondola_already_here';
end;



% start gondola if not existing

if (strcmp(option, 'start') |  strcmp(option, 'restart'))
    
    script_name = mfilename('fullpath');
    curr_script_folder = fileparts(script_name);
    
    
    % open analysis and add path
    addpath(genpath([curr_script_folder]));
    
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
    fprintf('--- by: Giorgio Arcara, Gian Marco Duma, Marco Marino, Annalisa Pascarella, Giovanni Pellegrino\n');
    fprintf('--- version: 0.2');
    fprintf('\n\n\n\n');
    
elseif 'gondola_already_here'
    
    fprintf('\n\n');
    fprintf('--- Gondola appears to be already in the search path ---\n');
    fprintf('\n\n');
    
end

end