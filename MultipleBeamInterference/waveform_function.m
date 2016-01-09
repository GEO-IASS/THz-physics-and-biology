function [t wave f wave_fft]=waveform_function(file)

%file - a string with file.txt file containing data from LabView program in THz lab. First
%column of *.txt file is delay time and second column is amplitude data


%load data
data=dlmread(file);
t=data(:,1);
wave=data(:,2);

%% calculate frequency spectrum
NFFT=2^nextpow2(length(t));   %fftlength

Fs=1/mean(diff(t));         %get the sampling frequency
f=Fs/2*linspace(0,1,NFFT/2+1);%FFT actual information goes from DC to Nyquist Frequency

wave_fft=fft(wave,NFFT); 

wave_fft=wave_fft(1:NFFT/2+1); %optional for ease of plotting to keep the positive part of the FFT
