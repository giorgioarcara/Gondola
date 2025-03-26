function y = requiredvalue()
%% requiredvalue()
% Utility validation function for required name-value arguments
% Code from https://www.reddit.com/r/matlab/comments/1i3ivhy/comment/m7q7pyd/

y = [];
try
    error("arg missing error")
catch err
    varname = getVarName(err.stack(2).file, err.stack(2).line);
    msg = sprintf('required argument %s missing while calling the function %s', varname, err.stack(2).name);
    err2 = MException(err.identifier, msg);
    err2.throw;
end
end

function varname = getVarName(fname, lineNum, opts)
arguments
    fname {mustBeText, mustBeFile}
    lineNum (1,1) {mustBeInteger, mustBePositive}
    opts.verbose (1,1) logical = false
end
try
    % Validate file exists and has .m extension
    [~, ~, ext] = fileparts(fname);
    assert(strcmp(ext, '.m'), 'Input file must be a MATLAB .m file');
    assert(isfile(fname), 'File does not exist');


    % Read all lines from file
    fid = fopen(fname, 'r');
    cleanupObj = onCleanup(@() fclose(fid));  % Ensure file is closed even if error occurs

    % Read all lines into cell array
    allLines = textscan(fid, '%s', 'Delimiter', '\n', 'WhiteSpace', '');
    allLines = allLines{1};

    % Convert to string array
    allLines = string(allLines);

    % Check if requested line exists
    if lineNum > numel(allLines)
        if opts.verbose
            fprintf('Requested line %d exceeds file length of %d lines\n', ...
                lineNum, numel(allLines));
        end
        varname = '';
        return;
    end

    % Return requested line
    outLine = allLines(lineNum);

    if opts.verbose
        fprintf('Retrieved line: %s\n', outLine);
    end

    varname = sprintf('"%s"', regexp(outLine, '(\w+)\s','tokens','once'));
catch err
    varname = '';
end
end