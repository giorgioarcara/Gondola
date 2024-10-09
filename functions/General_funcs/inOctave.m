%% inoctave()
% check if you are in octave

function [inOctave] = in_octave()
try
    OCTAVE_VERSION;
    inOctave = 1;
catch
    inOctave = 0;
end