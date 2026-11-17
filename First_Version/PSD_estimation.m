% Test script for the PSD estimators: generates an AR(4) process (gaussian
% noise filtered by an all-pole IIR filter with 2 pairs of conjugate poles)
% and compares the 5 PSD estimates to the theoretical PSD
%
close all ; clear all ; clc;

function [P, fn] = periodo(x)
    % Estimates the PSD with the simple periodogram: |FFT(x)|^2 / N,
    % with zero padding up to the next power of 2
    %
    % Input:
    %   x: input signal
    % Outputs:
    %   P: periodogram PSD estimate
    %   fn: normalized frequencies (from -1/2 to 1/2)
    %
    x = x(:);
    N = length(x);
    Nfft = 2^nextpow2(N); % Zero padding to have Nfft = 2^alpha
    X = fftshift(fft(x, Nfft));
    P = abs(X).^2 / N;
    fn = -1/2 : 1/Nfft : 1/2 - 1/Nfft;
end



function [P_D, fn] = Daniell_periodogram(x, M)
    % Estimates the PSD with the Daniell method: the periodogram of x is
    % smoothed by a moving average over M neighboring frequencies
    %
    % Inputs:
    %   x: input signal
    %   M: number of frequencies averaged (must be odd)
    % Outputs:
    %   P_D: Daniell PSD estimate (N - (M-1) points, edges removed)
    %   fn: normalized frequencies matching P_D
    %
    x = x(:);
    N = length(x);
    X = fftshift(fft(x));
    P = abs(X).^2 / N;
    if (mod(M, 2) == 0)
        error('M should be odd.');
    end
    J = (M - 1) / 2;
    P_D = zeros(1, N - 2 * J); % remove the samples at the extremities that do not have neighboring samples on the left or right
    for i = J + 1 : N - J
        P_D(i - J) = mean(P(i - J: i + J));
    end
    fn = -1/2 : 1/N : 1/2 - 1/N;
    fn = fn(J + 1: N - J);
end



function [P_B, fn] = Bartlett_periodogram(x, M)
    % Estimates the PSD with the Bartlett method: x is cut into L
    % segments of length M (no overlap), and the L periodograms are averaged
    %
    % Inputs:
    %   x: input signal
    %   M: length of each segment
    % Outputs:
    %   P_B: Bartlett PSD estimate
    %   fn: normalized frequencies (from -1/2 to 1/2)
    %
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
    P_B = mean(P_segments, 1);  % mean of the L periodograms, frequency by frequency
    fn = -1/2 : 1/M : 1/2 - 1/M;
end


function [P_W, fn] = Welch_periodogram(x, M, k)
    % Estimates the PSD with the Welch method: x is cut into L overlapping
    % segments of length M, each one is windowed by a Hamming window, and
    % the L periodograms are averaged
    %
    % Inputs:
    %   x: input signal
    %   M: length of each segment
    %   k: 1/k is the overlap rate between 2 consecutive segments
    % Outputs:
    %   P_W: Welch PSD estimate
    %   fn: normalized frequencies (from -1/2 to 1/2)
    %
    x = x(:); % to get a column vector, compatible with hamming() that returns a column vector
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
        P_segments(i, :) = abs(fftshift(fft(segment))).^2 / sum(w.^2); % divide by the energy of window for normalization
    end
    P_W = mean(P_segments, 1);
    fn = -1/2 : 1/M : 1/2 - 1/M;
end


function [P_c, fn] = correlogram(x, L)
    % Estimates the PSD with the correlogram: Fourier transform of the
    % unbiased autocorrelation of x, windowed by a Hamming window
    %
    % Inputs:
    %   x: input signal
    %   L: maximum lag of the autocorrelation
    % Outputs:
    %   P_c: correlogram PSD estimate
    %   fn: normalized frequencies (2L+1 points)
    %
    x = x(:); % to get a column vector, compatible with hamming() that returns a column vector
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
    % Plots the 5 PSD estimates of x (periodogram, Daniell, Bartlett,
    % Welch, correlogram), each one compared to the theoretical PSD
    %
    % Inputs:
    %   x: input signal
    %   f: normalized frequencies of the theoretical PSD
    %   DSP: theoretical PSD
    %   M_D: number of frequencies averaged (Daniell)
    %   M: length of each segment (Bartlett and Welch)
    %   k: 1/k is the overlap rate (Welch)
    %   L: maximum lag of the autocorrelation (correlogram)
    %   sigName: signal name (used in the title)
    % No output
    %
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
    sgtitle(['PSD estimates of the ', sigName]);
end




N = 2000;
R = 0.99;
f1_res = 1/3;
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