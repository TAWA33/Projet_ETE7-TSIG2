function [P_B, fn] = Bartlett_periodogram(x, M)
    % Estimates the PSD with the Bartlett method: x is cut into L
    % segments of length M (no overlap), and the L periodograms are averaged
    % Inputs:
    %   x: input signal
    %   M: length of each segment
    % Outputs:
    %   P_B: Bartlett PSD estimate
    %   fn: normalized frequencies (from -1/2 to 1/2)
    
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