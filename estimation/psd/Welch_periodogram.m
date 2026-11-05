function [P_W, fn] = Welch_periodogram(x, M, k)
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