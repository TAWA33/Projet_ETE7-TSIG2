close all ; clear all ; clc;

function [P, fn] = periodo(x)
    x = x(:);
    N = length(x);
    Nfft = 2^nextpow2(N);
    X = fftshift(fft(x, Nfft));
    P = abs(X).^2 / N;
    fn = -1/2 : 1/Nfft : 1/2 - 1/Nfft;
end



function [P_D, fn] = Daniell_periodogram(x, M)
    x = x(:);
    N = length(x);
    X = fftshift(fft(x));
    P = abs(X).^2 / N;
    if (mod(M, 2) == 0)
        error('M should be odd.');
    end
    J = (M - 1) / 2;
    P_D = zeros(1, N - 2 * J); % Pour enlever les valeurs aux extremités qui n'ont pas des valeurs voisines à gauche ou à droite
    for i = J + 1 : N - J
        P_D(i - J) = mean(P(i - J: i + J));
    end
    fn = -1/2 : 1/N : 1/2 - 1/N;
    fn = fn(J + 1: N - J);
end



function [P_B, fn] = Bartlett_periodogram(x, M)
    x = x(:);
    N = length(x);   
    if (M > N) 
        error('M must be less than or equal to length(x).');
    end
    L = floor(N / M);
    P_segments = zeros(L, M);
    for i = 1 : L
        segment = x(i*M - M + 1 : i * M);
        P_segments(i, :) = abs(fftshift(fft(segment))).^2 / M;
    end
    P_B = mean(P_segments, 1);  % moyenne des L périodogrammes, fréquence par fréquence (selon les colonnes)
    fn = -1/2 : 1/M : 1/2 - 1/M;
end


function [P_W, fn] = Welch_periodogram(x, M, k)
    x = x(:); % vecteur colonne, compatible avec hamming() qui retounre un vecteur colonne
    N = length(x);
    if (M > N) 
        error('M must be less than or equal to length(x).');
    end
    if (k <= 1)
        error('k must be greater than 1.');
    end
    L = floor((N - M) / (M - floor(M/k))) + 1; 
    P_segments = zeros(L, M);
    w = hamming(M); 
    for i = 1 : L
        segment = x(i*M - (i-1)*(floor(M/k)) - M + 1 : i*M - (i-1)*(floor(M/k)));
        segment = segment.*w;
        P_segments(i, :) = abs(fftshift(fft(segment))).^2 / sum(w.^2); % On divise par l'énergie de la fenêtre pour normaliser 
    end
    P_W = mean(P_segments, 1);
    fn = -1/2 : 1/M : 1/2 - 1/M;
end


function [P_c, fn] = correlogram(x, L)
    x = x(:); % vecteur colonne, compatible avec hamming() qui retounre un vecteur colonne
    N = length(x);
    if (L >= N) 
        error('L must be less than length(x).');
    end
    Rxx = xcorr(x, L, 'unbiased');
    w = hamming(2*L + 1); 
    Rxx_windowed = Rxx.*w;
    P_c = fftshift(fft(ifftshift(Rxx_windowed)));
    % P_c = real(P_c);
    fn = (-L : L) / (2*L + 1);
end


function plot_all_estimates(x, f, DSP, M_D, M, k, L, sigName)
    [P,   fn]   = periodo(x);                        
    [P_D, fn_D] = Daniell_periodogram(x, M_D);       
    [P_B, fn_B] = Bartlett_periodogram(x, M);        
    [P_W, fn_W] = Welch_periodogram(x, M, k);       
    [P_c, fn_c] = correlogram(x, L);                 

    DSP_dB = 10*log10(DSP);

    figure;
    subplot(2, 3, 1);                              
    plot(fn, 10*log10(P)); hold on;
    plot(f, DSP_dB, 'LineWidth', 1.5); hold off;
    title('Periodogram');
    xlabel('Normalized frequency'); ylabel('PSD (dB)');
    grid on;

    subplot(2, 3, 2);  
    plot(fn_D, 10*log10(P_D)); hold on;
    plot(f, DSP_dB, 'LineWidth', 1.5); hold off;
    title(sprintf('Daniell, M = %d', M_D));
    xlabel('Normalized frequency'); ylabel('PSD (dB)');
    grid on;

    subplot(2, 3, 3);                            
    plot(fn_B, 10*log10(P_B)); hold on;
    plot(f, DSP_dB, 'LineWidth', 1.5); hold off;
    title(sprintf('Bartlett, M = %d', M));
    xlabel('Normalized frequency'); ylabel('PSD (dB)');
    grid on;

    subplot(2, 3, 4);                            
    plot(fn_W, 10*log10(P_W)); hold on;
    plot(f, DSP_dB, 'LineWidth', 1.5); hold off;
    title(sprintf('Welch, M = %d, k = %g', M, k));
    xlabel('Normalized frequency'); ylabel('PSD (dB)');
    grid on;

    subplot(2, 3, 5);
    plot(fn_c, 10*log10(P_c)); hold on;
    plot(f, DSP_dB, 'LineWidth', 1.5); hold off;
    title(sprintf('Correlogram, L = %d', L));
    xlabel('Normalized frequency'); ylabel('PSD (dB)');
    grid on;

    legend('Estimate', 'Theoretical PSD', 'Position', [0.72 0.25 0.15 0.08]); 
    sgtitle(['PSD estimates of the ', sigName], 'Color', 'k', 'FontSize', 14, 'FontWeight', 'bold');
end




N = 2000;
R = 0.99;
f1_res = 1/3; % Normalized
f2_res = 3/7;

omega1 = 2*pi*f1_res;
omega2 = 2*pi*f2_res;

p1 = R * exp(1i*omega1);
p2 = R * exp(-1i*omega2);

fn = -1/2 : 1/N : 1/2 - 1/N;

b = 1;
a = poly([p1 conj(p1) p2 conj(p2)]);

h = freqz(b, a, 2*pi*fn);

u = randn(1, N);
x = filter(b, a, u);


sigma2 = 1;                                      
DSP = sigma2 * abs(h).^2;                      
f = fn;                                       

plot_all_estimates(x, f, DSP, 11, 256, 2, 200, 'AR process');
exportgraphics(gcf, './Figures/DSP_estimations.png', 'BackgroundColor', 'white');