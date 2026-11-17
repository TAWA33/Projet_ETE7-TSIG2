function [P, fn] = periodo(x)
    % Estimates the PSD with the simple periodogram: |FFT(x)|^2 / N,
    % with zero padding up to the next power of 2
    % Input:
    %   x: input signal
    % Outputs:
    %   P: periodogram PSD estimate
    %   fn: normalized frequencies (from -1/2 to 1/2)

    x = x(:);
    N = length(x);
    Nfft = 2^nextpow2(N); % Zero padding to have Nfft = 2^alpha
    X = fftshift(fft(x, Nfft));
    P = abs(X).^2 / N;
    fn = -1/2 : 1/Nfft : 1/2 - 1/Nfft;
end