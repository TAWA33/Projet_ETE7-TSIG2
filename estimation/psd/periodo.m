function [P, fn] = periodo(x)
    x = x(:);
    N = length(x);
    Nfft = 2^nextpow2(N); % Zero padding to have Nfft = 2^alpha
    X = fftshift(fft(x, Nfft));
    P = abs(X).^2 / N;
    fn = -1/2 : 1/Nfft : 1/2 - 1/Nfft;
end