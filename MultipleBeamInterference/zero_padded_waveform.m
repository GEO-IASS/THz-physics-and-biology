function [f_new wave_fft_new t_max]=zero_padded_waveform(t_max,t,wave)
%zero-pad the optimum time-domain data to get high resolution transform and better representation of single pulses.
%t_max - Total duration in time domain to increase to
%t     - vector of old timepoints
%wave  - vector of old time-domain amplitudes.
%f_new - vector of frequencies for new amplitude spectrum
%wave_fft_new - vector of new frequency spectrum amplitudes

    if t_max<max(t)
        fprintf('t_max must be greater than original waveform for zero-padding.\n')
        return
    else

        dt=mean(diff(t)); %average sampling interval in time domain
        
        t_max=round2(t_max,2); %make even for integer center index

        t_new(1:length(t),1)=t;

        %modify timepoints for zero-padded data
        max_it=1E4;
        for n=length(t)+1:max_it
            t_new(n,1)=t_new(n-1,1)+dt;
            if t_new(n,1)>t_max  && mod(length(t_new),2)==0
                break
            end
        end

        %zero-pad frequency spectrum
        wave_new=zeros(length(t_new),1);      

        center=length(t_new)./2;
        wave_new(ceil(center-length(t)./2):ceil(center+length(t)./2 - 1),1)=wave;

        %% calculate new higher resolution frequency spectrum
        NFFT=2^nextpow2(length(t_new));   %fftlength

        Fs=1/mean(diff(t_new));         %get the sampling frequency
        f_new=Fs/2*linspace(0,1,NFFT/2+1);%FFT actual information goes from DC to Nyquist Frequency

        wave_fft_new=fft(wave_new,NFFT); 

        wave_fft_new=wave_fft_new(1:NFFT/2+1); %optional for ease of plotting to keep the positive part of the FFT
    end

%% Plot figures
figure
subplot(1,2,1)
plot(t_new,wave_new,'b-','linewidth',1.1)
xlabel('Time Delay [ps]');ylabel('Electric Field [AU]')
xlim([0 t_max])
axis square

subplot(1,2,2)
semilogy(f_new,abs(wave_fft_new),'r-','linewidth',1.1)
xlabel('Frequency [THz]');ylabel('Amplitude [AU]')
axis square
