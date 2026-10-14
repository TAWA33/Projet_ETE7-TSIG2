close all ; clear all ; clc;


N = 2000;
R = 0.95;

f1_rej = 1/4; % Normalized
f2_rej = 4/9;

omega1 = 2*pi*f1_rej;
omega2 = 2*pi*f2_rej;

z1 = R * exp(1i*omega1);
z2 = R * exp(-1i*omega2);

fn = -1/2 : 1/N : 1/2 - 1/N;

b = [1, -2*real(z1)-2*real(z2), abs(z1)^2 + abs(z2)^2 + 4*real(z1)*real(z2), -2*real(z1)*abs(z2)^2 -2*real(z2)*abs(z1)^2, abs(z1)^2*abs(z2)^2];
a = 1;


h = freqz(b, a, 2*pi*fn);

u = randn(1, N);
x = filter(b, 1, u);


figure;

subplot(3, 1, 1);
zplane(b, a);
title('Pole-zero diagram');
grid on;

subplot(3, 1, 2);
plot(fn, abs(h), 'LineWidth', 1.5);
xlabel('Normalized frequency f/f_e');
ylabel('|H(f)|');
title('Magnitude response');
grid on;
xlim([-0.5 0.5]);

subplot(3, 1, 3);
plot(fn, angle(h), 'LineWidth', 1.5);
xlabel('Normalized frequency f/f_e');
ylabel('Phase (rad)');
title('Phase response');
grid on;
xlim([-0.5 0.5]);




