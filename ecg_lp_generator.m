function [ ecg,  fs] = ecg_lp_generator

   % load ECG data from file
    fileName = 'Ms.mat';
    ms = load(fileName);
    Ms = struct2array(ms);
    Sa = sum(Ms)./353;
                               
    
    sample_per_points = 2.51;
    RR_time = 0.66; 
    step = 1 / sample_per_points;
    
 %%%  change time scale
    ti = 1:step:660;
    fd = length(ti) / RR_time; 
    ecg = interp1(1:1660, Sa, ti);     
     
  %%%  generate ECG signal with LP
    Msign_p = zeros(2, 1655);
    Msign_p(1, :) = Sa(1:1655);
    Msign_p(2, :) = ti;
    
    a = 7;
    b = 6.5;
    c = 6;
    d = 5.5;
    e = 5;
    f = 4.5;

%     a = 14;
%     b = 13;
%     c = 5;
%     d = 7;
%     e = 9;
%     f = 8;

x = 0.0155;
    for i = 610:5:625
         Msign_p(1,i-5) = Msign_p(1,i-5)-Msign_p(1, i-5)/a-x; 
         Msign_p(1,i-4) = Msign_p(1,i-4)-Msign_p(1,i-4)/b-x;
         Msign_p(1,i-3) = Msign_p(1,i-3)- Msign_p(1,i-3)/c-x;
         Msign_p(1,i-2) = Msign_p(1,i-2)- Msign_p(1,i-2)/d-x;
         Msign_p(1,i-1) = Msign_p(1,i-1)- Msign_p(1,i-1)/e-x;
         Msign_p(1,i) = Msign_p(1,i)- Msign_p(1,i)/f-x;
         Msign_p(1,i+5) = Msign_p(1,i+5)-Msign_p(1, i+5)/a-x; 
         Msign_p(1,i+4) = Msign_p(1,i+4)-Msign_p(1,i+4)/b-x;
         Msign_p(1,i+3) = Msign_p(1,i+3)- Msign_p(1,i+3)/c-x;
         Msign_p(1,i+2) = Msign_p(1,i+2)- Msign_p(1,i+2)/d-x;
         Msign_p(1,i+1) = Msign_p(1,i+1)- Msign_p(1,i+1)/e-x;
    end


    ecg = interp1(Msign_p(2, :), Msign_p(1, :), ti, 'spline');
    ecg_one = ecg;
    
%%%    change signal fs 
    ts = 1:step/50:660;    
    fs = length(ts) / RR_time; 
    ecg = interp1(Msign_p(2, :), ecg,  ts, 'spline');  
    
   figure; plot(ts, ecg); grid on; title('Model ecg');xlabel('time, ms'); ylabel('Amplitude, mV'); 


    %%%create n cardiac cycle 
    %n = 100;
    %ts = 1:step/10:660*n;  

  fs = 25000; % Hz
 
% hr = 60; % heart rate, bpm
% t = (0:1/fs:10)'; % s
% ecg = ecgsign(t, 60/hr);
% ecg_lp_1 = 0.1*ecg_lp(t, 60/hr);
% ecg = ecg + ecg_lp_1;

     ecg = [ecg ecg ecg ecg ecg ecg ecg ecg ecg ecg];
%      ecg = [ecg ecg ecg ecg ecg ecg ecg ecg ecg ecg];    
  
end

