function [ final_ecg] = generate_ecg_lp_signal(t, fs, hr, noize_e, isoline, plot_fft)
% modelingof common-mode signal
f_50 = 50;
A = 0.1;
sine_wave =A*cos(2*pi*f_50*t);
% modelling of isoline
f_i = 0.04; % Hz
isoline_wave = isoline*cos(2*pi*f_i*t);

% modeling of ECG sign with lp
ecg = ecgsign(t, 60/hr);
ecg_lp_sig = 0.1*ecg_lp(t, 60/hr);
final_ecg = ecg + ecg_lp_sig + noize_e*rand(size(ecg_lp_sig)) + sine_wave + isoline_wave;

ecg_lp_f = fft(final_ecg);
f = (0:length(ecg_lp_f)-1)*fs/length(ecg_lp_f);
f = f(1:end/2);
ecg_lp_f = ecg_lp_f(1:end/2);

if plot_fft
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

