clear
close all
% parameters
adc_fs = 1000; % Hz
adc_enob = 20;

f_low = 0.05; % Hz
f_high = 450; % Hz
noise = 0.01;
n = 100;
rr_duration = 1; % sec 0.66
pqrs_duration = 0.27; % sec
pqrs_duration_40 = 0.23;% sec

[ecg, fs] = ecg_lp_generator;

% t2 = 0:1/adc_fs:rr_duration-1/adc_fs; % unused 

out = ecg_channel_model(ecg, fs, adc_fs, adc_enob, f_low, f_high, noise);

figure;
plot(ecg);grid on; xlabel('Time, ms');ylabel('Amplitude, V')


% 
% % [ out_signal ] = signal_processing(out, adc_fs, rr_duration);
% % 
% % step = rr_duration/length(out_signal);
% % ti = 0 : step : rr_duration-step;
% % 
% % % cut 
% % out_signal(1:50)= out_signal(51:100);
% % 
% % figure; subplot(2, 1, 1); plot(ecg(1:25000));title('Model ECG');
% % subplot(2, 1, 2); plot(out_signal(1:adc_fs));title('ECG filtered');
% % 
% % t1 = 0:1/length(ecg_one):0.66;
% % 
% % figure; subplot(2, 1, 1); plot( ecg(1:2500));title('Model ECG');
% % subplot(2, 1, 2); plot(ti, out_signal);title('ECG 40-250');
% 
% 
% result = [20 1000 0; 18 2000 0; 16 4000 0; 14 6000 0; 12 8000 0; 10 10000 0];
% for i = 1:length(result(:,1));
%     
%  adc_fs = result(i, 2); % Hz
%  adc_enob = result(i, 1);
%  
% [ecg, fs] = ecg_lp_generator;
% out = ecg_channel_model(ecg, fs, adc_fs, adc_enob, f_low, f_high, noise);
% 
% % figure; plot(out);grid on; title('ECG from tract');
% 
% [ out_signal ] = signal_processing(out, adc_fs, rr_duration);
% 
% % figure; plot(out_signal); 
% 
% step = rr_duration/length(out_signal);
% 
% begin_p = int16(length(out_signal)*pqrs_duration_40/rr_duration);
% end_p = int16(length(out_signal)*pqrs_duration/rr_duration);%520 ??? 2000 ?? ???
% 
% ti = 0 : step : rr_duration-step;
% lp_duration_samples = begin_p:end_p;
% 
% % cut 
% out_signal(1:50)= out_signal(51:100);
% % ddd = out_signal(71:140);
% 
% % figure;
% % plot(ti, out_signal);
% % hold on;grid on;
% % 
% % area(ti(lp_duration_samples), out_signal(lp_duration_samples), 'FaceColor', 'r','EdgeColor','r');
% 
% result(i, 3) = rms(out_signal(lp_duration_samples));
%  end


