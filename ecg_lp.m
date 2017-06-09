function s = ecg_lp(t, t_RR, p)

if (~exist('p'))
 p.a_P = 0.05;
 p.a_Q = -0.15;
 p.a_R = 1;
 p.a_S = -0.2;
 p.a_T = 0.15;
 p.a_U = 0.03;

 p.t_0P = 0;
 p.t_P = 0.116;
 p.t_PQ = 0.08;
 p.t_QRS = 0.07;
 p.t_ST = 0.05;
 p.t_Tr = 0.13;
 p.t_Tf = 0.15;
 
 p.t_Tr = 0.13;
 p.t_Tf = 0.15;
 
 
%  p.a_alp1 = 0.020; % 25 uV
%  p.f_alp1 = 100; % Hz
%  p.a_alp2 = 0.025; % 25 uV
%  p.f_alp2 = 60; % Hz
%  p.t_alp = 0.040; % 40 ms
%  p.t_alpj = 0.020; % 20 ms
 
 p.a_alp1 = 0; % 25 uV
 p.f_alp1 = 0; % Hz
 p.a_alp2 = 0; % 25 uV
 p.f_alp2 = 0; % Hz
 p.t_alp = 0; % 40 ms
 p.t_alpj = 0; % 20 ms
 
 
 p.a_vlp1 = 0.020; % 25 uV
 p.f_vlp1 = 183; % Hz
 p.a_vlp2 = 0.025; % 25 uV
 p.f_vlp2 = 73; % Hz
 p.t_vlp = 0.060; % 40 ms
 p.t_vlpj = 0.030; % 20 ms
end 


ta0 = p.t_0P + p.t_P;
ta1 = ta0 + p.t_alp;
taj = p.t_alpj*rand(ceil(t(end)/t_RR));
tta = mod(t/t_RR, 1)+taj(floor(t/t_RR)+1);

tv0 = p.t_0P + p.t_P + p.t_PQ + p.t_QRS;
tv1 = tv0 + p.t_vlp;
tvj = p.t_vlpj*rand(ceil(t(end)/t_RR));
ttv = mod(t/t_RR, 1)+tvj(floor(t/t_RR)+1);
s = ((tta >= ta0) & (tta <= ta1)).*...
    (p.a_alp1*sin(2*pi*p.f_alp1*tta)+...
     p.a_alp2*sin(2*pi*p.f_alp2*tta))+...
    ((ttv >= tv0) & (ttv <= tv1)).*...
    (p.a_vlp1*sin(2*pi*p.f_vlp1*ttv)+...
     p.a_vlp2*sin(2*pi*p.f_vlp2*ttv));
