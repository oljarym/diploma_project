function [ out_signal ] = signal_processing( signal, adc_fs, rr_duration)

% extract avareged cicle
    length_cardic_cicle = adc_fs * rr_duration;    
    n = length(signal)/length_cardic_cicle; % count of cardic_cicles     
    ave_m = vec2mat(signal, length_cardic_cicle);
    ecg_ave = sum(ave_m)./n;
    figure; plot(ecg_ave); title ('Averaged ECG'); grid on; 
%
% filtration 250-400 Hz
% Design filters
    Fs = adc_fs;  % Sampling Frequency
    N  = 2;    % Order
    Fc = 250;  % Cutoff Frequency
    % h  = fdesign.lowpass('N,F3dB', N, Fc, Fs);
    h  = fdesign.highpass('N,F3dB', N, Fc, Fs);
    Hd_lowpass = design(h, 'butter');

    N  = 4;    % Order
    Fc = 400;  % Cutoff Frequency
    h  = fdesign.lowpass('N,F3dB', N, Fc, Fs);
    Hd_highpass = design(h, 'butter');
    
    
    hpFilt = designfilt('highpassiir','FilterOrder',2, ...
         'DesignMethod','butter','HalfPowerFrequency',250, ...
         'SampleRate',Fs);
%     fvtool(hpFilt);
    lpFilt = designfilt('lowpassiir','FilterOrder',4, ...
         'DesignMethod','butter','HalfPowerFrequency',400, ...
         'SampleRate',Fs);
%     fvtool(lpFilt);
%      
% Filtration
    % ecg_ave_filtered = Hd_lowpass.filter(ecg_ave);
    % ecg_ave_filtered = filter(Hd_lowpass.sosMatrix, Hd_lowpass.ScaleValues, ecg_ave);    
    % ecg_ave_filtered = Hd_highpass.filter(ecg_ave_filtered);
    
    ecg_ave_filtered = filtfilt(hpFilt, ecg_ave);
    ecg_ave_filtered = filtfilt(lpFilt, ecg_ave_filtered);

    
        
    figure; plot(ecg_ave_filtered);title('ECG after filtration 250-400Hz'); grid on; 
    
% Module  
    module_ecg = abs(ecg_ave_filtered);
%     figure; plot(module_ecg);title('Module ECG after filtration 250-400Hz'); grid on; 
%     

    out_signal =  module_ecg;

end

