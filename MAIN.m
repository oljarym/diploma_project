close all
clear

%parameters of signal model
fs = 20000; % Hz
duration = 40;
hr = 60; % heart rate, bpm
t = (0:1/fs:duration); % s

% electrode polarization
noize_e = 0.012;

% parameters of ecg chanel
adc_fs = 1000; % Hz
adc_enob = 20;
f_low = 0.05; % Hz
f_high = 450; % Hz
noize = 0.01;

% modeling 50 Hz wave
f_50 = 50;
A = 0.1;
sine_wave =A*sin(2*pi*f_50*t);


% modeling of ECG sign with lp
ecg = ecgsign(t, 60/hr);
ecg_lp_sig = 0.1*ecg_lp(t, 60/hr);
ecg_lp_s = ecg + ecg_lp_sig + noize_e*rand(size(ecg_lp_sig)) + sine_wave;


figure; title('ECG signal with ventricular lp')
plot(t, ecg_lp_s); xlabel('t, s'); ylabel('Voltage, mV'); grid on;

% % % spectrm of ECG with LP
ecg_lp_f = fft(ecg_lp_s);
f = (0:length(ecg_lp_f)-1)*fs/length(ecg_lp_f);
f = f(1:end/2);
ecg_lp_f = ecg_lp_f(1:end/2);

figure,
plot(f,abs(ecg_lp_f)); xlim([0, 500]);
title('Specterum of ECG with LP before input chanel');
xlabel('f, Hz'); ylabel('Amplitude');

% % LP specrtum
lp_f = fft(ecg_lp_sig);
f = (0:length(lp_f)-1)*fs/length(lp_f);
f = f(1:end/2);
lp_f = lp_f(1:end/2);

figure, 
plot(f,abs(lp_f)); xlim([0, 500]);
title('LP specterum before input chanel');
xlabel('f, Hz'); ylabel('Amplitude');

t_a_ch = (0:1/adc_fs:duration);
ecg_after_chanel = ecg_channel_model(ecg_lp_s, fs, adc_fs, adc_enob,f_low,f_high, noize);

figure, plot(t_a_ch, ecg_after_chanel); title('ECG signal after input chanel');
xlabel('t, s');ylabel('Amplitude, mV'); grid on;


ecg_lp_fch = fft(ecg_after_chanel);
f = (0:length(ecg_lp_fch)-1)*fs/length(ecg_lp_fch);
f = f(1:end/2);
ecg_lp_fch = ecg_lp_fch(1:end/2);

figure,
plot(f,abs(ecg_lp_fch)); xlim([0, 500]);
title('Specterum of ECG with LP after input chanel');
xlabel('f, Hz'); ylabel('Amplitude');


%%% signal processing
% 1) Spectrum analis


 







