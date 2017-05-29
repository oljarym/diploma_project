close all
clear

y = rand(1000,1);
fs = 1;
t = (0:length(y)-1)/fs;
i1 = 500;
i2 = 600;

figure;
plot(t, y);
hold on;
area(t(i1:i2), y(i1:i2), 'FaceColor', 'r','EdgeColor','r');