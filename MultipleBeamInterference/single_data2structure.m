function [t wave f wave_fft]=single_data2structure(file)

%'file' is the string of the filename.

[t.(sprintf('%s',file)) wave.(sprintf('%s',file)) ... 
    f.(sprintf('%s',file)) wave_fft.(sprintf('%s',file))]= ... 
    waveform_function(sprintf('%s',file));
