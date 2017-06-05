close all
clear

%parameters of signal model
fs = 15000; % Hz
duration = 110;
hr = 60; % heart rate, bpm
t = (0:1/fs:duration); % s
noize_e = 0.001;% electrode polarization
isoline_a = 0.2;
genetate_model_spectr = false;

% fs adc	enob
% 500	14.2
% 1000	13.86
% 2000	13.5
% 4000	13.2
% 8000	12.4
% 16000	10.8
% 32000	8.9

% parameters of ecg chanel------------------------------
adc_fs = 4000; % Hz
t_a_ch = (0:1/adc_fs:duration);
adc_enob = 13.2;
f_low = 0.05; % Hz
f_high = 450; % Hz
noize = 0.08;
plot_fft_after_channel = false;
% ------------------------------------------------------
% ECG with LP
[ecg_lp_s] = generate_ecg_lp_signal(t,fs, hr, noize_e, isoline_a, genetate_model_spectr);
figure, plot(t, ecg_lp_s); xlabel('t, s'); ylabel('Voltage, mV'); 
title('ECG signal with ventricular lp and artifacts');grid on;

% channel adc, filtration
ecg_after_chanel = ecg_channel_model(ecg_lp_s, fs, adc_fs, adc_enob,f_low,f_high, noize, plot_fft_after_channel);
% figure, plot(t_a_ch, ecg_after_chanel); title('ECG signal after input chanel');
% xlabel('t, s');ylabel('Amplitude, mV'); grid on;
%-------------------------------------------------------
%%% signal processing
rr_duration = 1;
bad_intervals = 10; % compensation of zero shift (digital filters)
[out_s, ecg_ave] = signal_processing(ecg_after_chanel, adc_fs, rr_duration, bad_intervals);

step = 1/adc_fs;
t_out = 0:1/adc_fs:1-step;
figure, plot(t_out, out_s); title('Module ECG after filtration 250-400Hz'); grid on;hold on;
% 
% area(ti(lp_duration_samples), out_signal(lp_duration_samples), 'FaceColor', 'r','EdgeColor','r');

% % % time-frequency domain analis
sig4fft = fft(ecg_ave);

f = (0:length(sig4fft)-1)*adc_fs/length(sig4fft);
f = f(1:end/2);
sig4fft = sig4fft(1:end/2);
        
figure,
plot(f,abs(sig4fft)); xlim([0, 500]);
title('Specterum of avarege ECG with LP after input chanel');
xlabel('f, Hz'); ylabel('Amplitude');

relation = 




