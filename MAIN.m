close all
clear

% enobs = [13.86, 13.5, 13.2, 12.4, 10.8, 8.9];
enobs = [16, 15.8, 15.5, 14.3, 13.5, 11];

adc_FS = [1000, 2000, 4000, 8000, 16000, 32000];
LAS40_res = [0, 0, 0, 0, 0, 0];
RMS40_res = [0, 0, 0, 0, 0, 0];
QRSD_res = [0, 0, 0, 0, 0, 0];

for i = 1:4
%parameters of signal model
if i < 4
  fs = 20000;
end
if i == 5
  fs = 32000;
end
if i == 6  
  fs = 64000; % Hz
end

% some comsole logs
disp('iteration =');
disp(i)

duration = 200;
hr = 60; % heart rate, bpm
t = (0:1/fs:duration); % s
noize_e = 0;% electrode polarization, mV 300 mV
isoline_a = 0;
genetate_model_spectr = false;
normal_ecg = false;



% parameters of ecg chanel------------------------------
% adc_fs = 1000; % Hz
adc_fs = adc_FS(i);
t_a_ch = (0:1/adc_fs:duration);
% adc_enob = 13.2; 
adc_enob = 11;
f_low = 0.05; % Hz
f_high = 450; % Hz
noize = 0.008; %mV
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


qrs_level = max(max(out_s(1:0.2*adc_fs)), max(out_s(0.55*adc_fs:end)));
level = qrs_level*1e6;

qrs_level_line = ones(length(t_out), 1)*level*1e-6;
qrs_first = find(out_s*1e6>level, 1, 'first');% first point of detected QRS
qrs_last = find(out_s*1e6>level, 1, 'last');% first point of detected QRS

qrs_first_line = zeros(length(t_out), 1);
qrs_first_line(qrs_first) = max(out_s)/2;
qrs_last_line = zeros(length(t_out), 1);
qrs_last_line(qrs_last) = max(out_s)/2;
qrsd_bounds = qrs_first_line + qrs_last_line;

QRSD = t_out(qrs_last)-t_out(qrs_first);
disp('QRSD =');
disp(QRSD);
QRSD_res(i) = QRSD;


las4_i = qrs_last-0.04*adc_fs:qrs_last; % last 40 us interval for this QRS
RMS40 = rms(out_s(las4_i));
disp('RMS40 = ');
disp(RMS40);
RMS40_res(i) = RMS40;

sig_las40 = out_s(las4_i);
las40_i = find(sig_las40*1e6<40, 1, 'last');
LAS40 = t_out(qrs_last)-t_out(las40_i+qrs_first);
disp('LAS40 =');
disp(LAS40);
LAS40_res(i) = LAS40;

level_40 = ones(length(t_out), 1)*40*1e-6;

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
end
disp('THE END');


