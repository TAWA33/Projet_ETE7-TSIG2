function [P_c, fn] = correlogram(x, L)
    % Estimates the PSD with the correlogram: Fourier transform of the
    % unbiased autocorrelation of x, windowed by a Hamming window
    % Inputs:
    %   x: input signal
    %   L: maximum lag of the autocorrelation
    % Outputs:
    %   P_c: correlogram PSD estimate
    %   fn: normalized frequencies
    
    x = x(:); % to get a column vector, compatible with hamming() that returns a column vector
    N = length(x);
    if (L >= N) 
        error('L must be less than length(x).');
    end
    Rxx = xcorr(x, L, 'unbiased');
    w = hamming(2*L + 1); 
    Rxx_windowed = Rxx.*w;
    P_c = fftshift(fft(ifftshift(Rxx_windowed)));
    fn = (-L : L) / (2*L + 1);
end