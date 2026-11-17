function trend = proc_trend_2c1(x, N)
    % Estimates the local trend of x: zero-phase filtering, where x is 
    % filtered by h, then by h reversed in time (h = moving average of 
    % N samples). The equivalent filter h(n)*h(-n) is a triangle 
    % of length 2N-1
    % Inputs:
    %   x: input signal (usually the integrated signal y)
    %   N: window size (length of h)
    % Output:
    %   trend: local trend of x (same length as x)

    x = x(:);
    h = ones(1, N) / N;
    h_eq = conv(h, flipud(h)); % Length = 2N-1 ; Shift = N-1

    full = conv(x, h_eq); % Length = 3N-2
    trend_x = full(N:N+length(x)-1);

    trend = trend_x;
end