function output_signal = ecg_channel_model(input_signal, input_fs, adc_fs, adc_enob, f_low, f_high, noise)

% Emulate noise fot input 
s = input_signal + noise*rand(size(input_signal));


% Emulate analog filters
% All frequency values are in Hz.
N   = 8;       % Order
Fc1 = f_low;   % First Cutoff Frequency
Fc2 = f_high;  % Second Cutoff Frequency

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass('N,F3dB1,F3dB2', N, Fc1, Fc2, input_fs);
Hd = design(h, 'butter');
s = Hd.filter(s);

% Emulate ADC
Vref = 10; % mV
lsb = Vref/2^adc_enob;
s = floor(s/lsb)*lsb;
t_input = (0:length(s)-1)/input_fs;
output_signal = interp1(t_input, s, 0:1/adc_fs:t_input(end));


%todo filters: LP FIR  500, HP IIR 2 , bs filt 50 hz 2000

end
