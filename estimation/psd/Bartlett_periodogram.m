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
    P_B = mean(P_segments, 1);  % mean of the L periodograms, frequency by frequency
    fn = -1/2 : 1/M : 1/2 - 1/M;
end