close all ; clear all ; clc;

function plot_signal(x, y, n)

    mean_x = mean(x);
    mean_y = mean(y);

    strMeanX = sprintf('mean(x) = %.4f', mean_x);
    strMeanY = sprintf('mean(y) = %.4f', mean_y);


    figure('Name','I/O Signals');
    subplot(3, 1, 1);
    plot(1:1:n, y, 'LineWidth', 1.2, 'DisplayName', 'Output y[n]');
    hold on;
    plot(1:1:n, x, 'LineWidth', 1.2, 'DisplayName', 'Input x[n]');
    xlabel('Sample');
    ylabel('Signal');
    title('Input & Output Signal');
    grid on;
    legend('Location','best');
    xlim([1 n]);
    
    subplot(3, 1, 2);
    plot(1:1:n, x);
    xlabel('Sample');
    ylabel('Signal');
    title('Input Signal');
    legend(strMeanX, 'Location', 'northeast');
    grid on;
    
    
    subplot(3, 1, 3);
    plot(1:1:n, y);
    xlabel('Sample');
    ylabel('Signal');
    title('Output signal');
    legend(strMeanY, 'Location', 'northeast');
    grid on;

    sgtitle('Time-domain signals (I/O)', 'Color', 'k', 'FontSize', 14, 'FontWeight', 'bold');
end

function plot_pole_zero_diagram(b, a, fn, h)
    figure('Name','Pôle/Zero + Transf Func');
    title('Pole/Zero diagram + Transfert function');
    
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

    sgtitle('Pole-Zero diagram + Transfer function', 'Color', 'k', 'FontSize', 14, 'FontWeight', 'bold');
end


function plot_signal_properties(u, fn, N, sigName)
    U = fftshift(fft(u));
    periodo = (abs(U).^2) / N; 
    mean_perio = mean(periodo);
    R_uu = xcorr(u, 'biased');
    lags = -(N-1):(N-1);

    strMeanPerio = sprintf('mean(|%s|^2/N) = %.4f', upper(sigName), mean_perio);

    figure('Name', sprintf('%s Properties', sigName));
    
    subplot(3, 1, 1);
    plot(fn, abs(U));
    ylabel(sprintf('|%s(f)|', upper(sigName)));
    xlabel('Normalized frequency f/f_e');
    xlim([-0.5 0.5]);
    title(sprintf('Amplitude spectrum of %s', sigName));
    grid on;

    subplot(3, 1, 2);
    plot(fn, 10*log10(periodo));
    ylabel(sprintf('|%s(f)|^2 / N  (dB)', upper(sigName)));
    xlabel('Normalized frequency f/f_e');
    title(sprintf('Power spectral density estimation of %s', sigName));
    xlim([-0.5 0.5]);
    legend(strMeanPerio, 'Location', 'northeast');
    
    subplot(3, 1, 3);
    plot(lags, R_uu);
    ylabel(sprintf('R_{%s %s}', sigName, sigName));
    xlabel('Lag \tau');
    xlim([-500 500]);
    grid on;
    title(sprintf('Autocorrelation of %s', sigName));
    
    sgtitle(sprintf('Statistical properties of %s', sigName), 'Color', 'k', 'FontSize', 14, 'FontWeight', 'bold');
end

% Etape 1
function y_cum = integrate_signal(x)
    x_cent = x - mean(x);
    y_cum = cumtrapz(1:length(x), x_cent);
end

% Etape 2/a
function trend = proc_trend_2a(x, N, k)
    M = length(x);
    nb_wind = floor(M/N);
    trend_x = zeros(M);
    for i = 1 : nb_wind
        % trend_segm = mean(x((i-1) * N + 1 : i*N));
        p = polyfit(1:N, x((i-1) * N + 1 : i*N), k);
        trend_segm = polyval(p, 1:N);
        
        trend_x((i-1) * N + 1 : i*N) = trend_segm;
    end
    trend = trend_x;
end

% Etape 2/b



% 2.2.a
N = 2000;
R = 0.95;
f1_rej = 1/4; % Normalized
f2_rej = 4/9;

omega1 = 2*pi*f1_rej;
omega2 = 2*pi*f2_rej;

z1 = R * exp(1i*omega1);
z2 = R * exp(-1i*omega2);

fn = -1/2 : 1/N : 1/2 - 1/N;

%b = [1, -2*real(z1)-2*real(z2), abs(z1)^2 + abs(z2)^2 + 4*real(z1)*real(z2), -2*real(z1)*abs(z2)^2 -2*real(z2)*abs(z1)^2, abs(z1)^2*abs(z2)^2];
%a = 1;

b = poly([z1 conj(z1) z2 conj(z2)]);
a = 1;

h = freqz(b, a, 2*pi*fn);

u = randn(1, N);
x = filter(b, a, u);

window_len = 5;
k = 1;
y = integrate_signal(x);
trend_y = proc_trend_2a(y, window_len, k);






% 
% plot_pole_zero_diagram(b, a, fn, h);
% exportgraphics(gcf, './Figures/All_zero_diagram.png', 'BackgroundColor', 'white');
% 
% 
% plot_signal_properties(u, fn, N, 'u');
% exportgraphics(gcf, './Figures/zero_u_prop.png', 'BackgroundColor', 'white');
% 
% 
% plot_signal_properties(x, fn, N, 'x');
% exportgraphics(gcf, './Figures/zero_x_prop.png', 'BackgroundColor', 'white');
% 
% 
% plot_signal(u, x, N);
% exportgraphics(gcf, './Figures/All_zero_Inp_Out.png', 'BackgroundColor', 'white');
% 
% % 2.2.b
% N = 2000;
% R = 0.99;
% f1_res = 1/3; % Normalized
% f2_res = 3/7;
% 
% omega1 = 2*pi*f1_res;
% omega2 = 2*pi*f2_res;
% 
% p1 = R * exp(1i*omega1);
% p2 = R * exp(-1i*omega2);
% 
% fn = -1/2 : 1/N : 1/2 - 1/N;
% 
% b = 1;
% a = poly([p1 conj(p1) p2 conj(p2)]);
% 
% h = freqz(b, a, 2*pi*fn);
% 
% u = randn(1, N);
% x = filter(b, a, u);
% 
% plot_pole_zero_diagram(b, a, fn, h);
% exportgraphics(gcf, './Figures/All_pole_diagram.png', 'BackgroundColor', 'white');
% 
% plot_signal_properties(u, fn, N, 'u');
% exportgraphics(gcf, './Figures/pole_u_prop.png', 'BackgroundColor', 'white');
% 
% plot_signal_properties(x, fn, N, 'x');
% exportgraphics(gcf, './Figures/pole_x_prop.png', 'BackgroundColor', 'white');
% 
% plot_signal(u, x, N);
% exportgraphics(gcf, './Figures/All_pole_Inp_Out.png', 'BackgroundColor', 'white');


