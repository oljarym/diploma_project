close all
clear

% QRS from 31 ms to 0.46 ms when hr = 1
enobs = [13.86, 13.5, 13.2, 12.4, 10.8, 8.9];
adc_FS = [1000, 2000, 4000, 8000, 16000, 32000];


fs = 10000;
duration = 200;
hr = 60; % heart rate, bpm
t = (0:1/fs:duration); % s
noize_e = 30;% electrode polarization, mV 300 mV
isoline_a = 0;
genetate_model_spectr = false;
normal_ecg = false;

% fs adc	enob + ... 2-3b
% 1000	13.86
% 2000	13.5
% 4000	13.2
% 8000	12.4
% 16000	10.8
% 32000	8.9

% parameters of ecg chanel------------------------------
% adc_fs = 1000; % Hz
adc_fs = 1000;
t_a_ch = (0:1/adc_fs:duration);
% adc_enob = 13.2; 
adc_enob = 13.86;
f_low = 0.05; % Hz
f_high = 450; % Hz
noize = 30; %mV
plot_fft_after_channel = false;
% ----------------------RUN-------------------------------
% ECG with LP
[ecg_lp_s] = generate_ecg_lp_signal(t,fs, hr, noize_e, isoline_a, genetate_model_spectr, normal_ecg);
% figure, plot(t, ecg_lp_s); xlabel('t, s'); ylabel('Voltage, mV'); 
% title('ECG signal with ventricular lp and artifacts');grid on;

disp('ecg signal is generated. Next - channel');


% channel adc, filtration
ecg_after_chanel = ecg_channel_model(ecg_lp_s, fs, adc_fs, adc_enob,f_low,f_high, noize, plot_fft_after_channel);
% figure, plot(t_a_ch, ecg_after_chanel); title('ECG signal after input chanel');
% xlabel('t, s');ylabel('Amplitude, mV'); grid on;
%-------------------------------------------------------
%%% signal processing
rr_duration = 1;
bad_intervals = 40; % compensation of zero shift (digital filters)

disp('SIGNAL PROCESSING');

[out_s, ecg_ave] = signal_processing(ecg_after_chanel, adc_fs, rr_duration, bad_intervals);

out_s(1:30)=zeros(length(out_s(1:30)), 1);
step = 1/adc_fs;
t_out = 0:1/adc_fs:1-step;

%  helpness par

% level = max(out_s(1:0.2*adc_fs));

qrs_level = max(max(out_s(1:0.3*adc_fs)), max(out_s(0.50*adc_fs:end)));
level = qrs_level*1e6;
% qrs_level = level*1e-6*30;
qrs_level_line = ones(length(t_out), 1)*level*1e-6;
qrs_first = find(out_s*1e6>level, 1, 'first');% first point of detected QRS
qrs_last = find(out_s*1e6>level, 1, 'last');% first point of detected QRS

qrs_first_line = zeros(length(t_out), 1);
qrs_first_line(qrs_first) = max(out_s)/1.5;
qrs_last_line = zeros(length(t_out), 1);
qrs_last_line(qrs_last) = max(out_s)/1.5;
qrsd_bounds = qrs_first_line + qrs_last_line;

QRSD = t_out(qrs_last)-t_out(qrs_first);
disp('QRSD =');
disp(QRSD);

las4_i = qrs_last-0.04*adc_fs:qrs_last; % last 40 us interval for this QRS
RMS40 = rms(out_s(las4_i));
disp('RMS40 = ');
disp(RMS40);

sig_las40 = out_s(las4_i);

interval_for_las40 = 0.42*adc_fs+1:qrs_last;

sig_last = zeros(length(out_s), 1);

l = out_s(0.42*adc_fs+1);
M = ones(length(out_s(1:0.42*adc_fs)), 1);
part = l* ones(length(out_s(1:0.42*adc_fs)), 1);

sig_last(1:0.42*adc_fs) = part;
sig_last(0.42*adc_fs:qrs_last)= out_s(0.42*adc_fs:qrs_last);

% figure, plot(t_out, sig_last);


% sig_last(interval_for_las40) = out_s(interval_for_las40);
las40_i = find(sig_last*1e3>40, 1, 'last'); %'last'



las40_line = zeros(length(t_out), 1);
iii = las40_i(end);
las40_line(iii) = max(out_s)/1.5;
qrsd_bounds  = qrsd_bounds + las40_line;


LAS40 = t_out(qrs_last)-t_out(iii);
disp('LAS40 =');
disp(LAS40);

level_40 = ones(length(t_out), 1)*40*1e-3;

figure, 
h1 = subplot(2, 1, 1);
plot(t_out, out_s, t_out, level_40, ['k' ':'], t_out,  qrsd_bounds,'k'); title('Module ECG after filtration 250-400Hz'); grid on;hold on;
area(t_out(las4_i), sig_las40, 'FaceColor', 'r','EdgeColor','r'); hold on;


h2 = subplot(2, 1, 2); plot(t_out, ecg_ave); title('Average ECG'); grid on;
linkaxes([h1 h2],'x');

% RMS40 = rms(sig_las40);

% *adc_fs - qrs_last_i)/adc_fs;



% % % time-frequency domain analis'
sig4fft = fft(ecg_ave);

f = (0:length(sig4fft)-1)*adc_fs/length(sig4fft);
f = f(1:end/2);
sig4fft = sig4fft(1:end/2);
i_f = round(40/adc_fs*2*length(sig4fft));

% figure,
% plot(f,abs(sig4fft)); xlim([0, 500]);
% title('Specterum of avarege ECG with LP after input chanel');
% xlabel('f, Hz'); ylabel('Amplitude');hold on; grid on;
% area(f(i_f:end), abs(sig4fft(i_f:end)), 'EdgeColor','r');
% 
% relation = rms(abs(sig4fft(i_f:end)))/rms(abs(sig4fft(1:i_f-1)));
% 
% result_2 = relation^2; %   1.4037e-05

disp('THE END');

