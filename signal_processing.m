function [ out_signal, ecg_ave_new ] = signal_processing(signal, adc_fs, rr_duration, bad_intervals)

% extract avareged cicle
    length_cardic_cicle = adc_fs * rr_duration;
    n = round(length(signal)/length_cardic_cicle); % count of cardic_cicles    
    ave_m = vec2mat(signal, length_cardic_cicle);   
    
% %% compansation of channel filters offset 
    k = bad_intervals;
    i_R_ = find(ave_m(end-1,:) == max(ave_m(end-1,:)));
    t_R_ = i_R_ / adc_fs;
    t_R = 0.385*rr_duration; % from 0 to R-peack, todo find via rr_duration relation!!!!
    i_r_ = t_R * adc_fs;
    
    new_signal = [];
    shift = 0;    
    if t_R > t_R_        
        shift = i_r_ - i_R_;              
        new_signal = signal(k*adc_fs-shift:length(signal)-adc_fs*rr_duration-shift);
    end  
    if t_R  < t_R_
        shift = i_R_ - i_r_;  
        new_signal = signal(k*adc_fs+shift:length(signal)-adc_fs*rr_duration+shift);
    end
    if t_R == t_R_
        new_signal = signal(k*adc_fs+shift:length(signal)-adc_fs*rr_duration+shift);        
    end
    
    ave_m_new = vec2mat(new_signal, length_cardic_cicle);
    ecg_ave_new = sum(ave_m_new)./(n-k-1);
    figure, plot(ecg_ave_new); title('Channel filters shift compensated average signal'); grid on;
       
    
%     ecg_ave = sum(ave_m)./n;
%     figure; plot(ecg_ave); title ('Averaged ECG with channel filters shift'); grid on;
    
%
% filtration 250-400 Hz
% Design filters
   Fs = adc_fs;  % Sampling Frequency
%     N  = 2;    % Order
%     Fc = 250;  % Cutoff Frequency
%     % h  = fdesign.lowpass('N,F3dB', N, Fc, Fs);
%     h  = fdesign.highpass('N,F3dB', N, Fc, Fs);
% 
%     N  = 4;    % Order
%     Fc = 400;  % Cutoff Frequency
%     h  = fdesign.lowpass('N,F3dB', N, Fc, Fs);
    
    
    hpFilt = designfilt('highpassiir','FilterOrder',2, ...
         'DesignMethod','butter','HalfPowerFrequency',250, ...
         'SampleRate',Fs);
%     fvtool(hpFilt);
    lpFilt = designfilt('lowpassiir','FilterOrder',4, ...
         'DesignMethod','butter','HalfPowerFrequency',400, ...
         'SampleRate',Fs);
%     fvtool(lpFilt);     
    
    ecg_ave_filtered = filtfilt(hpFilt, ecg_ave_new);
    ecg_ave_filtered = filtfilt(lpFilt, ecg_ave_filtered);    
        
%     figure; plot(ecg_ave_filtered);title('ECG after filtration 250-400Hz'); grid on; 
    
% Module  
    module_ecg = abs(ecg_ave_filtered);
%     figure; plot(module_ecg);title('Module ECG after filtration 250-400Hz'); grid on; 
    
    out_signal =  module_ecg;

end

