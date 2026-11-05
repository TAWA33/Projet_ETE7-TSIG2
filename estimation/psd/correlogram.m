function [P_c, fn] = correlogram(x, L)
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