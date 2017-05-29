function [s] = ecgsign(t, t_RR, p);

if (~exist('p'))
 p.a_P = 0.05;
 p.a_Q = -0.15;
 p.a_R = 1;
 p.a_S = -0.2;
 p.a_T = 0.15;
 p.a_U = 0.03;

 p.t_0P = 0.1;
 p.t_P = 0.08;
 p.t_PQ = 0.13;
 p.t_QRS = 0.15;
 p.t_ST = 0.05;
 p.t_Tr = 0.13;
 p.t_Tf = 0.15;
end 


i = 1; tt = []; ss = [];
tt(i) = 0;                    ss(i) = 0; i = i+1;
tt(i) = tt(i-1) + p.t_0P;     ss(i) = 0; i = i+1;
tt(i) = tt(i-1) + 0.3*p.t_P;  ss(i) = 0.8*p.a_P; i = i+1;
tt(i) = tt(i-1) + 0.2*p.t_P;  ss(i) = p.a_P; i = i+1;
tt(i) = tt(i-1) + 0.2*p.t_P;  ss(i) = 0.8*p.a_P; i = i+1;
tt(i) = tt(i-1) + 0.3*p.t_P;  ss(i) = 0; i = i+1;
tt(i) = tt(i-1) + p.t_PQ;     ss(i) = 0; i = i+1;
tt(i) = tt(i-1) + p.t_QRS/4;  ss(i) = p.a_Q; i = i+1;
tt(i) = tt(i-1) + p.t_QRS/4;  ss(i) = p.a_R; i = i+1;
tt(i) = tt(i-1) + p.t_QRS/4;  ss(i) = p.a_S; i = i+1;
tt(i) = tt(i-1) + p.t_QRS/4;  ss(i) = 0; i = i+1;
tt(i) = tt(i-1) + p.t_ST;     ss(i) = 0; i = i+1;
tt(i) = tt(i-1) + 0.6*p.t_Tr; ss(i) = 0.8*p.a_T; i = i+1;
tt(i) = tt(i-1) + 0.4*p.t_Tr; ss(i) = p.a_T; i = i+1;
tt(i) = tt(i-1) + 0.4*p.t_Tf; ss(i) = 0.7*p.a_T; i = i+1;
tt(i) = tt(i-1) + 0.6*p.t_Tf; ss(i) = 0; i = i+1;
tt(i) = 1;                    ss(i) = 0; i = i+1;

s = interp1(tt, ss, mod(t/t_RR, 1), 'linear');
