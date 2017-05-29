close all
clear

fs = 10000; % Hz

hr = 60; % heart rate, bpm
t = (0:1/fs:10)'; % s
ecg = ecgsign(t, 60/hr);
ecg_lp = 0.1*ecg_lp(t, 60/hr);

figure;
ax1 = subplot(2,1,1);
plot(t, ecg);
xlabel('t, s');
ylabel('ECG, mV');
grid on;
ax2 = subplot(2,1,2);
plot(t, ecg + ecg_lp);

xlabel('t, s');
ylabel('ECG + LP, mV');
grid on;
linkaxes([ax1 ax2],'x');
