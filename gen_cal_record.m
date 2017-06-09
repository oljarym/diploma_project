function [record] = gen_cal_record(p_raw, hr, t, show_figure)

% close all;
% clear all;

% % CAL05000 
% p_raw = [
% %  I    II   V1   V2   V3   V4   V5   V6
% % Global intervals
%   178  178  178  178  178  178  178  178 % P-R interval
%   394  394  394  394  394  394  394  394 % Q-T interval
% % P measuments
%   116  116  116  116  116  116  116  116 % P1 duration
%   150  150  150  150  150  150  150  150 % P1 amplitude
%     0    0    0    0    0    0    0    0 % P2 duration
%     0    0    0    0    0    0    0    0 % P2 amplitude
% % QRS measuments/conf
%     0    0    0    0    0    0    0    0 % Q duration
%     0    0    0    0    0    0    0    0 % Q amplitude
%    50   50   50   50   50   50   50   50 % R duration
%   500  500  500  500  500  500  500  500 % R amplitude
%    50   50   50   50   50   50   50   50 % S duration
%  -500 -500 -500 -500 -500 -500 -500 -500 % S amplitude
%   100  100  100  100  100  100  100  100 % QRS duration
% % ST-T measuments, J-point = QRS-end
%     0    0    0    0    0    0    0    0 % J amplitude
%     0    0    0    0    0    0    0    0 % ST 20 amplitude
%     0    0    0    0    0    0    0    0 % ST 40 amplitude
%     0    0    0    0    0    0    0    0 % ST 60 amplitude
%     0    0    0    0    0    0    0    0 % ST 80 amplitude
%   100  100  100  100  100  100  100  100 % T amplitude  
% ];
% 
% 
% % CAL05000 
% p_raw = [
% %  I    II   V1   V2   V3   V4   V5   V6
% % Global intervals
%   178  178  178  178  178  178  178  178 % P-R interval
%   394  394  394  394  394  394  394  394 % Q-T interval
% % P measuments
%   116  116  116  116  116  116  116  116 % P1 duration
%   150  150  150  150  150  150  150  150 % P1 amplitude
%     0    0    0    0    0    0    0    0 % P2 duration
%     0    0    0    0    0    0    0    0 % P2 amplitude
% % QRS measuments/conf
%     0    0    0    0    0    0    0    0 % Q duration
%     0    0    0    0    0    0    0    0 % Q amplitude
%    50   50   50   50   50   50   50   50 % R duration
%   500  500  500  500  500  500  500  500 % R amplitude
%    50   50   50   50   50   50   50   50 % S duration
%  -500 -500 -500 -500 -500 -500 -500 -500 % S amplitude
%   100  100  100  100  100  100  100  100 % QRS duration
% % ST-T measuments, J-point = QRS-end
%     0    0    0    0    0    0    0   50 % J amplitude
%     0    0    0    0    0    0    0   50 % ST 20 amplitude
%     0    0    0    0    0    0    0   50 % ST 40 amplitude
%     0    0    0    0    0    0    0   50 % ST 60 amplitude
%     0    0    0    0    0    0    0   50 % ST 80 amplitude
%   100  100  100  100  100  100  100  100 % T amplitude  
% ];

p = [];
for i = 1:size(p_raw,2)
  p(i).PRinterval = p_raw(1,i);
  p(i).QTinterval = p_raw(2,i);
  p(i).P1dur = p_raw(3,i);
  p(i).P1ampl = p_raw(4,i);
  p(i).P2dur = p_raw(5,i);
  p(i).P2ampl = p_raw(6,i);
  p(i).Qdur = p_raw(7,i);
  p(i).Qampl = p_raw(8,i);
  p(i).Rdur = p_raw(9,i);
  p(i).Rampl = p_raw(10,i);
  p(i).Sdur = p_raw(11,i);
  p(i).Sampl = p_raw(12,i);
  p(i).QRSdur = p_raw(13,i);
  p(i).Jampl = p_raw(14,i);
  p(i).ST20ampl = p_raw(15,i);
  p(i).ST40ampl = p_raw(16,i);
  p(i).ST60ampl = p_raw(17,i);
  p(i).ST80ampl = p_raw(18,i);
  p(i).Tampl = p_raw(19,i);
end

if (show_figure)
  hf = figure;
  ha = [];
end

labels = {'I', 'II', 'V1', 'V2', 'V3', 'V4', 'V5', 'V6'};
% hr = 60;
% t = 0:10000; % ms
data = zeros(length(t),size(p_raw,2));
for i = 1:size(p_raw,2)
  [t0,a0] = ecg_ref_points(p(i), 60000/hr);
%  y = interp1(t0,a0,mod(t,60000/hr),'pchip');
  y = interp1(t0,a0,mod(t,60000/hr));
  data(:,i) = y;
  
  if (show_figure)
      if size(p_raw,2) == 1
          ha(i) = subplot(1, 1, 1);
          
      else
          ha(i) = subplot(size(p_raw,2)/2,2,i);  
      end
    plot(t0,a0,'.',t,y);
    xlabel('t, ms');
    ylabel([labels{i} ', uV']);
    grid on;
  end  
end
if (show_figure)
  linkaxes(ha,'x');
end

record = data;

function [t,a] = interp_part_sin(t0,a0,i0,k)
dt = (t0(i0+2)-t0(i0))/2;
tt = (t0(i0):dt/k:t0(i0+2));
x = (tt-t0(i0))/dt/2;
% aa = (a0(i0+1)-(a0(i0+2)+a0(i0))/2)*sin(pi*x)+a0(i0)+(a0(i0+2)-a0(i0))*x;

p5 = (a0(i0+2)-a0(i0))/(1-2/pi);
p4 = (a0(i0+2)+a0(i0)-p5)/2;
p2 = pi;
p1 = sqrt((p5/pi)^2+(a0(i0+1)-p4-0.5*p5)^2);
p3 = atan(-p5/pi/(a0(i0+1)-p4-0.5*p5));
if (a0(i0+1) < 0)
  p1 = -p1;
end  
aa = p1*sin(p2*x-p3)+p4+p5*x;

t = [t0(1:i0-1) tt t0(i0+3:end)];
a = [a0(1:i0-1) aa a0(i0+3:end)];

function [t,a] = interp_flat_peak(t0,a0,i0,d)
t = [t0(1:i0-1) t0(i0)-d/2 t0(i0) t0(i0)+d/2 t0(i0+1:end)];
a = [a0(1:i0-1)     a0(i0) a0(i0)     a0(i0) a0(i0+1:end)];


function [t0,a0] = ecg_ref_points(p, RRinterval)
t0 = []; a0 = [];
% t0(1) = 0;                                   a0(1) = 0;
% t0(2) = t0(1) + p.P1dur/2;                   a0(2) = p.P1ampl;
% t0(3) = t0(1) + p.P1dur;                     a0(3) = 0;
% t0(4) = t0(1) + p.PRinterval;                a0(4) = 0;
% t0(5) = t0(4) + p.Rdur/2;                    a0(5) = p.Rampl;
% t0(6) = t0(4) + p.Rdur;                      a0(6) = 0;
% t0(7) = t0(4) + p.QRSdur-p.Sdur/2;           a0(7) = p.Sampl;
% t0(8) = t0(4) + p.QRSdur;                    a0(8) = p.Jampl;
% t0(9) = t0(8) + 20;                          a0(9) = p.ST20ampl;
% t0(10) = t0(8) + 40;                         a0(10) = p.ST40ampl;
% t0(11) = t0(8) + 60;                         a0(11) = p.ST60ampl;
% t0(12) = t0(8) + 80;                         a0(12) = p.ST80ampl;
% t0(13) = t0(8) + 100;                        a0(13) = p.ST80ampl;
% t0(14) = (t0(13) + t0(4) + p.QTinterval)/2;  a0(14) = p.Tampl;
% t0(15) = t0(4) + p.QTinterval;               a0(15) = 0;
% t0(16) = t0(1) + RRinterval;                 a0(16) = 0;

i_p_start = 1;
t0(1) = 0;                                               a0(1) = 0;
t0(end+1) = t0(i_p_start) + p.P1dur/2;                   a0(end+1) = p.P1ampl;
t0(end+1) = t0(i_p_start) + p.P1dur;                     a0(end+1) = 0;
i_p1_end = length(t0);
if (p.P2dur > 0)
  t0(end+1) = t0(i_p1_end) + p.P2dur/2;               a0(end+1) = p.P2ampl;
  t0(end+1) = t0(i_p1_end) + p.P2dur;                 a0(end+1) = 0;    
end
t0(end+1) = t0(i_p_start) + p.PRinterval;                a0(end+1) = 0;
i_qrs_start = length(t0);
if (p.Qdur > 0)
  t0(end+1) = t0(i_qrs_start) + p.Qdur/2;                a0(end+1) = p.Qampl;
  i_q = length(t0);
  if ((p.Rdur > 0) || (p.Sdur > 0))
    t0(end+1) = t0(i_qrs_start) + p.Qdur;                a0(end+1) = 0;
  end  
end  
if (p.Rdur > 0)
  t0(end+1) = t0(end) + p.Rdur/2;                        a0(end+1) = p.Rampl;
  i_r = length(t0);
  if (p.Sdur > 0)
    t0(end+1) = t0(i_r) + p.Rdur/2;                      a0(end+1) = 0;
  end  
end  
if (p.Sdur > 0)
  t0(end+1) = t0(i_qrs_start) + p.QRSdur-p.Sdur/2;       a0(end+1) = p.Sampl;
  i_s = length(t0);
end  
t0(end+1) = t0(i_qrs_start) + p.QRSdur;                  a0(end+1) = p.Jampl;
i_j = length(t0);
t0(end+1) = t0(i_j) + 20;                                a0(end+1) = p.ST20ampl;
t0(end+1) = t0(i_j) + 40;                                a0(end+1) = p.ST40ampl;
t0(end+1) = t0(i_j) + 60;                                a0(end+1) = p.ST60ampl;
t0(end+1) = t0(i_j) + 80;                                a0(end+1) = p.ST80ampl;
t0(end+1) = t0(i_j) + 100;                               a0(end+1) = p.ST80ampl;
i_j100 = length(t0);
t0(end+1) = (t0(i_j100) + t0(i_qrs_start) + p.QTinterval)/2;  a0(end+1) = p.Tampl;
t0(end+1) = t0(i_qrs_start) + p.QTinterval;              a0(end+1) = 0;
t0(end+1) = t0(1) + RRinterval;                          a0(end+1) = 0;

k_interp_sin = 10;

[t0,a0] = interp_part_sin(t0,a0,i_j100,k_interp_sin); % T sin interp
if (p.Sdur > 0)
  [t0,a0] = interp_flat_peak(t0,a0,i_s,4); % S peak to 4 ms
end
if (p.Rdur > 0)
  [t0,a0] = interp_flat_peak(t0,a0,i_r,4); % R peak to 4 ms
end  
if (p.Qdur > 0)
  [t0,a0] = interp_flat_peak(t0,a0,i_q,4); % Q peak to 4 ms
end  
if (p.P2dur > 0)
  [t0,a0] = interp_part_sin(t0,a0,i_p1_end,k_interp_sin); % P2 sin interp
end  
[t0,a0] = interp_part_sin(t0,a0,i_p_start,k_interp_sin); % P1 sin interp
