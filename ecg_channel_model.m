function output_signal = ecg_channel_model(input_signal, input_fs, adc_fs, adc_enob, f_low, f_high, noize)

% Emulate noise fot input 
s = input_signal + noize*rand(size(input_signal));


% Emulate analog filters
% All frequency values are in Hz.
N_a   = 8;       % Order
Fc1_a = f_low;   % First Cutoff Frequency
Fc2_a = f_high;  % Second Cutoff Frequency

% Analog Band pass filter
h  = fdesign.bandpass('N,F3dB1,F3dB2', N_a, Fc1_a, Fc2_a, input_fs);
Hd = design(h, 'butter');
s = Hd.filter(s);

% START Emulate ADC 
Vref = 10; % mV
% lsb = Vref/2^adc_enob;
adc_nbits = 23;
lsb = Vref/2^adc_nbits;

SINAD = adc_enob*6.02 + 1.8;

noise_a = Vref/sqrt(SINAD);
s = floor(s/lsb)*lsb;
t_input = (0:length(s)-1)/input_fs;
t_output = 0:1/adc_fs:t_input(end);
output_signal = interp1(t_input, s, t_output) + noise_a * rand(size(t_output));
% ADC END


% %  %% Modelling digital filter
N_lp    = 500;      % Order
Fc_lp   = 150;      % Cutoff Frequency
flag = 'scale';  % Sampling Flag
% Create the window vector for the design algorithm.
win = blackmanharris(N_lp+1);
% Calculate the coefficients using the FIR1 function.
b  = fir1(N_lp, Fc_lp/(input_fs/2), 'low', win, flag);
Hd_pl = dfilt.dffir(b);

% % % digital filtration LP filter Fc = 150 Hz
output_signal = Hd_pl.filter(output_signal);

% Digital HP filter 0.05 Hz modelliing
N_hp  = 2;     % Order
Fc_hp = 0.05;  % Cutoff Frequency
% Construct an FDESIGN object and call its BUTTER method.
h_hp  = fdesign.highpass('N,F3dB', N_hp, Fc_hp, adc_fs);
Hd_hp = design(h_hp, 'butter');

% digital filtration HP filter Fc = 0.05 Hz
 output_signal = Hd_hp.filter(output_signal);

% % digital BS filter 50 Hz
Fpass1 = 49.5;            % First Passband Frequency
Fstop1 = 49.9;            % First Stopband Frequency
Fstop2 = 51.1;            % Second Stopband Frequency
Fpass2 = 55.05;           % Second Passband Frequency
Dpass1 = 0.028774368332;  % First Passband Ripple
Dstop  = 0.001;           % Stopband Attenuation
Dpass2 = 0.057501127785;  % Second Passband Ripple
flag   = 'scale';         % Sampling Flag

[N,Wn,BETA,TYPE] = kaiserord([Fpass1 Fstop1 Fstop2 Fpass2]/(adc_fs/2), [1 ...
                             0 1], [Dpass1 Dstop Dpass2]);
b_bs  = fir1(N, Wn, TYPE, kaiser(N+1, BETA), flag);
Hd_bs = dfilt.dffir(b_bs);

% digital filtration BS filter Fc = 50 Hz
 output_signal = Hd_bs.filter(output_signal);

end
