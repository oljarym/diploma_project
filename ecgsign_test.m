close all
clear

fs = 10000; % Hz

% % % fs> 10 kHz : 50 kHz

hr = 60; % heart rate, bpm
t = (0:1/fs:10)'; % s
ecg = ecgsign(t, 60/hr);


ecg_lp_s = 0.1*ecg_lp(t, 60/hr);

figure;
ax1 = subplot(2,1,1);
plot(t, ecg);
xlabel('t, s');
ylabel('ECG, mV');
grid on;
ax2 = subplot(2,1,2);
plot(t, ecg + ecg_lp_s);

ecg_lp_final = ecg + ecg_lp_s;

xlabel('t, s');
ylabel('ECG + LP, mV');
grid on;
linkaxes([ax1 ax2],'x');

lp_f = fft(ecg_lp_s);
f = (0:length(lp_f)-1)*fs/length(lp_f);
f = f(1:end/2);
lp_f = lp_f(1:end/2);
figure; plot(f,abs(lp_f)); xlim([0, 500]);
