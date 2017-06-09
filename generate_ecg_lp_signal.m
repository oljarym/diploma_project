function [ final_ecg] = generate_ecg_lp_signal(t, fs, hr, noize_e, isoline, plot_fft, is_normal_ecg)
% modelingof common-mode signal
f_50 = 50;
A = 0.1;
sine_wave =A*cos(2*pi*f_50*t);
% modelling of isoline
f_i = 0.04; % Hz
isoline_wave = isoline*cos(2*pi*f_i*t);

% modeling of ECG sign with lp
% ecg = ecgsign(t, 60/hr);


p_raw = [
%  I    II   V1   V2   V3   V4   V5   V6
% Global intervals
  178   % P-R interval
  394   % Q-T interval
% P measuments
  116   % P1 duration
  80   % P1 amplitude
    0   % P2 duration
    0   % P2 amplitude
% QRS measuments/conf
   20   % Q duration
  -175   % Q amplitude
   50    % R duration
  750   % R amplitude
   50   % S duration
 -230  % S amplitude
  100   % QRS duration
% ST-T measuments, J-point = QRS-end
    0    % J amplitude
    0    % ST 20 amplitude
    0     % ST 40 amplitude
    0    % ST 60 amplitude
    0    % ST 80 amplitude
  150  % T amplitude  
];


ecg = gen_cal_record(p_raw, hr, t*1e3, false)';

ecg_lp_sig = 120*ecg_lp(t, 60/hr);
if is_normal_ecg
    ecg_lp_sig = 0*ecg_lp_sig;
end
final_ecg = ecg + ecg_lp_sig + noize_e*rand(size(ecg_lp_sig)) + sine_wave + isoline_wave;

if plot_fft
    
    ecg_lp_f = fft(final_ecg);
    f = (0:length(ecg_lp_f)-1)*fs/length(ecg_lp_f);
    f = f(1:end/2);
    ecg_lp_f = ecg_lp_f(1:end/2);

    figure,
    plot(f,abs(ecg_lp_f)); xlim([0, 500]);
    title('Specterum of ECG with LP before input chanel');
    xlabel('f, Hz'); ylabel('Amplitude'); grid on;

    % % LP specrtum
    lp_f = fft(ecg_lp_sig);
    f = (0:length(lp_f)-1)*fs/length(lp_f);
    f = f(1:end/2);
    lp_f = lp_f(1:end/2);

    figure, 
    plot(f,abs(lp_f)); xlim([0, 500]);
    title('LP specterum before input chanel');
    xlabel('f, Hz'); ylabel('Amplitude'); grid on;     
end


end

